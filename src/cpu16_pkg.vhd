library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package cpu16_pkg is
  constant OP_RTYPE : std_logic_vector(3 downto 0) := "0000";
  
  constant OP_DISP  : std_logic_vector(3 downto 0) := "0001";
  constant OP_LUI   : std_logic_vector(3 downto 0) := "0010";
  constant OP_ORI   : std_logic_vector(3 downto 0) := "0011";
  constant OP_ANDI  : std_logic_vector(3 downto 0) := "0100";
  constant OP_ADDI  : std_logic_vector(3 downto 0) := "0101";
  constant OP_LW    : std_logic_vector(3 downto 0) := "0110";
  constant OP_SW    : std_logic_vector(3 downto 0) := "0111";
  constant OP_BEQ   : std_logic_vector(3 downto 0) := "1000";
  constant OP_BNE   : std_logic_vector(3 downto 0) := "1001";
  constant OP_BGT   : std_logic_vector(3 downto 0) := "1010";
  constant OP_JMP   : std_logic_vector(3 downto 0) := "1011";
  constant OP_HALT  : std_logic_vector(3 downto 0) := "1100";

  constant FUN_OR   : std_logic_vector(2 downto 0) := "000";
  constant FUN_AND  : std_logic_vector(2 downto 0) := "001";
  constant FUN_ADD  : std_logic_vector(2 downto 0) := "010";
  constant FUN_SUB  : std_logic_vector(2 downto 0) := "011";
  constant FUN_SLLV : std_logic_vector(2 downto 0) := "100";
  constant FUN_SRLV : std_logic_vector(2 downto 0) := "101";
  constant FUN_SRAV : std_logic_vector(2 downto 0) := "110";
  constant FUN_SLT  : std_logic_vector(2 downto 0) := "111";

  constant ALU_ADD : std_logic_vector(3 downto 0) := "0000";
  constant ALU_SUB : std_logic_vector(3 downto 0) := "0001";
  constant ALU_AND : std_logic_vector(3 downto 0) := "0010";
  constant ALU_OR  : std_logic_vector(3 downto 0) := "0011";
  constant ALU_SLL : std_logic_vector(3 downto 0) := "0110";
  constant ALU_SRL : std_logic_vector(3 downto 0) := "0111";
  constant ALU_SRA : std_logic_vector(3 downto 0) := "1000";
  constant ALU_SLT : std_logic_vector(3 downto 0) := "1001";
  
  constant WB_ALU : std_logic_vector(1 downto 0) := "00";
  constant WB_MEM : std_logic_vector(1 downto 0) := "01";
  constant WB_LUI : std_logic_vector(1 downto 0) := "10";

  function sext8(x : std_logic_vector(7 downto 0)) return std_logic_vector;
  function zext8(x : std_logic_vector(7 downto 0)) return std_logic_vector;
end package;

package body cpu16_pkg is
  function sext8(x : std_logic_vector(7 downto 0)) return std_logic_vector is
  begin
    return std_logic_vector(resize(signed(x), 16));
  end function;

  function zext8(x : std_logic_vector(7 downto 0)) return std_logic_vector is
  begin
    return std_logic_vector(resize(unsigned(x), 16));
  end function;
end package body;
