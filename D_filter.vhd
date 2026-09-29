library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity D_filter is
    generic ( 
        REGISTER_LENGTH : integer := 32 
        );
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           enable : in STD_LOGIC;
           K_D : STD_LOGIC_VECTOR ( REGISTER_LENGTH-1 downto 0);
           error : in SIGNED ( REGISTER_LENGTH-1 downto 0);
           derivate_output : out SIGNED (REGISTER_LENGTH-1 downto 0));
end D_filter;


architecture Behavioral of D_filter is

signal derivate_calcul : SIGNED( REGISTER_LENGTH-1 downto 0) ;
signal previous_error : SIGNED (REGISTER_LENGTH-1 downto 0);

begin



process(clk, rst) 
    begin

    
    if ( clk'EVENT AND clk = '1' ) then
        if ( rst = '1') then
            derivate_calcul <= TO_SIGNED( 0, REGISTER_LENGTH) ;
            previous_error <= TO_SIGNED( 0, REGISTER_LENGTH) ;
        else
            if enable = '1' then
                derivate_calcul <= RESIZE( SIGNED(K_D) * (SIGNED(error) - previous_error), REGISTER_LENGTH) ;
                previous_error <= error ;
            end if;
        end if;
    end if;
    
    derivate_output <= derivate_calcul ;

end process;
    
end Behavioral;
