----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:15:18 02/18/2016 
-- Design Name: 
-- Module Name:    Debouncer - Behavioral 
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

entity Debouncer is
    Port ( reset : in  STD_LOGIC;
           input : in  STD_LOGIC;
           clk : in  STD_LOGIC;
           output : out  STD_LOGIC);
end Debouncer;

architecture Behavioral of Debouncer is

signal otemp, previous_input, count : STD_LOGIC;

begin

process(reset, clk)
begin 
	if (rising_edge(clk)) then
			previous_input <= input;
			if (reset = '0') then
				count <= ((previous_input xor input) and not(count));
			else
				count <= '0';
			end if;
			if (count = '0') then
				otemp <= input;
			end if;
	end if;
end process;

output <= otemp;
	
end Behavioral;

