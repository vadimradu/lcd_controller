----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:42:41 04/27/2015 
-- Design Name: 
-- Module Name:    lcd_ctrl - Behavioral 
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


entity lcd_ctrl is
	port(clk: in std_logic;
			A: out std_logic_vector(10 downto 0));

end lcd_ctrl;

architecture Behavioral of lcd_ctrl is
--Timing Constants
--Time constant integers in nanoseconds
constant CLK_PERIOD : integer := 20; -- approximate/rounded off
constant XSCL_PERIOD : integer := 300 ;
 
--FRAME CONSTANTS  
constant WIDTH : integer := 640;
constant HEIGHT : integer := 240;
constant XPULSES : integer := WIDTH / 4;
constant YPULSES : integer := 240;
--Timing signals
signal XSCL_TIME : integer range 0 to (XSCL_PERIOD + CLK_PERIOD) := 0;
 
--count signals
signal XSCL_CNT : integer range 0 to XPULSES := 0;
signal YSCL_CNT : integer range 0 to YPULSES := 0;
signal STARTED : STD_LOGIC := '0';
--Output Signals
signal LP_YSCL : STD_LOGIC := '0';
signal XSCL : STD_LOGIC := '0';
signal UD : STD_LOGIC_VECTOR(3 downto 0) := "0000";
signal LD : STD_LOGIC_VECTOR(3 downto 0) := "0000";
signal DIN : STD_LOGIC := '0';
begin
--Process Definition
 main: process(clk)
begin
     -- triggers action on rising edge of clock signal
  if rising_edge(clk) then
     --increment counter, using time type
      XSCL_TIME <= XSCL_TIME + CLK_PERIOD;
       
       
      if STARTED='0' then
        --initial state
         --first part of timing diagram, on LP pulse, and a up/down on XSCL
         if LP_YSCL = '0' then
             --set signals
             LP_YSCL <= '1';
             XSCL <= '1';
             --reset times
             XSCL_TIME <=0;
         elsif LP_YSCL = '1' and
                     XSCL = '1' AND
                     XSCL_TIME > (XSCL_PERIOD/2) then
             --set signal
             XSCL <= '0';
         elsif LP_YSCL = '1' AND
                     XSCL = '0' AND
                     XSCL_TIME > XSCL_PERIOD THEN
             --clear started flag
             STARTED <= '1';
             --reset timer
             XSCL_TIME <= 0;
         end if;
    else
         --after started
         if LP_YSCL = '0' and
             XSCL = '0' and
             XSCL_CNT = 0 THEN
             --occurs at the end of a row, timing specs say LP_YSCL must go to zero before XSCL goes high
             --Raise XSCL to HI         
             XSCL <= '1';
             --reset pulse timer
             XSCL_TIME <= 0;
              
             --update X count
             XSCL_CNT <= XSCL_CNT + 1;
         elsif LP_YSCL = '1' and
         --first step, LP is H, XSCL is L, XSCL_CNT is 0
             XSCL = '0' AND
             XSCL_CNT = 0 THEN
              
             --drop LP, Raise XSCL, load data
             LP_YSCL <= '0';
             XSCL <= '1';
              
             --temp data
             UD <= "0101";
             LD <= "0101";
              
             --reset timer
             XSCL_TIME <= 0;
              
             --if first row, raise frame pulse
             if YSCL_CNT = 0 then
                 DIN <= '0';
             end if;
         elsif XSCL = '1' AND
                 XSCL_TIME > (XSCL_PERIOD/2) THEN
             --drop xscl to L
             XSCL <= '0';
         elsif XSCL = '0' AND
                 XSCL_TIME > XSCL_PERIOD THEN
                              
              
             --load new data
             --TODO
              
             --IF at last pulse raise LP to hi
             if XSCL_CNT = XPULSES - 2 then -- use pulses-2 to compensate for cnt not updated yet and zero based index.
                 --last X pulse, raise LP
                 LP_YSCL <= '1';
                 --update X count
                 XSCL_CNT <= XSCL_CNT + 1;
                  
                 --Raise XSCL to HI         
                 XSCL <= '1';
                 --reset pulse timer
                 XSCL_TIME <= 0;
                  
             elsif XSCL_CNT = XPULSES - 1 THEN
                --new line, drop LP
                 LP_YSCL <= '0';
                 --reset XSCL_CNT
                 XSCL_CNT <= 0;
                  
                 if YSCL_CNT = YPULSES - 1 then
                     -- this was the last pulse, go back to zero
                     YSCL_CNT <= 0;
                 else                       
                     --increment Y count
                     YSCL_CNT <= YSCL_CNT + 1;
                 end if;
                  
             else                   
                 --Raise XSCL to HI         
                 XSCL <= '1';
                 --reset pulse timer
                 XSCL_TIME <= 0;
                 --update X count
                 XSCL_CNT <= XSCL_CNT + 1;
             end if;
             
         end if;
          
         --if on first line, first x, raise frame pulse
         if LP_YSCL = '0' AND XSCL = '1' and YSCL_CNT = 0 then
             --raise frame pulse
             DIN <= '1';
         elsif LP_YSCL = '0' AND XSCL = '1' AND YSCL_CNT = 1 then
             --shut down frame pulse
             DIN <= '0';
         end if;
              
      end if; --started
              
  end if; --clk  
    
end process;

A(0) <= LP_YSCL;
A(1) <= XSCL;
A(5 downto 2) <= UD;
A(9 downto 6) <= LD;
A(10) <= DIN;
end Behavioral;

