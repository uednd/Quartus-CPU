library ieee;
use ieee.std_logic_1164.all;

entity disp8_to_hex2 is
  port(
    v      : in  std_logic_vector(7 downto 0);
    hex_lo : out std_logic_vector(6 downto 0);
    hex_hi : out std_logic_vector(6 downto 0)
  );
end entity;

architecture rtl of disp8_to_hex2 is
  component hex7seg_active_low is
    port(hex: in std_logic_vector(3 downto 0); seg: out std_logic_vector(6 downto 0));
  end component;
begin
  u0: entity work.hex7seg port map(hex => v(3 downto 0), seg => hex_lo);
  u1: entity work.hex7seg port map(hex => v(7 downto 4), seg => hex_hi);
end architecture;
