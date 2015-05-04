--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   12:00:49 05/04/2015
-- Design Name:   
-- Module Name:   /home/vadim/Work/projects/lcd_controller/ctrl_test.vhd
-- Project Name:  lcd_controller
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: lcd_controller
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
 
ENTITY ctrl_test IS
END ctrl_test;
 
ARCHITECTURE behavior OF ctrl_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT lcd_controller
    PORT(
         clk_in : IN  std_logic;
         px_clk : OUT  std_logic;
         ln_clk : OUT  std_logic;
         fr_clk : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk_in : std_logic := '0';

 	--Outputs
   signal px_clk : std_logic;
   signal ln_clk : std_logic;
   signal fr_clk : std_logic;

   -- Clock period definitions
   constant clk_in_period : time := 20 ns;
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: lcd_controller PORT MAP (
          clk_in => clk_in,
          px_clk => px_clk,
          ln_clk => ln_clk,
          fr_clk => fr_clk
        );

   -- Clock process definitions
   clk_in_process :process
   begin
		clk_in <= '0';
		wait for clk_in_period/2;
		clk_in <= '1';
		wait for clk_in_period/2;
   end process;

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for clk_in_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
