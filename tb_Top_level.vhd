library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity Top_level_tb is
end;

architecture bench of Top_level_tb is

  component Top_level
      Port ( clk :                in      STD_LOGIC ;
             rst :                in      STD_LOGIC ;
             inputA :             in      SIGNED (15 downto 0) ;
             control0 :           in      STD_LOGIC_VECTOR (15 downto 0) ;
             control1 :           in      STD_LOGIC_VECTOR (15 downto 0) ;
             control2 :           in      STD_LOGIC_VECTOR (15 downto 0) ;
             control3 :           in      STD_LOGIC_VECTOR (15 downto 0) ;
             control4 :           in      STD_LOGIC_VECTOR (15 downto 0) ;
             control5 :           in      STD_LOGIC_VECTOR (15 downto 0) ;
             control_signal :     out     SIGNED (15 downto 0) ;
             output_control_PWM : out     STD_LOGIC
           );
  end component;

  signal clk: STD_LOGIC;
  signal rst: STD_LOGIC;
  signal inputA: SIGNED (15 downto 0);
  signal control0: STD_LOGIC_VECTOR (15 downto 0);
  signal control1: STD_LOGIC_VECTOR (15 downto 0);
  signal control2: STD_LOGIC_VECTOR (15 downto 0);
  signal control3: STD_LOGIC_VECTOR (15 downto 0);
  signal control4: STD_LOGIC_VECTOR (15 downto 0);
  signal control5: STD_LOGIC_VECTOR (15 downto 0);
  signal control_signal: SIGNED (15 downto 0);
  signal output_control_PWM: STD_LOGIC ;

  constant clock_period: time := 10 ns;  
  signal stop_the_clock: boolean;
   
   
begin

  uut: Top_level port map ( clk                => clk,
                            rst                => rst,
                            inputA             => inputA,
                            control0           => control0,
                            control1           => control1,
                            control2           => control2,
                            control3           => control3,
                            control4           => control4,
                            control5           => control5,
                            control_signal     => inputA,
                            output_control_PWM => output_control_PWM );

  stimulus: process
  begin




  -- Put initialisation code here

    rst <= '1', '0' after 100 ns ;
   
    control0       <= STD_LOGIC_VECTOR(TO_SIGNED(16384, 16)), -- Point de référence de la température (valeur en tension)
                       -- Point de référence de la température (valeur en tension)
                      STD_LOGIC_VECTOR(TO_SIGNED(0, 16)) after 20000000 ns;    
    control1       <= STD_LOGIC_VECTOR(TO_SIGNED(1, 16)); -- Kp
    control2       <= STD_LOGIC_VECTOR(TO_SIGNED(8, 16)); -- Ki
    control3       <= STD_LOGIC_VECTOR(TO_SIGNED(2, 16)); --Kd
    control4   <= "0000000000000100" ;
    control5   <= "0000000000010100" ;
    -- Put test bench stimulus code here

    wait;
  end process;
clocking: process
  begin
    while not stop_the_clock loop
      clk <= '0', '1' after clock_period / 2;
      wait for clock_period;
    end loop;
    wait;
  end process;



end;