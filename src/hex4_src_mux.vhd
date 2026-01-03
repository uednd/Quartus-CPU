library ieee;
use ieee.std_logic_1164.all;

entity hex4_src_mux is
  port(
    sel      : in  std_logic_vector(2 downto 0);
	 ir_in    : in  std_logic_vector(15 downto 0);
    r0_in    : in  std_logic_vector(15 downto 0);
    r1_in    : in  std_logic_vector(15 downto 0);
    r2_in    : in  std_logic_vector(15 downto 0);
    r3_in    : in  std_logic_vector(15 downto 0);
    alu_in   : in  std_logic_vector(15 downto 0);
    memq_in  : in  std_logic_vector(15 downto 0);
	 disp_in  : in  std_logic_vector(15 downto 0);
    y        : out std_logic_vector(15 downto 0)
  );
end entity;

architecture rtl of hex4_src_mux is
begin
  process(sel, disp_in, r0_in, r1_in, r2_in, r3_in, ir_in, alu_in, memq_in)
  begin
    case sel is
      when "000" => y <= disp_in;
      when "001" => y <= r0_in;
      when "010" => y <= r1_in;
      when "011" => y <= r2_in;
      when "100" => y <= r3_in;
      when "101" => y <= ir_in;
      when "110" => y <= alu_in;
      when "111" => y <= memq_in;
      when others => y <= (others => '0');
    end case;
  end process;
end architecture;
