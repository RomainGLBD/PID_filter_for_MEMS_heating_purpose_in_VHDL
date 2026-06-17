library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity gestion_frequence is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           sampling_time : in UNSIGNED(4 downto 0) ; -- permet de gérer le temps niveau haut d'écoute de la tension (ex : 5% du temps => 20) 
           
           enable_sampling : out STD_LOGIC ;-- (permet de gérer la fréquence de prise de tension du MEMS)
           enable_PID_calc : out STD_LOGIC  --Allow P, I, D calcul
           );
end gestion_frequence;


architecture Behavioral of gestion_frequence is

signal cpt_sampling : unsigned(15 downto 0) := to_unsigned(0,16);

begin

sampling: process (clk, rst)
    begin
        if (rst='1') then
            cpt_sampling <= to_unsigned(0,16);
        elsif clk='1' and clk'event then
            if cpt_sampling = TO_UNSIGNED(65535, 16) then
                cpt_sampling <= TO_UNSIGNED( 0, 16) ;
            else
                cpt_sampling <= cpt_sampling + 1;
            end if;
        end if;
    end process sampling;
    
calcul_output: process (cpt_sampling)
    begin
        if cpt_sampling > TO_UNSIGNED(65535, 16) - TO_UNSIGNED(65535, 16)/sampling_time then
            enable_sampling <= '1';
            if cpt_sampling = TO_UNSIGNED(65535, 16) - (TO_UNSIGNED(65535, 16)/sampling_time)/2 then -- the center of the sampling signal (to be sure to get the right Voltage info
                enable_PID_calc <= '1' ;
            else 
                enable_PID_calc <= '0' ;
            end if ;
       else
          enable_sampling <= '0';
          enable_PID_calc <= '0'; 
       end if;
end process calcul_output;

end Behavioral;