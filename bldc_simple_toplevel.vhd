----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:39:23 03/20/2017 
-- Design Name: 
-- Module Name:    bldc_simple_toplevel - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity bldc_simple_toplevel is Port (
	clk : in  STD_LOGIC;
	reset : in  STD_LOGIC;
	ena : in std_logic;
	direction : in std_logic;
	duty : in  std_logic_vector(3 downto 0);
	hall : in std_logic_vector(2 downto 0);
	pwm_out : out std_logic_vector(2 downto 0);
	enable_out : out std_logic_vector(2 downto 0));
--	pwm_a : out std_logic;
--	pwm_b : out std_logic;
--	pwm_c : out std_logic);
end bldc_simple_toplevel;

architecture Behavioral of bldc_simple_toplevel is

component BLDC_motor Port ( 
	clk		: in std_logic;
	ena		: in std_logic;
	reset		: in std_logic;
	compare		: in std_logic_vector(3 downto 0);
	deadband	: in std_logic_vector(3 downto 0);

	ena_at		: in std_logic;
	ena_ab		: in std_logic;
	ena_bt		: in std_logic;
	ena_bb		: in std_logic;
	ena_ct		: in std_logic;
	ena_cb		: in std_logic;

	pwm_at		: out std_logic;
	pwm_ab		: out std_logic;
	pwm_bt		: out std_logic;
	pwm_bb		: out std_logic;
	pwm_ct		: out std_logic;
	pwm_cb		: out std_logic
	);
end component;

component bldc_hall_decoder Port (
	clk		: in std_logic;
	reset		: in std_logic;
	hall_a		: in std_logic;
	hall_b		: in std_logic;
	hall_c		: in std_logic;
	reverse		: in std_logic;
	enable_at	: out std_logic;
	enable_ab	: out std_logic;
	enable_bt	: out std_logic;
	enable_bb	: out std_logic;
	enable_ct	: out std_logic;
	enable_cb	: out std_logic
	);
end component;

component pwm GENERIC(
	sys_clk         : INTEGER; --system clock frequency in Hz
	pwm_freq        : INTEGER;    --PWM switching frequency in Hz
	bits_resolution : INTEGER;          --bits of resolution setting the duty cycle
	phases          : INTEGER);         --number of output pwms and phases
PORT(
	clk       : IN  STD_LOGIC;                                    --system clock
	reset_n   : IN  STD_LOGIC;                                    --asynchronous reset
	ena       : IN  STD_LOGIC;                                    --latches in new duty cycle
	duty      : IN  STD_LOGIC_VECTOR(bits_resolution-1 DOWNTO 0); --duty cycle
	pwm_out   : OUT STD_LOGIC_VECTOR(phases-1 DOWNTO 0));          --pwm outputs
--	pwm_n_out : OUT STD_LOGIC_VECTOR(2 DOWNTO 0));         --pwm inverse outputs
END component;
--component pwm_3_phase port( 
--	clk       : IN  STD_LOGIC;                                    --system clock
--	reset_n   : IN  STD_LOGIC;                                    --asynchronous reset
--	ena       : IN  STD_LOGIC;                                    --latches in new duty cycle
--	duty      : IN  STD_LOGIC_VECTOR(7 DOWNTO 0); --duty cycle
--	pwm_out   : OUT STD_LOGIC_VECTOR(2 DOWNTO 0));          --pwm outputs
--end component;

	signal pwm_n_out, pwm_out_1 : std_logic_vector(2 downto 0) := "000";-- hall,
--	signal enable_at, enable_bt, enable_ct, enable_ab, enable_bb, enable_cb : std_logic := '0';
--	signal pwm_ab, pwm_bb, pwm_cb : std_logic := '0';
	signal pwm_enable : std_logic := '0';
--	signal pwm_out, enable_out : std_logic_vector(2 downto 0);


begin
	--actual one
--	hall_pwm: pwm port map(
--		clk => clk,
--		reset_n => reset, 
--		ena => ena,
--		duty => x"80",
--		pwm_out(0) => hall(0),
--		pwm_out(1) => hall(1),
--		pwm_out(2) => hall(2));
	pwm1: pwm generic map(sys_clk => 500_000_000, pwm_freq => 50_000, bits_resolution => 4, phases => 1)
	port map(clk => clk, reset_n => reset, ena => ena, duty => duty, pwm_out(0) => pwm_enable);
		
		--,
--		pwm_n_out => pwm_n_out);
--	hall_pwm: pwm_3_phase port map(
--		clk => clk,
--		reset_n => reset, 
--		ena => ena,
--		duty => x"80",
--		pwm_out(0) => hall(0),
--		pwm_out(1) => hall(1),
--		pwm_out(2) => hall(2));
		
--	hall_reader: bldc_hall_decoder PORT MAP(
--		clk => clk,
--		reset => reset,
--		hall_a => hall(0),
--		hall_b => hall(1),
--		hall_c => hall(2),
--		reverse => direction,
--		enable_at => enable_at,
--		enable_bt => enable_bt,
--		enable_ct => enable_ct,
--		enable_ab => enable_ab,
--		enable_bb => enable_bb,
--		enable_cb => enable_cb);
	hall_reader: process(clk, hall, direction, reset)
	begin
--		if (rising_edge(clk)) then
		if (direction = '0') then
			case (hall) is 
				when "001" => 
					pwm_out_1 <= "010";
					enable_out <= "110";
				when "101" => 
					pwm_out_1 <= "010";
					enable_out <= "011";
				when "100" => 
					pwm_out_1 <= "001";
					enable_out <= "011";
				when "110" => 
					pwm_out_1 <= "001";
					enable_out <= "101";
				when "010" => 
					pwm_out_1 <= "100";
					enable_out <= "101";
				when "011" => 
					pwm_out_1 <= "100";
					enable_out <= "110";
				when others =>
					pwm_out_1 <= "000";
					enable_out <= "111";
			end case;
		else
			case (hall) is 
				when "001" => 
					pwm_out_1 <= "001";
					enable_out <= "101";
				when "101" => 
					pwm_out_1 <= "100";
					enable_out <= "101";
				when "100" => 
					pwm_out_1 <= "100";
					enable_out <= "110";
				when "110" => 
					pwm_out_1 <= "010";
					enable_out <= "110";
				when "010" => 
					pwm_out_1 <= "010";
					enable_out <= "011";
				when "011" => 
					pwm_out_1 <= "001";
					enable_out <= "011";
				when others =>
					pwm_out_1 <= "000";
					enable_out <= "111";
			end case;
		end if;
	end process;
	pwm_out <= pwm_out_1 and (pwm_enable&pwm_enable&pwm_enable);


--	motor: BLDC_Motor PORT MAP(
--		clk => clk,
--		ena => not(ena),
--		reset => reset,
--		compare => duty,
--		deadband => x"2",
--		ena_at => enable_at,
--		ena_bt => enable_bt,
--		ena_ct => enable_ct,
--		ena_ab => enable_ab,
--		ena_bb => enable_bb,
--		ena_cb => enable_cb,
----		fault => fault,
----		fault_clr => fault_clr,
----		fault_status => fault_status,
----		fault_irq => fault_irq,
--		pwm_at => pwm_a,
--		pwm_ab => pwm_ab,
--		pwm_bt => pwm_b,
--		pwm_bb => pwm_bb,
--		pwm_ct => pwm_c,
--		pwm_cb => pwm_cb
--	);
	
--	process(clk, hall, enable_at, enable_bt, enable_ct)
--	begin
--		if(rising_edge(clk)) then
--			
--		end if;
--	end process;
end Behavioral;

