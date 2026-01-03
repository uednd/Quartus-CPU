library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity regfile4x16 is
  port(
    clk      : in  std_logic;
    reset_n  : in  std_logic;
    ra0      : in  std_logic_vector(1 downto 0);
    ra1      : in  std_logic_vector(1 downto 0);
    rd0      : out std_logic_vector(15 downto 0);
    rd1      : out std_logic_vector(15 downto 0);
    we       : in  std_logic;
    wa       : in  std_logic_vector(1 downto 0);
    wd       : in  std_logic_vector(15 downto 0);
    dbg_r0   : out std_logic_vector(15 downto 0);
    dbg_r1   : out std_logic_vector(15 downto 0);
    dbg_r2   : out std_logic_vector(15 downto 0);
    dbg_r3   : out std_logic_vector(15 downto 0)
  );
end entity;

architecture rtl of regfile4x16 is
  type reg_array is array (0 to 3) of std_logic_vector(15 downto 0);
  signal r : reg_array := (others => (others => '0'));
begin
  rd0 <= r(to_integer(unsigned(ra0)));
  rd1 <= r(to_integer(unsigned(ra1)));

  dbg_r0 <= r(0);
  dbg_r1 <= r(1);
  dbg_r2 <= r(2);
  dbg_r3 <= r(3);

  process(clk, reset_n)
  begin
    if reset_n = '0' then
      r <= (others => (others => '0'));
    elsif rising_edge(clk) then
      if we = '1' then
        r(to_integer(unsigned(wa))) <= wd;
      end if;
    end if;
  end process;
  
end architecture;
