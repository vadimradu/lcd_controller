----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:23:25 04/19/2015 
-- Design Name: 
-- Module Name:    sync_gen - Behavioral 
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
-- Prima versiune
-- modulul creaza semnalele de control necesare pentru un ecran lcd fara controller
-- integrat si furnizeaza la iesire un index de coordonate pentru pixeli x si y
--
--
-- Codul a fost pus la punct pe baza articolelor descoperite la adresele:
-- http://burnt-traces.com/?p=246
-- https://eewiki.net/pages/viewpage.action?pageId=15925278
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

entity sync_gen is
	port(	clock:	IN		std_logic;
			rst_n:	IN		std_logic;
			cp:		OUT	std_logic; --pixel clock signal
			lp:		OUT	std_logic; --line clock signal
			flm:		OUT	std_logic; --new frame signal
			x_pos:	OUT	integer;
			y_pos:	OUT	integer
	);
end sync_gen;

architecture Behavioral of sync_gen is

begin


end Behavioral;

