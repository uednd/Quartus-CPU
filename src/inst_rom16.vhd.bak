library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity inst_rom16 is
  port (
    address : in  std_logic_vector(7 downto 0);
    q       : out std_logic_vector(15 downto 0)
  );
end entity;

architecture rtl of inst_rom16 is
  type rom_t is array (0 to 255) of std_logic_vector(15 downto 0);
  constant rom : rom_t := (
    0  => x"5105",
    1  => x"5203",
    2  => x"06C2",
    3  => x"0EC3",
    4  => x"06C0",
    5  => x"06C1",
    6  => x"06C4",
    7  => x"0EC5",
    8  => x"2280",
    9  => x"09C6",
    10 => x"0C47",
    11 => x"4501",
    12 => x"3510",
    13 => x"7110",
    14 => x"6210",
    15 => x"8602",
    16 => x"1000",
    17 => x"C000",
    18 => x"53FF",
    19 => x"9401",
    20 => x"53AD",
    21 => x"A801",
    22 => x"53BE",
    23 => x"B019",
    24 => x"53CC",
    25 => x"1800",
    26 => x"C000",
    others => x"0000"
  );
begin
  q <= rom(to_integer(unsigned(address)));
end architecture;
