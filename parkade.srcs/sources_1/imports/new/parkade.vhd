----------------------------------------------------------------------------------
-- Company: University of Alberta
-- Engineer: Raza Bhatti
-- 
-- Create Date: 05/27/2019 12:14:20 PM
-- Design Name: 
-- Module Name: Parkade - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------
-- Design Requirements.
--Note: The parkade display board has three lights and two digit display, since parkade has 99 parking spaces.
--1. If the available space is greater than 4, then the green light is lid.
--2. If the available space is between 0 and 4 then a  yellow light is lid.
--3. If parkade reaches full capacity and left with no available space then red light is lid.

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity parkade is
    Port ( 
            clk:    in STD_LOGIC;
            sw:     in STD_LOGIC_VECTOR(3 DOWNTO 0);    -- sw(0), sw(1) for vehicles parkade entry proximity sensor emulation
                                                        -- sw(2), sw(3) for vehicles parkade exit proximity sensor emulation.          
            led6_r : out STD_LOGIC;     --Red when parkade reached full capacity.
            led6_g : out STD_LOGIC;     --Green when parkade still has available parking stalls.
            led6_b : out STD_LOGIC;     --Blue when parkade available space is 4 or less.        
            CC :        out STD_LOGIC;                     --Common cathode input to select respective 7-segment digit.
            out_7seg :  out STD_LOGIC_VECTOR (6 downto 0)  -- Shows total available parking stalls. 
           );
end parkade;

architecture Behavioral of parkade is

signal clk_out, clk_1Hz, select_segment, clk_7seg_cc:std_logic:='0';
signal Parkade_NearFull_Capacity: natural:=04;
signal Parkade_Available_Capacity, Parkade_Full_Capacity: natural:=09;                     
signal count, Parkade_Available_Capacity_MSD, Parkade_Available_Capacity_LSD, digit_7seg_display, count_7seg : natural;

begin

    Decoder_4to7Segment: process (clk)
    begin

        case digit_7seg_display is
                when 0 =>  
                              out_7seg<="0111111";          --digit 0 display on segment #1 when CC='0' on segment #2 when CC='1'
                when 1 =>  
                              out_7seg<="0110000";          --digit 1 display on segment #1  when CC='0' on segment #2 when CC='1'
                when 2 =>  
                              out_7seg<="1011011";          --digit 2 display on segment #1  when CC='0' on segment #2 when CC='1'          
                when 3 =>  
                              out_7seg<="1111001";          --digit 3 display on segment #1  when CC='0' on segment #2 when CC='1'
                when 4 =>  
                              out_7seg<="1110100";          --digit 4 display on segment #1  when CC='0' on segment #2 when CC='1'
                when 5 =>  
                              out_7seg<="1101101";          --digit 5 display on segment #1  when CC='0' on segment #2 when CC='1'
                when 6 =>  
                              out_7seg<="1101111";          --digit 6 display on segment #1  when CC='0' on segment #2 when CC='1'
                when 7 =>  
                              out_7seg<="0111000";          --digit 7 display on segment #1  when CC='0' on segment #2 when CC='1'
                when 8 =>  
                              out_7seg<="1111111";          --digit 8 display on segment #1  when CC='0' on segment #2 when CC='1'
                when 9 =>  
                              out_7seg<="1111101";          --digit 9 display on segment #1  when CC='0' on segment #2 when CC='1'
                when others =>

        end case;

    end process;


    --Instatitiate components
    Clock_1Hz: process(clk)
    begin
        if rising_edge(clk) then
            if(count<125000000) then       
                count<=count+1;
            else
                count<=0;
                clk_out<=not clk_out;
                clk_1Hz<=clk_out;
            end if;

            if (count_7seg<10000) then
                count_7seg<=count_7seg+1;
            else
                select_segment<=not select_segment;
                count_7seg<=0;
            end if;
        end if;
    end process;

    Update_7Segment: process (clk) 
    begin

        if(Parkade_Available_Capacity>0) then
                                 
        --Write your design lines here
        --Hints: If available parkade capacity not zero then find available capcity LSD and MSD and 
        --       update relevant variables->Parkade_Available_Capacity_LSD, Parkade_Available_Capacity_MSD.
        --       Estimated total design lines ~= 2
        Parkade_Available_Capacity_MSD <= Parkade_Available_Capacity /10 ;
        Parkade_Available_Capacity_LSD <= Parkade_Available_Capacity - Parkade_Available_Capacity_MSD*10;
        
        end if;
        --       End required design lines above.

        -- Update design lines below
        if select_segment='1' then
            digit_7seg_display<= Parkade_Available_Capacity_LSD;           
        else
            digit_7seg_display<= Parkade_Available_Capacity_MSD;           
        end if;
        -- End updating design lines above.

        CC<=select_segment;         -- One of two 7-Segment digit selection. 

    end process;

   Parkade: process (clk_1Hz)
   begin
        if falling_edge(clk_1Hz) then
            -- Write design lines here to achieve lab requirements.
            -- Hints: 
            -- 1. Use case statement and monitor sw(0) and sw(1) for vehicles entrance and decrease counter.
            -- 2. Use case statement and monitor sw(2) and sw(2) for vehicles exit and increase counter.
           
           case sw is
              when "0001"|"0010"|"0111"|"1011" =>
                if Parkade_Available_Capacity>0 then
                    Parkade_Available_Capacity <= Parkade_Available_Capacity - 1;
                else 
                    Parkade_Available_Capacity <= Parkade_Available_Capacity + 0; 
                end if;
              when "0011" =>
                if Parkade_Available_Capacity>1 then
                    Parkade_Available_Capacity <= Parkade_Available_Capacity - 2;
                elsif Parkade_Available_Capacity = 1 then
                   Parkade_Available_Capacity <= Parkade_Available_Capacity - 1; 
                else 
                    Parkade_Available_Capacity <= Parkade_Available_Capacity + 0; 
                end if;
              when "1100" =>      
                if Parkade_Available_Capacity<98 then
                    Parkade_Available_Capacity <= Parkade_Available_Capacity + 2;
                elsif Parkade_Available_Capacity = 98 then
                   Parkade_Available_Capacity <= Parkade_Available_Capacity + 1;  
                else 
                   Parkade_Available_Capacity <= Parkade_Available_Capacity + 0; 
                end if;
              when "0100"|"1000"|"1101"|"1110" => 
                if Parkade_Available_Capacity <99 then                                                 
                  Parkade_Available_Capacity <= Parkade_Available_Capacity + 1; 
                else
                  Parkade_Available_Capacity <= Parkade_Available_Capacity + 0;  
                end if;
              when "0000"|"0101"|"0110"|"1001"|"1010"|"1111" =>
                Parkade_Available_Capacity <= Parkade_Available_Capacity + 0;                                      
              when others =>
              
           end case;
           
            
            -- Estimated design lines for above two tasks ~= 11x2 ~= 22




            -- End required design lines above.

            if(Parkade_Available_Capacity=0) then
                led6_r<='1';
                led6_g<='0';                        
                led6_b<='0';
                
            elsif(Parkade_Available_Capacity>4) then 
                led6_r<='0';
                led6_g<='1';                        
                led6_b<='0';
            elsif(Parkade_Available_Capacity<4 or Parkade_Available_Capacity=4 ) then 
                led6_r<='0';
                led6_g<='0';                        
                led6_b<='1';
            else
                led6_r<='0';
                led6_g<='0';                        
                led6_b<='0';
            
            -- Write design lines here to update parkade three leds for remaining scenarios.
            -- Estimate design lines ~= 8
            end if;

         end if;
         
    end process;
       
end Behavioral;
