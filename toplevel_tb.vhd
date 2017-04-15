--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   23:06:35 03/20/2017
-- Design Name:   
-- Module Name:   C:/GMU/Spring 2017/ECE 493/Motor Control/BLDC_simple/toplevel_tb.vhd
-- Project Name:  BLDC_simple
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: bldc_simple_toplevel
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
 
ENTITY toplevel_tb IS
END toplevel_tb;
 
ARCHITECTURE behavior OF toplevel_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT bldc_simple_toplevel
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         ena : IN  std_logic;
         direction : IN  std_logic;
         duty : IN  std_logic_vector(3 downto 0);
			pwm_out : out std_logic_vector(2 downto 0);
			enable_out : out std_logic_vector(2 downto 0)
--         pwm_a : OUT  std_logic;
--         pwm_b : OUT  std_logic;
--         pwm_c : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal ena : std_logic := '0';
   signal direction : std_logic := '0';
   signal duty : std_logic_vector(3 downto 0) := (others => '0');

 	--Outputs
--   signal pwm_a : std_logic;
--   signal pwm_b : std_logic;
--   signal pwm_c : std_logic;
	signal pwm_out : std_logic_vector(2 downto 0);
	signal enable_out : std_logic_vector(2 downto 0);
   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: bldc_simple_toplevel PORT MAP (
          clk => clk,
          reset => reset,
          ena => ena,
          direction => direction,
          duty => duty,
			 pwm_out => pwm_out,
			 enable_out => enable_out
--          pwm_a => pwm_a,
--          pwm_b => pwm_b,
--          pwm_c => pwm_c
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
		reset <= '1';
		ena <= '0';
		direction <= '0';
		duty <= x"8";
      wait for 100 ns;	
		reset <= '0';
		ena <= '1';

      -- insert stimulus here 

      wait;
   end process;

END;
