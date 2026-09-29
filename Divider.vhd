library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Divider is
    Generic (
        DATA_SIZE : integer := 32
    );
    Port ( 
        rst, clk    : in  std_logic;
        start       : in  std_logic;
        dividend    : in  std_logic_vector (DATA_SIZE-1 downto 0);
        divider     : in  std_logic_vector (DATA_SIZE-1 downto 0);
        quotient    : out std_logic_vector (DATA_SIZE-1 downto 0)
    );
end Divider;

architecture Behavioral of Divider is
    type Etat is (IDLE, UPDATE, RESULT);
    signal pr_state, nx_state : Etat;
    signal s_dividend : unsigned (2*DATA_SIZE-1 downto 0);
    signal s_divider : unsigned (DATA_SIZE-1 downto 0);
    signal s_quotient_temp : std_logic_vector (DATA_SIZE-1 downto 0);
    signal s_quotient : std_logic_vector (DATA_SIZE-1 downto 0);
    signal s_sub : unsigned (DATA_SIZE-1 downto 0);
    signal s_comp : std_logic;
    signal s_index : signed(7 downto 0);
    
begin
    -- register update
    maj_state : process (clk, rst)
    begin
        if (clk'event and clk = '1') then
            if (rst = '1') then
                pr_state <= IDLE ;
            else
                pr_state <= nx_state ;        	
            end if;
        end if;
       
    end process maj_state;
    
    core_process : process (clk, rst)
    begin
        if (clk'event and clk = '1') then
            if (rst = '1') then
                s_dividend <= (others => '0');
                s_divider <= (others => '0');
                s_index <= (others => '0');
                s_quotient_temp <= (others => '0');
                s_quotient <= (others => '0');
            else
                case (pr_state) is
                when IDLE =>
                    if (start = '1') then
                        s_dividend <= to_unsigned(0, DATA_SIZE) & unsigned(dividend);
                        s_divider <= unsigned(divider);
                        s_index <= to_signed(DATA_SIZE-1, 8);
                    else
                        s_dividend <= s_dividend;
                        s_divider <= s_divider;
                        s_index <= s_index;
                    end if;
                    s_quotient <= s_quotient;
                
                when UPDATE =>
                    if (s_comp = '1') then
                        s_dividend <= s_sub(DATA_SIZE-2 downto 0) & s_dividend(DATA_SIZE-1 downto 0) & s_comp;
                    else
                        s_dividend <= s_dividend(s_dividend'high-1 downto 0) & s_comp;
                    end if;
                    --s_quotient_temp(to_integer(s_index+1)) <= s_comp;
                    s_index <= s_index - 1;
                    
                    s_quotient <= s_quotient;
                
                when RESULT =>
                    s_quotient <= std_logic_vector(s_dividend(s_quotient'range));
                    s_index <= s_index;
        
                end case;
            end if;
        end if;
    end process core_process;

    cal_nx_state : process (pr_state, s_index, start)
    begin
        case pr_state is
            when IDLE =>
                if (start = '1') then
                    nx_state <= UPDATE;
                else
                    nx_state <= IDLE;
                end if;
            when UPDATE =>
                if (s_index >= to_signed(0, s_index'length)) then
                    nx_state <= UPDATE;
                else
                    nx_state <= RESULT;
                end if;
            
            when RESULT => nx_state <= IDLE;
            
            when others => nx_state <= IDLE;
            
        end case;
    end process;

    s_comp <= '1' when (s_dividend(2*DATA_SIZE-1 downto DATA_SIZE) >= s_divider) else '0';
    s_sub <= s_dividend(2*DATA_SIZE-1 downto DATA_SIZE) - s_divider;

    quotient <= s_quotient;
    
    
end Behavioral;
