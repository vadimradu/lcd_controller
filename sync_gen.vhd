----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:48:06 04/19/2015 
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
-- politicaly correct lcd driver, very inflexible with particular panel timing requierments
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
	generic(	lcd_h_pixels	:	integer	:=	320;	--horizontal line size
				lcd_v_pixels	:	integer	:=	240	--number of visible lines
	);
	port(	clock	:	IN		std_logic;	--master clock
			rst_n	:	IN		std_logic;	--asynchronous, active low, reset
			cl1	:	OUT	std_logic;	--pixwl clock
			cl2	:	OUT	std_logic;	--line clock
			flm	:	OUT	std_logic	--frame start pulse
			);
end sync_gen;

architecture Behavioral of sync_gen is
------------------------------------------------------------------------
-- Signal Declarations
------------------------------------------------------------------------
	signal	pixel_clock	: std_logic := '0';
	signal	line_clock	: std_logic := '0';
	signal	frame_pulse	: std_logic	:=	'0';
------------------------------------------------------------------------
-- Module Implementation
------------------------------------------------------------------------
begin
	------------------------------------------------------------------------
	-- Map basic status and control signals
   ------------------------------------------------------------------------
	cl1 <= pixel_clock;
	cl2 <= line_clock;
	flm <= frame_pulse;
	
	process(clock, rst_n)
		variable h_counter	:	integer range 0 to lcd_h_pixels - 1	:=	0;
		variable	v_counter	:	integer range 0 to lcd_v_pixels - 1	:=	0;
	begin
		if(rst_n = '0') then
			--return to home position
			h_counter := 0;
			v_counter := 0;
			pixel_clock <= '0';
			line_clock	<=	'0';
		elsif(clock'event and clock = '1') then
			--horizontal sync signal
			IF(h_counter < lcd_h_pixels - 1) THEN    --horizontal counter (pixels)
				h_counter := h_counter + 4;
				pixel_clock <= not pixel_clock;
			ELSE
				h_counter := 0;
			END IF;
			--vertical sync signal
			if (h_counter = 0) then
				line_clock <= '1';
				IF(v_counter < lcd_v_pixels - 1) THEN  --veritcal counter (rows)
					v_counter := v_counter + 1;
				ELSE
					v_counter := 0;
				END IF;
			else
				line_clock <= '0';
			end if;
			--first frame pulse
			if(v_counter = 0) then
				frame_pulse <= '1';
			else
				frame_pulse <= '0';
			end if;
		end if;
	end process;
end Behavioral;

