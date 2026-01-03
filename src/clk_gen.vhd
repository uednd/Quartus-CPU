library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity clk_gen is
  port (
    clk50    : in  std_logic;
    sw9      : in  std_logic;
    key1_n   : in  std_logic;
    reset_n  : in  std_logic;
    clk_cpu  : out std_logic
  );
end entity;

architecture rtl of clk_gen is
  signal div_cnt  : unsigned(20 downto 0) := (others => '0');
  signal clk_slow : std_logic := '0';

  signal k1_ff1, k1_ff2, k1_ff2_d : std_logic := '1';
  signal step_pulse : std_logic := '0';
begin
  process(clk50, reset_n)
  begin
    if reset_n = '0' then
      div_cnt   <= (others => '0');
      clk_slow  <= '0';
      k1_ff1    <= '1';
      k1_ff2    <= '1';
      k1_ff2_d  <= '1';
      step_pulse<= '0';
    elsif rising_edge(clk50) then
      div_cnt  <= div_cnt + 1;
      clk_slow <= std_logic(div_cnt(20));

      k1_ff1   <= key1_n;
      k1_ff2   <= k1_ff1;
      k1_ff2_d <= k1_ff2;

      if (k1_ff2_d = '1') and (k1_ff2 = '0') then
        step_pulse <= '1';
      else
        step_pulse <= '0';
      end if;
    end if;
  end process;

  clk_cpu <= clk_slow when sw9='1' else step_pulse;
end architecture;
