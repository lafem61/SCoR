----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:18:35 02/18/2016 
-- Design Name: 
-- Module Name:    RED - Behavioral 
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

entity RED is
    Port ( input : in  STD_LOGIC;
           clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           output : out  STD_LOGIC);
end RED;

architecture Behavioral of RED is
signal mid : STD_LOGIC := '0';
begin

process(clk)
begin
	if (rising_edge(clk)) then
		if (reset = '1') then
			mid <= '0';
		else 
			mid <= input;
		end if;
			output <= not(mid) and input;
	end if;
end process;
end Behavioral;

