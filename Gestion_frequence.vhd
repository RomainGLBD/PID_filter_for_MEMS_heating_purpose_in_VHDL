library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity gestion_frequence is
    generic (
        CPT_LENGTH : INTEGER := 32
        
        );
        
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           cpt_rst_value : in UNSIGNED(31 downto 0);
           enable : out STD_LOGIC
           );
end gestion_frequence;


architecture Behavioral of gestion_frequence is

signal cpt : unsigned(CPT_LENGTH-1 downto 0) := to_unsigned(0,CPT_LENGTH);

begin

sampling: process (clk, rst)
    begin
        if clk='1' and clk'event then
            if (rst='1' OR cpt = cpt_rst_value) then
                cpt <= to_unsigned(0,CPT_LENGTH);
            else
                cpt <= cpt + 1 ;
            end if;
        end if;
    end process sampling;
    
output: process (cpt)
    begin
        if cpt = cpt_rst_value-1 then
            enable <= '1' ;
        else 
            enable <= '0' ;
                
   end if;
end process output;

end Behavioral;
