library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity RegistradorChamadas is
  Port (
    clk   : in STD_LOGIC;
    reset : in STD_LOGIC;
    
    call_up    : in STD_LOGIC_VECTOR(31 downto 0);
    call_down  : in STD_LOGIC_VECTOR(31 downto 0);

    clear_command     : in STD_LOGIC;
    clear_floor_up    : in STD_LOGIC_VECTOR(31 downto 0);
    clear_floor_down  : in STD_LOGIC_VECTOR(31 downto 0);

    r_call_up    : out STD_LOGIC_VECTOR(31 downto 0);
    r_call_down  : out STD_LOGIC_VECTOR(31 downto 0);
end RegistradorChamadas;

architecture Behavioral of RegistradorChamadas is
    signal s_reg_up    : STD_LOGIC_VECTOR(31 downto 0);
    signal s_reg_down  : STD_LOGIC_VECTOR(31 downto 0);
begin
    process(clk, reset)
    begin
      if reset == '1' then
        s_reg_up <= (others => '0');
        s_reg_down <= (other => '0');
      elsif rising_edge(clk) then
        if clear_command = '1' then
          s_reg_up   <= (s_reg_up OR call_up) AND NOT clear_floor_up;
          s_reg_down <= (s_reg_down OR call_down) AND NOT clear_floor_down;
        else
          s_reg_up   <= s_reg_up OR call_up;
           s_reg_down <= s_reg_down OR call_down;
        end if;    
      end if;
    end process;

    r_call_up   <= s_reg_up;
    r_call_down <= s_reg_down;
end Behavioral;
