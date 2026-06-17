library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Gestion_PWM is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           control_output : in STD_LOGIC ;
           alpha : in SIGNED (15 downto 0);
           n_periode : in UNSIGNED ( 2 downto 0);
           sampling_time : in UNSIGNED(4 downto 0) ; -- permet de gérer le temps niveau haut d'écoute de la tension (ex : 5% du temps => 20) 
           
           logic_output : out STD_LOGIC;
           alim_output : out STD_LOGIC_VECTOR(15 downto 0)
         );
end Gestion_PWM;

architecture Behavioral of Gestion_PWM is

        signal cpt : UNSIGNED(15 downto 0) ;

begin

        process(clk, rst, control_output)
        begin
            
            if rst = '1' then
                cpt <= TO_UNSIGNED(0, 16);
                logic_output <= '0' ;
                alim_output <= "0101010001111010" ; -- 21626 -> 3.3 V         Inverted logic because of PMOS control
            
            elsif clk'event AND clk = '1' then
                if cpt > TO_UNSIGNED(65535, 16)/n_periode then
                    cpt <= TO_UNSIGNED(0, 16);
                else
                    cpt <= cpt + 1 ;
                end if ;
            
                if control_output = '1' then -- On reset et on force la mesure 
                    cpt <= TO_UNSIGNED(65535, 16)/sampling_time;
                    logic_output <= '1' ;
                    alim_output <= "0101010001111010" ; -- 21626 -> 3.3 V         Inverted logic because of PMOS control
                
                else 
                    if alpha < 0 then
                        logic_output <= '0' ;
                        alim_output <= "0101010001111010" ;-- 21626 -> 3.3 V     -- "0010111000010100" ; -- 11796 -> 1.8 V
                        
                    else 
                        if cpt < (UNSIGNED(alpha)*2)/n_periode then -- logic level up
                            logic_output <= '1' ;
                            alim_output <= "0000000000000000" ; 
                        else                          -- logic level down
                            logic_output <= '0' ;
                            alim_output <= "0101010001111010" ;-- 21626 -> 3.3 V     -- "0010111000010100" ; -- 11796 -> 1.8 V
                        
                        end if ;
                
                    end if;
                                       
                end if;    
            end if;    
        end process;

end Behavioral;