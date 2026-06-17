library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Top_Level_G_freq_et_PWM is
    Port (
        clk                 : in  STD_LOGIC;
        rst                 : in  STD_LOGIC;
        alpha               : in  STD_LOGIC_VECTOR(15 downto 0);
        output_front_enable : out STD_LOGIC
    );
end Top_Level_G_freq_et_PWM;

architecture Structural of Top_Level_G_freq_et_PWM is

    signal CE_calcul_sig : STD_LOGIC;

begin

    U_GESTION_FREQUENCE : entity work.gestion_frequence
        port map (
            clk       => clk,
            rst       => rst,
            CE_calcul => CE_calcul_sig
        );


    U_GESTION_PWM : entity work.Gestion_PWM
        port map (
            clk                 => clk,
            rst                 => rst,
            enable_signal       => CE_calcul_sig,
            alpha               => alpha,
            output_front_enable => output_front_enable
        );

end Structural;