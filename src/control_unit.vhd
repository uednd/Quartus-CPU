library ieee;
use ieee.std_logic_1164.all;

use work.cpu16_pkg.all;

entity control_unit is
  port(
    opcode      : in  std_logic_vector(3 downto 0);
    funct       : in  std_logic_vector(2 downto 0);
    reg_write   : out std_logic;
    mem_write   : out std_logic;
    disp_write  : out std_logic;
    halt_req    : out std_logic;
    alu_ctrl    : out std_logic_vector(3 downto 0);
    alu_src_imm : out std_logic;
    imm_signed  : out std_logic;
    wb_sel      : out std_logic_vector(1 downto 0);
    dest_is_rd  : out std_logic;
    is_branch   : out std_logic;
    branch_op   : out std_logic_vector(1 downto 0);
    is_jump     : out std_logic
  );
end entity;

architecture rtl of control_unit is
begin
  process(opcode, funct)
  begin
    reg_write   <= '0';
    mem_write   <= '0';
    disp_write  <= '0';
    halt_req    <= '0';
    alu_ctrl    <= ALU_ADD;
    alu_src_imm <= '0';
    imm_signed  <= '1';
    wb_sel      <= WB_ALU;
    dest_is_rd  <= '0';
    is_branch   <= '0';
    branch_op   <= "00";
    is_jump     <= '0';

    case opcode is
      when OP_RTYPE =>
        reg_write  <= '1';
        dest_is_rd <= '1';
        wb_sel     <= WB_ALU;
        alu_src_imm<= '0';
        imm_signed <= '1';
        case funct is
          when FUN_OR   => alu_ctrl <= ALU_OR;
          when FUN_AND  => alu_ctrl <= ALU_AND;
          when FUN_ADD  => alu_ctrl <= ALU_ADD;
          when FUN_SUB  => alu_ctrl <= ALU_SUB;
          when FUN_SLLV => alu_ctrl <= ALU_SLL;
          when FUN_SRLV => alu_ctrl <= ALU_SRL;
          when FUN_SRAV => alu_ctrl <= ALU_SRA;
          when FUN_SLT  => alu_ctrl <= ALU_SLT;
          when others   => alu_ctrl <= ALU_ADD;
        end case;

      when OP_DISP =>
        disp_write <= '1';
        imm_signed <= '0';
      when OP_LUI =>
        reg_write   <= '1';
        dest_is_rd  <= '0';
        wb_sel      <= WB_LUI;
        imm_signed  <= '0';
      when OP_ORI =>
        reg_write   <= '1';
        dest_is_rd  <= '0';
        wb_sel      <= WB_ALU;
        alu_ctrl    <= ALU_OR;
        alu_src_imm <= '1';
        imm_signed  <= '0';
      when OP_ANDI =>
        reg_write   <= '1';
        dest_is_rd  <= '0';
        wb_sel      <= WB_ALU;
        alu_ctrl    <= ALU_AND;
        alu_src_imm <= '1';
        imm_signed  <= '0';
      when OP_ADDI =>
        reg_write   <= '1';
        dest_is_rd  <= '0';
        wb_sel      <= WB_ALU;
        alu_ctrl    <= ALU_ADD;
        alu_src_imm <= '1';
        imm_signed  <= '1';
      when OP_LW =>
        reg_write   <= '1';
        dest_is_rd  <= '0';
        wb_sel      <= WB_MEM;
        alu_ctrl    <= ALU_ADD;
        alu_src_imm <= '1';
        imm_signed  <= '1';
      when OP_SW =>
        mem_write   <= '1';
        alu_ctrl    <= ALU_ADD;
        alu_src_imm <= '1';
        imm_signed  <= '1';

      when OP_BEQ =>
        is_branch  <= '1';
        branch_op  <= "00";
        imm_signed <= '1';
      when OP_BNE =>
        is_branch  <= '1';
        branch_op  <= "01";
        imm_signed <= '1';
      when OP_BGT =>
        is_branch  <= '1';
        branch_op  <= "10";
        imm_signed <= '1';
      when OP_JMP =>
        is_jump <= '1';
      when OP_HALT =>
        halt_req <= '1';

      when others =>
        null;
    end case;
  end process;
end architecture;
