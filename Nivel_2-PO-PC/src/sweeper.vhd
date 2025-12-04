library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity sweeper is
    generic (w : natural := 32);
    port (
        signal r_call_up  : in STD_LOGIC_VECTOR(w-1 downto 0);
        signal r_call_down : in STD_LOGIC_VECTOR(w-1 downto 0);

        signal r_scan_priority : in STD_LOGIC;

        signal next_floor : out STD_LOGIC_VECTOR(4 downto 0); -- O andar a ser limpo
        signal next_dir   : out STD_LOGIC; -- 0 para descer, 1 para subir
        signal call_detected : out STD_LOGIC
    );
end sweeper;

architecture comportamental of sweeper is
begin

    process(r_call_up, r_call_down, r_scan_priority)
        variable v_found : boolean;

    begin
        next_floor    <= (others => '0');
        next_dir      <= '0';
        call_detected <= '0';
        v_found       := false;
        
        if r_scan_priority = '0' then
            
            for i in 0 to w-1 loop
                if r_call_up(i) = '1' then
                    next_floor    <= std_logic_vector(to_unsigned(i, 5));
                    next_dir      <= '1';
                    call_detected <= '1';
                    v_found       := true;
                    exit;
                end if;
            end loop;

            if not v_found then
                for i in w-1 downto 0 loop
                    if r_call_down(i) = '1' then
                        next_floor    <= std_logic_vector(to_unsigned(i, 5));
                        next_dir      <= '0';
                        call_detected <= '1';
                        exit; 
                    end if;
                end loop;
            end if;

        else

            for i in w-1 downto 0 loop
                if r_call_down(i) = '1' then
                    next_floor    <= std_logic_vector(to_unsigned(i, 5));
                    next_dir      <= '0';
                    call_detected <= '1';
                    v_found       := true;
                    exit;
                end if;
            end loop;

            if not v_found then
                for i in 0 to w-1 loop
                    if r_call_up(i) = '1' then
                        next_floor    <= std_logic_vector(to_unsigned(i, 5));
                        next_dir      <= '1';
                        call_detected <= '1';
                        exit; 
                    end if;
                end loop;
            end if;
            
        end if;
        
    end process;

end comportamental;