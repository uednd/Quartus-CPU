library ieee;
use ieee.std_logic_1164.all;

entity disp16_to_hex4 is
  port(
    data : in  std_logic_vector(15 downto 0);
    hex0 : out std_logic_vector(6 downto 0);
    hex1 : out std_logic_vector(6 downto 0);
    hex2 : out std_logic_vector(6 downto 0);
    hex3 : out std_logic_vector(6 downto 0)
  );
end entity;

architecture rtl of disp16_to_hex4 is
begin
  u0: entity work.hex7seg port map(hex => data(3 downto 0),   seg => hex0);
  u1: entity work.hex7seg port map(hex => data(7 downto 4),   seg => hex1);
  u2: entity work.hex7seg port map(hex => data(11 downto 8),  seg => hex2);
  u3: entity work.hex7seg port map(hex => data(15 downto 12), seg => hex3);
end architecture;
