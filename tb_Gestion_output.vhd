library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity Gestion_PWM_tb is
end;

architecture bench of Gestion_PWM_tb is

  component Gestion_PWM
      Port ( clk : in STD_LOGIC;
             rst : in STD_LOGIC;
             control_output : in STD_LOGIC ;
             alpha : in SIGNED (15 downto 0);
             n_periode : in UNSIGNED ( 2 downto 0);
             logic_output : out STD_LOGIC;
             alim_output : out STD_LOGIC_VECTOR(15 downto 0)
           );
  end component;

  signal clk: STD_LOGIC;
  signal rst: STD_LOGIC;
  signal control_output: STD_LOGIC;
  signal alpha: SIGNED (15 downto 0);
  signal n_periode: UNSIGNED ( 2 downto 0);
  signal logic_output: STD_LOGIC;
  signal alim_output: STD_LOGIC_VECTOR(15 downto 0) ;

  constant clock_period: time := 10 ns;
  signal stop_the_clock: boolean;

begin

  uut: Gestion_PWM port map ( clk            => clk,
                              rst            => rst,
                              control_output => control_output,
                              alpha          => alpha,
                              n_periode      => n_periode,
                              logic_output   => logic_output,
                              alim_output    => alim_output );

  stimulus: process
  begin

    -- Put initialisation code here

    rst <= '1', '0' after 20 ns;
    control_output <= '1', '0' after 40 ns, '1' after 2621 us ;
    alpha <= TO_SIGNED(16000, 16), 
             TO_SIGNED(0, 16) after 655 us, 
             TO_SIGNED(-10000, 16) after 1310 us, 
             TO_SIGNED(16000, 16) after 1966 us; 
    n_periode <= "001", 
                 "100" after 1966 us ;

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