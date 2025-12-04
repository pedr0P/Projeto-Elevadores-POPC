library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity pc is
    port ( 
             clk        : in STD_LOGIC := '0';
             reset        : in STD_LOGIC := '0';

             call_detected   : in STD_LOGIC := '0';

             ld_call : out STD_LOGIC := '0';
             enable_dispatch  : out STD_LOGIC := '0';
             clear_call  : out STD_LOGIC := '0'
         );
end pc;

architecture rtl of pc is
    signal status : STD_LOGIC_VECTOR(1 downto 0) := (others => '0');
begin
    process(clk)
    begin
        if (rising_edge(clk)) then
            if (reset = '1') then
                ld_call <= '0';
                enable_dispatch <= '0';
                clear_call <= '0';
            end if;

            if (call_detected = '1') then
                case (status) is
                    when "00" =>
                        ld_call <= '1';
                        enable_dispatch <= '0';
                        clear_call <= '0';
                        status <= "01";
                    when "01" =>
                        ld_call <= '0';
                        enable_dispatch <= '1';
                        clear_call <= '0';
                        status <= "10";
                    when "10" =>
                        ld_call <= '0';
                        enable_dispatch <= '0';
                        clear_call <= '1';
                        status <= "00";
                    when others =>
                end case;
            end if;
        end if;
    end process;
end rtl;
