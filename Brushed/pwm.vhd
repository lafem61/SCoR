--------------------------------------------------------------------------------
--
--   FileName:         pwm.vhd
--   Dependencies:     none
--   Design Software:  Quartus II 64-bit Version 12.1 Build 177 SJ Full Version
--
--   HDL CODE IS PROVIDED "AS IS."  DIGI-KEY EXPRESSLY DISCLAIMS ANY
--   WARRANTY OF ANY KIND, WHETHER EXPRESS OR IMPLIED, INCLUDING BUT NOT
--   LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
--   PARTICULAR PURPOSE, OR NON-INFRINGEMENT. IN NO EVENT SHALL DIGI-KEY
--   BE LIABLE FOR ANY INCIDENTAL, SPECIAL, INDIRECT OR CONSEQUENTIAL
--   DAMAGES, LOST PROFITS OR LOST DATA, HARM TO YOUR EQUIPMENT, COST OF
--   PROCUREMENT OF SUBSTITUTE GOODS, TECHNOLOGY OR SERVICES, ANY CLAIMS
--   BY THIRD PARTIES (INCLUDING BUT NOT LIMITED TO ANY DEFENSE THEREOF),
--   ANY CLAIMS FOR INDEMNITY OR CONTRIBUTION, OR OTHER SIMILAR COSTS.
--
--   Version History
--   Version 1.0 8/1/2013 Scott Larson
--     Initial Public Release
--   Version 2.0 1/9/2015 Scott Larson
--     Transistion between duty cycles always starts at center of pulse to avoid
--     anomalies in pulse shapes
--    
--------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY pwm IS
  GENERIC(
      sys_clk         : INTEGER := 50_000_000; --system clock frequency in Hz
      pwm_freq        : INTEGER := 5_000;    --PWM switching frequency in Hz
      bits_resolution : INTEGER := 8;          --bits of resolution setting the duty cycle
      phases          : INTEGER := 1);         --number of output pwms and phases
  PORT(
      clk       : IN  STD_LOGIC;                                    --system clock
      reset_n   : IN  STD_LOGIC;                                    --asynchronous reset
      ena       : IN  STD_LOGIC;                                    --latches in new duty cycle
		change_direction : in std_logic;
      duty      : IN  STD_LOGIC_VECTOR(bits_resolution-1 DOWNTO 0); --duty cycle
		direction : OUT STD_LOGIC;
		direction_inv : out std_logic;
      pwm_out   : OUT STD_LOGIC_VECTOR(phases-1 DOWNTO 0));          --pwm outputs
--      pwm_n_out : OUT STD_LOGIC_VECTOR(phases-1 DOWNTO 0));         --pwm inverse outputs
END pwm;

ARCHITECTURE logic OF pwm IS
	signal change_dir_db, change_dir_f : std_logic;
	component debouncer port(
		reset : in  STD_LOGIC;
		input : in  STD_LOGIC;
		clk : in  STD_LOGIC;
		output : out  STD_LOGIC);
	end component;

	component RED port(
		input : in  STD_LOGIC;
		clk : in  STD_LOGIC;
		reset : in  STD_LOGIC;
		output : out  STD_LOGIC);
	end component;
	
	CONSTANT  period     :  INTEGER := sys_clk/pwm_freq;                      --number of clocks in one pwm period
	TYPE counters IS ARRAY (0 TO phases-1) OF INTEGER RANGE 0 TO period - 1;  --data type for array of period counters
	SIGNAL  count        :  counters := (OTHERS => 0);                        --array of period counters
	--next line removed period/2
	SIGNAL   half_duty_new  :  INTEGER RANGE 0 TO period := 0;              --number of clocks in 1/2 duty cycle
	TYPE half_duties IS ARRAY (0 TO phases-1) OF INTEGER RANGE 0 TO period;--/2; --data type for array of half duty values
	SIGNAL  half_duty    :  half_duties := (OTHERS => 0);                     --array of half duty values (for each phase)
	SIGNAL  direction_temp		: 	std_logic := '0';
	signal out_tmp : std_logic := '0';
	
BEGIN
	db: debouncer port map (reset => reset_n, input => change_direction, clk => clk, output => change_dir_db);
	rd: RED port map (reset => reset_n, input => change_dir_db, clk => clk, output => change_dir_f);
	
	direction <= direction_temp;
	direction_inv <= not(direction_temp);
	
	PROCESS(clk, reset_n, count, half_duty, change_dir_f, direction_temp)
	BEGIN
		IF(reset_n = '1') THEN    	                                               --asynchronous reset
			count <= (OTHERS => 0);                                                --clear counter
			direction_temp <= '0';
--			pwm_out <= (OTHERS => '0');                                            --clear pwm outputs
--			pwm_n_out <= (OTHERS => '0');                                          --clear pwm inverse outputs
		ELSIF rising_edge(clk) THEN--(clk'EVENT AND clk = '1') THEN               --rising system clock edge
			if (change_dir_f = '1') then
				direction_temp <= not(direction_temp);
			end if;
			IF(ena = '1') THEN                                                     --latch in new duty cycle
			--changed next line
				half_duty_new <= conv_integer(duty)*period/(2**bits_resolution);--/2;  --determine clocks in 1/2 duty cycle
			END IF;
			FOR i IN 0 to phases-1 LOOP                                         --create a counter for each phase
				IF(count(0) = period - 1 - i*period/phases) THEN                    --end of period reached
						count(i) <= 00000000;                                                --reset counter
						half_duty(0) <= half_duty_new;                                --set most recent duty cycle value
				ELSE                                                                 --end of period not reached
					count(i) <= count(i) + 1;                                        --increment counter
				END IF;
			END LOOP;
		END IF;
	end process;
	
	
	process(reset_n, clk, count, half_duty, direction_temp)
	begin
		IF (reset_n = '1') THEN
			out_tmp <= '0';
		ELSIF rising_edge(clk) THEN
			FOR i IN 0 to phases-1 LOOP                                            --control outputs for each phase
				IF(count(0) >= half_duty(0)) THEN                                   --phase's falling edge reached
					out_tmp <= '0';
				ELSIF(count(0) <= period - half_duty(0)) THEN                       --phase's rising edge reached
						out_tmp <= '1';
				END IF;
			END LOOP;
		END IF;
	END PROCESS;
	
pwm_out(0) <= out_tmp;-- when direction = '0' else '0';
END logic;