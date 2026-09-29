library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity I_filter is
    generic ( 
        REGISTER_LENGTH : integer := 32 
        );
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           enable : in STD_LOGIC;
           K_I : STD_LOGIC_VECTOR ( REGISTER_LENGTH-1 downto 0);
           error : in SIGNED (REGISTER_LENGTH-1 downto 0);
           
           integral_output : out SIGNED (REGISTER_LENGTH-1 downto 0));
end I_filter;

architecture Behavioral of I_filter is

signal integral_calcul : SIGNED( REGISTER_LENGTH-1 downto 0) ;

begin

process(clk, rst, error) 
    begin

    
    
    if ( clk'EVENT AND clk = '1' ) then
        if ( rst = '1' ) then
            integral_calcul <= TO_SIGNED( 1000000, REGISTER_LENGTH) ;
        else
        
            if enable = '1' then
                if integral_calcul + RESIZE( SIGNED(K_I) * error, REGISTER_LENGTH)  > TO_SIGNED(2**(REGISTER_LENGTH-1)-1, REGISTER_LENGTH) then -- if the Sum is too high
                    integral_calcul <= TO_SIGNED(2**(REGISTER_LENGTH-1)-1, REGISTER_LENGTH) ;
                elsif integral_calcul + RESIZE( SIGNED(K_I) * error, REGISTER_LENGTH) < TO_SIGNED(0, REGISTER_LENGTH) then -- if the Sum is too low
                    integral_calcul <= TO_SIGNED(0, REGISTER_LENGTH) ;
                else
                    integral_calcul <= integral_calcul + RESIZE( SIGNED(K_I) * error, REGISTER_LENGTH) ; -- if -32768 < x < 32767
                end if;
            end if;
        end if;
    end if;
    
    integral_output <= RESIZE(integral_calcul, REGISTER_LENGTH) ;
    
end process;

end Behavioral;
