----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:57:34 05/01/2015 
-- Design Name: 
-- Module Name:    lcd_controller - Behavioral 
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity lcd_controller is
	generic( horiz_length	:		integer	:= 20; --must be actual size -4
				horiz_overhead	:		integer	:= 1;
				vertical_length:		integer	:=	4;  --must be actual size -1
				frame_overhead	:		integer	:= 1); 
	port(clk_in:	in		std_logic;
			px_clk:	out	std_logic;
			ln_clk:	out	std_logic;
			fr_clk:	out	std_logic;
			px_pos_x:	out	integer range 0 to horiz_length;
			px_pos_y:	out	integer range 0 to vertical_length);
end lcd_controller;

architecture Behavioral of lcd_controller is
	signal clk_mod : std_logic:='1';
	signal h_counter	:	integer	range	0	to	horiz_length/4 + horiz_overhead	:= 	0;
	signal v_counter 	:	integer	range	0	to vertical_length						:=		0;
	signal pixel_clk	:	std_logic;
	signal line_clk	:	std_logic	:= '0';
	signal frame_clk	:	std_logic	:= '0';
begin
	clk_divider: process (clk_in)	is
		variable prescaler : std_logic_vector(7 downto 0):= X"00";
	begin
		if rising_edge(clk_in) then   					-- rising clock edge
				if prescaler = X"0D" then     			-- 13 in hex
					prescaler   := (others => '0');
					clk_mod   <= not clk_mod;
				else
					prescaler := prescaler + "1";
				end if;
		end if;
	end process clk_divider;
	
	pixel_clock_gen:	process	(clk_mod) is
	begin
		pixel_clk <=clk_mod;
	end process pixel_clock_gen;
	
	line_clock_gen:	process	(h_counter, pixel_clk) is
	begin
		if h_counter = horiz_length/4 and pixel_clk = '0' then
			line_clk <='1';
		else
			line_clk <='0';
		end if;
		
	end process line_clock_gen;
	horiz_counter: process (line_clk, pixel_clk) is
	begin
		if	rising_edge(pixel_clk)	then
			if(h_counter < horiz_length/4 + horiz_overhead)	then
				h_counter <= h_counter + 1;
			else
				h_counter <= 0;
			end if;
			
		end if;	
	end process;
	vertical_counter: process (h_counter) is
	begin
		if h_counter = 0 then
			if v_counter < vertical_length then
				v_counter <= v_counter +1;
			else
				v_counter <= 0;
			end if;
		end if;
	end process;
	frame_marker:	process	(v_counter, h_counter) is
	begin
		if v_counter = vertical_length or v_counter = 0 then
			if h_counter= frame_overhead then
				frame_clk <=not frame_clk;
			end if;
		end if;
	end process;
	output_conditioning:	process(pixel_clk)	is
	begin
		if	h_counter >= horiz_length/4 and h_counter <= horiz_length/4+horiz_overhead-1 then
			px_clk <='0';
		else
			px_clk	<=	pixel_clk;
		end if;
	end process;
	ln_clk	<=	line_clk;
	fr_clk	<=	frame_clk;
	px_pos_y<=v_counter;
	
	process(h_counter) is
	begin
		if h_counter = 0 then
			px_pos_x <= 0;
		elsif(h_counter < horiz_length/4)then
			px_pos_x<=h_counter*4 -1;
		else 
			px_pos_x <=horiz_length-1;
		end if;
	end process;
end Behavioral;

