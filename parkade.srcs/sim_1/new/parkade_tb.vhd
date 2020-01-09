----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/09/2019 11:23:29 AM
-- Design Name: 
-- Module Name: parkade_tb - Behavioral
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


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity parkade_tb is
--  Port ( );
end parkade_tb;

architecture Behavioral of parkade_tb is


component parkade is 
    Port (
            clk:    in STD_LOGIC;
            sw:     in STD_LOGIC_VECTOR(3 DOWNTO 0);         
            led6_r : out STD_LOGIC;
            led6_g : out STD_LOGIC;
            led6_b : out STD_LOGIC;       
            CC :        out STD_LOGIC;
            out_7seg :  out STD_LOGIC_VECTOR (6 downto 0));
end component;

component clock_divider is
    Port ( clk : in STD_LOGIC;
           clk_out : out STD_LOGIC);
end component;

signal clk,clk_out, led6_r, led6_g, led6_b, CC: STD_LOGIC:= '0';
signal sw: STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
signal out_7seg: STD_LOGIC_VECTOR(6 downto 0) := "0000000";

constant clock_period: time:=500ps;


begin
sd1: parkade Port Map
         (
            clk=>clk,
            sw=>sw,
            led6_r=>led6_r,
            led6_g=>led6_g,
            led6_b=>led6_b,
            CC=>CC,
            out_7seg=>out_7seg
         );
         
   divider: clock_divider port map(   
            clk=>clk,
            clk_out=>clk_out
        );
            
   clock: process
          begin
                    clk <='0';
                    wait for clock_period/2;
                    clk <='1';
                    wait for clock_period/2;
          end process;

    simulation: process
    begin
  
        wait for 1.5ns;
        -- Bring Available Cars to full capacity
        sw<="0001";           --Data bit='0'
        wait for 40 ns;
        -- Remove all cars to return to full capacity
        sw<="1000";           --Data bit='0'
        wait for 40 ns;
--        -- Bring Available Cars to full capacity


    end process;
end Behavioral;