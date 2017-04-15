--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   17:58:19 10/01/2016
-- Design Name:   
-- Module Name:   C:/GMU/Fall 2016/ECE 492/PWM VHDL/Pwm/pwm_tb.vhd
-- Project Name:  Pwm
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: pwm
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY pwm_tb IS
END pwm_tb;
 
ARCHITECTURE behavior OF pwm_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT pwm
    PORT(
         clk : IN  std_logic;
         reset_n : IN  std_logic;
         ena : IN  std_logic;
			change_direction : in std_logic;
         duty : IN  std_logic_vector(7 downto 0);
         pwm_out : OUT  std_logic_vector(0 downto 0);
			direction : OUT std_logic
--         pwm_n_out : OUT  std_logic_vector(1 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset_n : std_logic := '0';
	signal change_direction : std_logic := '0';
   signal ena : std_logic := '0';
   signal duty : std_logic_vector(7 downto 0) := (others => '0');

 	--Outputs
   signal pwm_out : std_logic_vector(0 downto 0);
--   signal pwm_n_out : std_logic_vector(1 downto 0);
	signal direction : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: pwm PORT MAP (
          clk => clk,
          reset_n => reset_n,
          ena => ena,
			 change_direction => change_direction,
          duty => duty,
          pwm_out => pwm_out,
--          pwm_n_out => pwm_n_out
          direction => direction
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
		reset_n <= '0';
		duty <= x"84";
		ena <= '1';
		wait for 10 us;
		change_direction <= '1';
      wait for 2000 us;	
		change_direction <= '0';
		wait for clk_period*2;
		change_direction <= '1';
		wait for clk_period*2;
		change_direction <= '0';
		wait for clk_period;
--		ena <= '0';
      -- insert stimulus here 

      wait;
   end process;

END;
