library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity data_ram16 is
  port (
    address : in  std_logic_vector(7 downto 0);
    clock   : in  std_logic;
    data    : in  std_logic_vector(15 downto 0);
    wren    : in  std_logic;
    q       : out std_logic_vector(15 downto 0)
  );
end entity;

architecture rtl of data_ram16 is
  type ram_t is array (0 to 255) of std_logic_vector(15 downto 0);
  signal ram : ram_t := (others => (others => '0'));
  
begin
  q <= ram(to_integer(unsigned(address)));
  
  process(clock)
  begin
    if rising_edge(clock) then
      if wren = '1' then
        ram(to_integer(unsigned(address))) <= data;
      end if;
    end if;
  end process;
end architecture;
