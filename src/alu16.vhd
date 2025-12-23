library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.cpu16_pkg.all;

entity alu16 is
  port(
    a        : in  std_logic_vector(15 downto 0);
    b        : in  std_logic_vector(15 downto 0);
    alu_ctrl : in  std_logic_vector(3 downto 0);
    y        : out std_logic_vector(15 downto 0);
    zero     : out std_logic
  );
end entity;

architecture rtl of alu16 is
  signal res : std_logic_vector(15 downto 0);
  signal shamt : integer range 0 to 15;
begin
  shamt <= to_integer(unsigned(b(3 downto 0)));

  process(a, b, alu_ctrl, shamt)
    variable ua, ub : unsigned(15 downto 0);
    variable sa, sb : signed(15 downto 0);
  begin
    ua := unsigned(a);
    ub := unsigned(b);
    sa := signed(a);
    sb := signed(b);

    case alu_ctrl is
      when ALU_ADD =>
        res <= std_logic_vector(ua + ub);
      when ALU_SUB =>
        res <= std_logic_vector(ua - ub);
      when ALU_AND =>
        res <= a and b;
      when ALU_OR  =>
        res <= a or b;
      when ALU_SLL =>
        res <= std_logic_vector(shift_left(ua, shamt));
      when ALU_SRL =>
        res <= std_logic_vector(shift_right(ua, shamt));
      when ALU_SRA =>
        res <= std_logic_vector(shift_right(sa, shamt));
      when ALU_SLT =>
        if sa < sb then
          res <= (0 => '1', others => '0');
        else
          res <= (others => '0');
        end if;
      when others =>
        res <= (others => '0');
    end case;
  end process;

  y    <= res;
  zero <= '1' when res = x"0000" else '0';
end architecture;
