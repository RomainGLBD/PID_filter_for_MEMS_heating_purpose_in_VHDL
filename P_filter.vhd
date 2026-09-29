library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity P_filter is
    generic ( 
        REGISTER_LENGTH : integer := 32 
        );
    Port ( error : in SIGNED (REGISTER_LENGTH-1 downto 0);
           K_P : in STD_LOGIC_VECTOR (REGISTER_LENGTH-1 downto 0) ;
           clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           enable : in STD_LOGIC;
           proportional_output : out SIGNED (REGISTER_LENGTH-1 downto 0 )
         );
           
end P_filter;

architecture Behavioral of P_filter is

signal proportional_calcul : SIGNED( REGISTER_LENGTH-1 downto 0) ;

begin

process(clk, rst, error) 
    begin

    
    if ( clk'EVENT AND clk = '1' ) then
        if ( rst = '1' ) then
            proportional_calcul <= TO_SIGNED( 0, REGISTER_LENGTH) ;
        else
            if enable = '1' then
                proportional_calcul <= SIGNED(RESIZE( UNSIGNED(K_P) * UNSIGNED(error), REGISTER_LENGTH)) ;
            end if;
        end if;
    end if;
    
    proportional_output <= proportional_calcul ;
    
end process;

end Behavioral;
