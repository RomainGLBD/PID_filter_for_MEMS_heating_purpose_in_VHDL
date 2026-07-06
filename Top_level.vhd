library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity Top_level is
    Port ( clk :                in      STD_LOGIC ;
           rst :                in      STD_LOGIC ;
           inputA :             in      SIGNED (15 downto 0) ; -- valeur de température du MEMS
--           inputB :             in      SIGNED (15 downto 0) ; -- MULTIMETRE
          
           control0 :           in      STD_LOGIC_VECTOR (15 downto 0) ; -- Point de référence de la température (valeur en tension)
           control1 :           in      STD_LOGIC_VECTOR (15 downto 0) ; -- Kp
           control2 :           in      STD_LOGIC_VECTOR (15 downto 0) ; -- Ki
           control3 :           in      STD_LOGIC_VECTOR (15 downto 0) ; -- Kd
           control4 :           in      STD_LOGIC_VECTOR (15 downto 0) ; -- n_period
           control5 :           in      STD_LOGIC_VECTOR (15 downto 0) ; -- sampling time (1/%)
-- not working : control6 :     in      STD_LOGIC_VECTOR (23 downto 0) ; -- Frequency
           
           control_signal :     out     SIGNED (15 downto 0) ; -- valeur de tension destinée à la régulation de la température
           outputb :            out     SIGNED (15 downto 0) ; --  tension de la PWM
           outputc :            out     SIGNED (15 downto 0) ; --  tension de la PWM
          -- PWM :                out     STD_LOGIC ; -- niveau logique de la PWM (échelon)
          
           status0 : out STD_LOGIC_VECTOR (31 downto 0) ;
           status1 : out STD_LOGIC_VECTOR (31 downto 0) ;
           status2 : out STD_LOGIC_VECTOR (31 downto 0) ;
           status3 : out STD_LOGIC_VECTOR (31 downto 0) ;
           status4 : out STD_LOGIC_VECTOR (31 downto 0) ;
           status5 : out STD_LOGIC_VECTOR (31 downto 0) ;
           status6 : out STD_LOGIC_VECTOR (31 downto 0) ;
           status7 : out STD_LOGIC_VECTOR (31 downto 0) ;
           status8 : out STD_LOGIC_VECTOR (31 downto 0) ;
           status9 : out STD_LOGIC_VECTOR (31 downto 0) ;
           status10: out STD_LOGIC_VECTOR (31 downto 0) ;
           status11: out STD_LOGIC_VECTOR (31 downto 0)
           
         );
end Top_level;

architecture Behavioral of Top_level is

signal error :                  SIGNED (15 downto 0) ;
signal proportional_output :    SIGNED (15 downto 0) ;
signal integral_output :        SIGNED (15 downto 0) ;
signal filter_sum_output :      SIGNED (15 downto 0) ;
signal derivate_output :        SIGNED (15 downto 0) ;
signal output_PWM_alim :        STD_LOGIC_VECTOR(15 downto 0) ;
signal E_sampling :             STD_LOGIC ;
signal E_PID_calc :             STD_LOGIC ;
signal output_PWM_logic :       STD_LOGIC ;
signal mux_control :            STD_LOGIC_VECTOR(2 downto 0) ;
signal PIDF_output :            SIGNED (15 downto 0) ;
signal feedback_averaged :      SIGNED (15 downto 0) ;

begin

Feedback_filter_bloc : entity work.feedback_filter
   PORT MAP (
                clk                    => clk,
                rst                    => rst,
                enable                 => E_PID_calc,
                feedback_input         => inputA,
                feedback_filter_output => feedback_averaged       
        );

  
Error_bloc : entity work.Error
    PORT MAP( 
                feedback    => feedback_averaged,
                setpoint    => control0,
                enable      => E_PID_calc,
                error       => error
            );

P_filter_bloc : entity work.P_filter
    PORT MAP (  clk                 => clk ,
                enable              => E_PID_calc,
                rst                 => rst,
                error               => error,
                K_P                 => control1,
                proportional_output => proportional_output
             );
             
I_filter_bloc : entity work.I_filter
    PORT MAP (  clk             => clk ,
                enable          => E_PID_calc,
                rst             => rst,
                error           => error,
                K_I             => control2,
                integral_output => integral_output
             );
             
D_filter_bloc : entity work.D_filter
    PORT MAP (  clk             => clk ,
                enable          => E_PID_calc,
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
                clk             => clk , --clk_bis,
                rst             => rst,
             --   frequency       => control6,
                sampling_time   => UNSIGNED(control5(4 downto 0)),
                enable_sampling => E_sampling,
                enable_PID_calc => E_PID_calc
        );


Gestion_PWM_bloc : entity work.Gestion_PWM
   PORT MAP (
                clk                   => clk , --clk_bis,
                rst                   => rst,
                control_output        => E_sampling,
                alpha                 => PIDF_output,
              --  frequency       => control6,
                sampling_time         => UNSIGNED(control5(4 downto 0)),
                n_periode             => UNSIGNED(control4(3 downto 0)),
                logic_output          => output_PWM_logic,
                alim_output           => output_PWM_alim
        );
  

F_filter_bloc : entity work.F_filter
   PORT MAP (
                clk                   => clk,
                rst                   => rst,
                enable                => E_PID_calc,
                pid_input             => filter_sum_output,
                filter_output         => PIDF_output       
        );
  
control_signal <= SIGNED(output_PWM_alim) ;
-- output_control_PWM <= output_PWM_logic ;

status0 <= STD_LOGIC_VECTOR(RESIZE(filter_sum_output, 32)) ;    -- feedback PID
status1 <= STD_LOGIC_VECTOR(RESIZE(proportional_output, 32)) ;  -- P out
status2 <= STD_LOGIC_VECTOR(RESIZE(integral_output, 32)) ;      -- I out
status3 <= STD_LOGIC_VECTOR(RESIZE(derivate_output, 32)) ;      -- D out

status4 <= STD_LOGIC_VECTOR(RESIZE(error, 32)) ;                -- Error
status5 <= STD_LOGIC_VECTOR(RESIZE(inputA, 32)) ;               -- MEMS input voltage ( input A)
status6(0) <= E_sampling ;                                      -- Voltage value recovery
status7(0) <= output_PWM_logic ;                                -- PWM logic level
status9(15 downto 0) <= control0 ;                              -- Ref Voltage
-- status10 <= STD_LOGIC_VECTOR(RESIZE(inputB, 32));               -- MULTIMETRE
status11(15 downto 0) <= output_PWM_alim ;                      -- PWM power supply level value

outputb <= SIGNED(PIDF_output) ;
outputc <= filter_sum_output ;
-- PWM <= status7(0) ;                                             -- PWM logic level (for output B)

end Behavioral;
