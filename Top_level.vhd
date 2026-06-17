library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity Top_level is
    Port ( clk :                in      STD_LOGIC ;
           rst :                in      STD_LOGIC ;
           inputA :             in      SIGNED (15 downto 0) ; -- valeur de température du MEMS
          
           control0 :           in      STD_LOGIC_VECTOR (15 downto 0) ; -- Point de référence de la température (valeur en tension)
           control1 :           in      STD_LOGIC_VECTOR (15 downto 0) ; -- Kp
           control2 :           in      STD_LOGIC_VECTOR (15 downto 0) ; -- Ki
           control3 :           in      STD_LOGIC_VECTOR (15 downto 0) ; -- Kd
           control4 :           in      STD_LOGIC_VECTOR (15 downto 0) ; -- Kd
           control5 :           in      STD_LOGIC_VECTOR (15 downto 0) ; -- Kd
           
           control_signal :     out     SIGNED (15 downto 0) ; -- valeur de tension destinée à la régulation de la température
           output_control_PWM : out     STD_LOGIC  -- niveau haut et bas en tension de la PWM
           
         );
end Top_level;

architecture Behavioral of Top_level is

signal error :                  SIGNED (15 downto 0) ;
signal proportional_output :    SIGNED (15 downto 0) ;
signal integral_output :        SIGNED (15 downto 0) ;
signal filter_sum_output :      SIGNED (15 downto 0) ;
signal derivate_output :        SIGNED (15 downto 0) ;
signal output_PWM_alim :        STD_LOGIC_VECTOR(15 downto 0) ;
signal E_sampling :             STD_LOGIC;
signal E_PID_calc :             STD_LOGIC ;
signal output_PWM_logic :       STD_LOGIC;

begin

Error_bloc : entity work.Error
    PORT MAP( 
                feedback    => inputA,
                setpoint    => control0,
                enable      => E_PID_calc,
                error       => error
            );

P_filter_bloc : entity work.P_filter
    PORT MAP (clk       => clk ,
    enable      => E_PID_calc,
                rst                 => rst,
                error               => error,
                K_P                 => control1,
                proportional_output => proportional_output
             );
             
I_filter_bloc : entity work.I_filter
    PORT MAP (clk       => clk ,
    enable      => E_PID_calc,
                rst             => rst,
                error           => error,
                K_I             => control2,
                integral_output => integral_output
             );
             
D_filter_bloc : entity work.D_filter
    PORT MAP (clk       => clk ,
    enable      => E_PID_calc,
                rst             => rst,
                error           => error,
                K_D             => control3,
                derivate_output => derivate_output
             );
                

Sum_filter_bloc : entity work.Sum_filter
    PORT MAP (
                proportional_input  => proportional_output,
                integral_input      => integral_output,
                derivate_input      => derivate_output,
                sum_output          => filter_sum_output
             );


Gestion_frequence_bloc : entity work.gestion_frequence
    PORT MAP (
                clk       => clk , --clk_bis,
                rst       => rst,
                sampling_time => UNSIGNED(control5(4 downto 0)),
                enable_sampling => E_sampling,
                enable_PID_calc => E_PID_calc
        );


Gestion_PWM_bloc : entity work.Gestion_PWM
   PORT MAP (
                clk                 => clk , --clk_bis,
                rst                 => rst,
                control_output       => E_sampling,
                alpha               => filter_sum_output,
                sampling_time => UNSIGNED(control5(4 downto 0)),
                n_periode          => UNSIGNED(control4(2 downto 0)),
                logic_output => output_PWM_logic,
                alim_output  => output_PWM_alim
        );

control_signal <= SIGNED(filter_sum_output) ;
output_control_PWM <= output_PWM_logic ;

end Behavioral;
