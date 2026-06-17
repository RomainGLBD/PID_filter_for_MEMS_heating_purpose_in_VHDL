library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity I_filter is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           enable : in STD_LOGIC;
           K_I : STD_LOGIC_VECTOR ( 15 downto 0);
           error : in SIGNED (15 downto 0);
           
           integral_output : out SIGNED (15 downto 0));
end I_filter;

architecture Behavioral of I_filter is

signal integral_calcul : SIGNED( 21 downto 0) ;

begin

process(clk, rst, error) 
    begin

    if ( rst = '1' ) then
        integral_calcul <= TO_SIGNED( 0, 22) ;
    else
        
        if ( clk'EVENT AND clk = '1' ) then
            if enable = '1' then
                if integral_calcul + RESIZE( SIGNED(K_I) * error, 22)  > 32767 then -- if the Sum is too high
                    integral_calcul <= TO_SIGNED(32767, 22) ;
                elsif integral_calcul + RESIZE( SIGNED(K_I) * error, 22) < -32768 then -- if the Sum is too low
                    integral_calcul <= TO_SIGNED(-32768, 22) ;
                else
                    integral_calcul <= integral_calcul + RESIZE( SIGNED(K_I) * error, 22) ; -- if -32768 < x < 32767
                end if;
            end if;
        end if;
    end if;
    
    integral_output <= RESIZE(integral_calcul, 16) ;
    
end process;

end Behavioral;