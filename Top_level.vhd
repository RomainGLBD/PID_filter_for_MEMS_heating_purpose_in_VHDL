library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity Top_level is
    generic ( 
        RESISTANCE_VALUE : integer := 32 ;
        REGISTER_LENGTH : integer := 32
    );
  
    Port ( clk :                in      STD_LOGIC ;
           rst :                in      STD_LOGIC ; -- LSB of the last Control REGISTER
           inputA :             in      SIGNED (15 downto 0) ; -- MEMS voltage value
           inputB :             in      SIGNED (15 downto 0) ; -- Wheatstone Bridge
          
           control0 :           in      STD_LOGIC_VECTOR (REGISTER_LENGTH-1 downto 0) ; -- Resistance reference value
           control1 :           in      STD_LOGIC_VECTOR (REGISTER_LENGTH-1 downto 0) ; -- Kp
           control2 :           in      STD_LOGIC_VECTOR (REGISTER_LENGTH-1 downto 0) ; -- Ki
           control3 :           in      STD_LOGIC_VECTOR (REGISTER_LENGTH-1 downto 0) ; -- Kd
           control4 :           in      STD_LOGIC_VECTOR (REGISTER_LENGTH-1 downto 0) ; -- Resistance value of the resistor in series with the MEMS 
           control5 :           in      STD_LOGIC_VECTOR (REGISTER_LENGTH-1 downto 0) ; -- cpt value for the PID enable
           control6 :           in      STD_LOGIC_VECTOR (REGISTER_LENGTH-1 downto 0) ; -- Power supply value of the MEMS that's used for the current calculus
          
           control_signal :     out     SIGNED (15 downto 0) ; -- Output voltage value
           outputb :            out     SIGNED (15 downto 0) ; -- NOTHING


           -- You can found the description of each status register at the end 
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
signal enable :                 STD_LOGIC ;
signal error :                  SIGNED (REGISTER_LENGTH-1 downto 0) ;
signal proportional_output :    SIGNED (REGISTER_LENGTH-1 downto 0) ;
signal integral_output :        SIGNED (REGISTER_LENGTH-1 downto 0) ;
signal derivate_output :        SIGNED (REGISTER_LENGTH-1 downto 0) ;
signal PIDF_output :            SIGNED (REGISTER_LENGTH-1 downto 0) ;
signal feedback_averaged :      SIGNED (REGISTER_LENGTH-1 downto 0) ;
signal output_filter :          UNSIGNED (REGISTER_LENGTH-1 downto 0) ;
signal filter_sum_output :      SIGNED (15 downto 0) ;

signal val :                    STD_LOGIC ;

signal quotient : STD_LOGIC_VECTOR(31 downto 0) ;

begin

Filter : entity work.Input_filter
    PORT MAP (  
                input   => RESIZE(inputA, REGISTER_LENGTH),
                clk     => clk,
                rst     => rst,
                output  => output_filter
           );

Error_bloc : entity work.Error
    PORT MAP( 
                clk                 => clk,
                rst                 => rst,
                --enable              => enable, 
                feedback            => output_filter,
                setpoint            => UNSIGNED(control0),
                previous_control    => RESIZE(UNSIGNED(control6), REGISTER_LENGTH), --RESIZE(UNSIGNED(filter_sum_output), REGISTER_LENGTH),
                res_value           => UNSIGNED(control4(RESISTANCE_VALUE-1 downto 0)),
                output_error        => error,
                res_div => quotient,
                val                 => '1' -- enable 
            );

P_filter_bloc : entity work.P_filter
    PORT MAP (  clk                 => clk ,
                rst                 => rst,
                enable              => enable, 
                error               => error,
                K_P                 => control1,
                proportional_output => proportional_output
             );
             
I_filter_bloc : entity work.I_filter
    PORT MAP (  clk             => clk ,
                rst             => rst,
                enable          => enable,
                error           => error,
                K_I             => control2,
                integral_output => integral_output
             );
             
D_filter_bloc : entity work.D_filter
    PORT MAP (  clk             => clk ,
                rst             => rst,
                error           => error,
                enable          => enable,
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

gestion_frequence_bloc : entity work.gestion_frequence
    PORT MAP (
                clk            => clk , 
                rst            => rst,
                cpt_rst_value  => UNSIGNED(control5), -- TO_UNSIGNED(1000000, REGISTER_LENGTH), --
                enable         => enable
        );

  
control_signal <= SIGNED(filter_sum_output) ;

status0 <= STD_LOGIC_VECTOR(RESIZE(filter_sum_output, 32)) ;    -- feedback PID
status1 <= STD_LOGIC_VECTOR(RESIZE(proportional_output, 32)) ;  -- P out
status2 <= STD_LOGIC_VECTOR(RESIZE(integral_output, 32)) ;      -- I out
status3 <= STD_LOGIC_VECTOR(RESIZE(derivate_output, 32)) ;      -- D out

status4 <= STD_LOGIC_VECTOR(RESIZE(error, 32)) ;                -- Error
status5 <= STD_LOGIC_VECTOR(RESIZE(inputA, 32)) ;               -- MEMS input voltage ( input A)

status6 <= quotient ; 
status7 <= STD_LOGIC_VECTOR(RESIZE(output_filter, 32)) ;
--outputb <= SIGNED(PIDF_output) ; -- Output filter

end Behavioral;
