library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.cpu16_pkg.all;

entity cpu_core is
  port(
    clk       : in  std_logic;
    reset_n   : in  std_logic;

    pc_out    : out std_logic_vector(15 downto 0);
    ir_out    : out std_logic_vector(15 downto 0);
    r0_out    : out std_logic_vector(15 downto 0);
    r1_out    : out std_logic_vector(15 downto 0);
    r2_out    : out std_logic_vector(15 downto 0);
    r3_out    : out std_logic_vector(15 downto 0);
    alu_out   : out std_logic_vector(15 downto 0);
    mem_q_out : out std_logic_vector(15 downto 0);

    disp_out  : out std_logic_vector(15 downto 0);
    halted    : out std_logic
  );
end entity;

architecture rtl of cpu_core is
  signal pc_reg, pc_next, pc_plus1 : std_logic_vector(15 downto 0);

  signal ir : std_logic_vector(15 downto 0);

  signal opcode : std_logic_vector(3 downto 0);
  signal rs, rt, rd : std_logic_vector(1 downto 0);
  signal funct : std_logic_vector(2 downto 0);
  signal imm8  : std_logic_vector(7 downto 0);
  signal addr12: std_logic_vector(11 downto 0);

  signal rs_val, rt_val : std_logic_vector(15 downto 0);
  signal rf_we          : std_logic;
  signal rf_wa          : std_logic_vector(1 downto 0);
  signal rf_wd          : std_logic_vector(15 downto 0);

  signal reg_write_s, mem_write_s, disp_write_s, halt_req_s : std_logic;
  signal alu_ctrl_s : std_logic_vector(3 downto 0);
  signal alu_src_imm_s, imm_signed_s : std_logic;
  signal wb_sel_s : std_logic_vector(1 downto 0);
  signal dest_is_rd_s : std_logic;
  signal is_branch_s : std_logic;
  signal branch_op_s : std_logic_vector(1 downto 0);
  signal is_jump_s   : std_logic;

  signal imm_ext : std_logic_vector(15 downto 0);
  signal lui_val : std_logic_vector(15 downto 0);

  signal alu_a, alu_b, alu_y : std_logic_vector(15 downto 0);

  signal mem_addr : std_logic_vector(7 downto 0);
  signal mem_q    : std_logic_vector(15 downto 0);

  signal eq_s, gt_s : std_logic;
  signal branch_taken : std_logic;
  signal branch_target : std_logic_vector(15 downto 0);
  signal jump_target   : std_logic_vector(15 downto 0);

  signal halted_reg : std_logic;
  signal disp_reg   : std_logic_vector(15 downto 0);
begin
  pc_out    <= pc_reg;
  ir_out    <= ir;
  alu_out   <= alu_y;
  mem_q_out <= mem_q;
  disp_out  <= disp_reg;
  halted    <= halted_reg;

  u_rom: entity work.inst_rom16
    port map (
      address => pc_reg(7 downto 0),
      q       => ir
    );

  opcode <= ir(15 downto 12);
  rs     <= ir(11 downto 10);
  rt     <= ir(9 downto 8);
  rd     <= ir(7 downto 6);
  funct  <= ir(2 downto 0);
  imm8   <= ir(7 downto 0);
  addr12 <= ir(11 downto 0);

  u_rf: entity work.regfile4x16
    port map(
      clk     => clk,
      reset_n => reset_n,
      ra0     => rs,
      ra1     => rt,
      rd0     => rs_val,
      rd1     => rt_val,
      we      => rf_we,
      wa      => rf_wa,
      wd      => rf_wd,
      dbg_r0  => r0_out,
      dbg_r1  => r1_out,
      dbg_r2  => r2_out,
      dbg_r3  => r3_out
    );

  u_ctl: entity work.control_unit
    port map(
      opcode      => opcode,
      funct       => funct,
      reg_write   => reg_write_s,
      mem_write   => mem_write_s,
      disp_write  => disp_write_s,
      halt_req    => halt_req_s,
      alu_ctrl    => alu_ctrl_s,
      alu_src_imm => alu_src_imm_s,
      imm_signed  => imm_signed_s,
      wb_sel      => wb_sel_s,
      dest_is_rd  => dest_is_rd_s,
      is_branch   => is_branch_s,
      branch_op   => branch_op_s,
      is_jump     => is_jump_s
    );

  imm_ext <= sext8(imm8) when imm_signed_s='1' else zext8(imm8);
  lui_val <= imm8 & x"00";

  alu_a <= rs_val;
  alu_b <= imm_ext when alu_src_imm_s='1' else rt_val;

  u_alu: entity work.alu16
    port map(
      a        => alu_a,
      b        => alu_b,
      alu_ctrl => alu_ctrl_s,
      y        => alu_y,
      zero     => open
    );

  mem_addr <= alu_y(7 downto 0);

  u_ram: entity work.data_ram16
    port map(
      address => mem_addr,
      clock   => clk,
      data    => rt_val,
      wren    => (mem_write_s and (not halted_reg)),
      q       => mem_q
    );

  process(wb_sel_s, alu_y, mem_q, lui_val)
  begin
    case wb_sel_s is
      when WB_ALU => rf_wd <= alu_y;
      when WB_MEM => rf_wd <= mem_q;
      when WB_LUI => rf_wd <= lui_val;
      when others => rf_wd <= (others => '0');
    end case;
  end process;

  rf_wa <= rd when dest_is_rd_s='1' else rt;
  rf_we <= reg_write_s and (not halted_reg);

  eq_s <= '1' when rs_val = rt_val else '0';
  gt_s <= '1' when signed(rs_val) > signed(rt_val) else '0';

  branch_taken <= '1' when (is_branch_s='1' and (
                     (branch_op_s="00" and eq_s='1') or
                     (branch_op_s="01" and eq_s='0') or
                     (branch_op_s="10" and gt_s='1')
                   )) else '0';

  pc_plus1 <= std_logic_vector(unsigned(pc_reg) + 1);

  branch_target <= std_logic_vector(signed(pc_plus1) + signed(sext8(imm8)));

  jump_target <= pc_reg(15 downto 12) & addr12;

  process(pc_reg, pc_plus1, branch_taken, branch_target, is_jump_s, jump_target, halted_reg, halt_req_s)
  begin
    if (halt_req_s='1') or (halted_reg='1') then
      pc_next <= pc_reg;
    elsif is_jump_s='1' then
      pc_next <= jump_target;
    elsif branch_taken='1' then
      pc_next <= branch_target;
    else
      pc_next <= pc_plus1;
    end if;
  end process;

  process(clk, reset_n)
  begin
    if reset_n='0' then
      pc_reg     <= (others => '0');
      halted_reg <= '0';
      disp_reg   <= (others => '0');
    elsif rising_edge(clk) then
      if halted_reg='0' then
        pc_reg <= pc_next;

        if halt_req_s='1' then
          halted_reg <= '1';
        end if;

        if disp_write_s='1' then
          disp_reg <= rs_val;
        end if;
      end if;
    end if;
  end process;

end architecture;
