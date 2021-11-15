-----------------------------------
-- Author: Yi Zhu
-- Email: yi.zhu6@mail.mcgill.ca

-- This module handles the synchronization and timing of the VGA output

-- Horizontal Sync
-- Configuration   | Resolution | Sync    | Back  Porch | RGB      | Front porch | Clock
-- 640x480(60Hz)   | 1280x1024  | 1.0us   |    2.3us    | 11.9 us  |    0.4us    | 25 MHz
--                                96 pix      48 pix      1280 pix       16 pix 
-- Total pixels = sync+bp+rgb+fp = 800

-- Veritcal sync
-- Configuration   | Resolution | Sync    | Back  Porch |  RGB       | Front porch    | Clock
-- 640x480(60Hz)   | 1280x1024  |  3 line |    38 line  |  1024 line |    1 line      | 108 MHz
--
-- Total lines = 1066

----------------------------------- 
-- Import the necessary libraries
library ieee;
use ieee.std_logic_1164.all;


-- Declare entity
entity vga_controller is
    Generic(
        MAX_H : integer := 1688;
        S_H   : integer := 112;
        BP_H  : integer := 248;
        RGB_H : integer := 1280;
        FP_H  : integer := 48;

        MAX_V : integer := 1066;
        S_V   : integer := 3;
        BP_V  : integer := 38;
        RGB_V : integer := 1024;
        FP_V  : integer := 1;

        PIXLS : integer := 1310720 -- Total num Pixels = 640 x 480
           );
    Port (
    --Inputs
    clk         : in std_logic; -- VGA clock
    rst         : in std_logic;

    -- Outputs
	 pixel_x     : out integer;
	 pixel_y		 : out integer;
    vga_blank   : out std_logic;


    vga_hs      : out std_logic;
    vga_vs      : out std_logic;


    vga_clk     : out std_logic;
    vga_sync    : out std_logic	 
    );

end vga_controller;


architecture behaviour of vga_controller is
     signal hpos : integer range 0 to MAX_H := 0;
     signal vpos : integer range 0 to MAX_V := 0;
	 
	 signal vga_hsr : std_logic; -- Temp registers for 
	 signal vga_vsr : std_logic; -- Hsync and Vsync

    signal pixel_xr : integer := 0; -- Pixel position register
	 signal pixel_yr : integer := 0; -- Pixel position register
	 

begin

    -- Map to DAC (digital to analog converter)
    vga_clk <= clk;
	 vga_hs <= vga_hsr;
	 vga_vs <= vga_vsr;
	 vga_sync <= (vga_hsr and vga_vsr);
	 pixel_x <= pixel_xr;
	 pixel_y <= pixel_yr;
	    
    process(clk)
    begin
        if(rst = '1') then
            hpos <= 0;
            vpos <= 0;

            pixel_xr <= 0;
				pixel_yr <= 0;

        elsif rising_edge(clk) then
            
													-- Set Hpos and Vpos
				if (hpos < MAX_H) then		-- if (hpos is less than MAX_H)
					hpos <= hpos + 1; 		-- add 1 to hpos
				else
					hpos <= 0;
				
					if (vpos < MAX_V) then	-- else if (vpos is less than MAX_V) {
					  vpos <= 	vpos + 1; 		-- add 1 to vpos
					else								--    else 
					vpos <= 0;					   --        set vpos to 0
				end if; 
            
				end if;
													-- Set h_sync
				if (hpos < S_H) then 		-- if(hpos < S_H) {
					vga_hsr <= '0'; 			--    set vga_hsr to 0
													-- } else {
				else
					vga_hsr <= '1'; 			--    set vga_hsr to 1
				end if; 							-- }
         
													-- Set v_sync
				if (vpos < S_V) then 		-- if(vpos < S_V) {
				  vga_vsr <= '0'; 			--    set vga_vsr to 0			
				else 								-- } else {			
				  vga_vsr <= '1'; 			--    set vga_vsr to 1
				end if; 
		
         
																						-- Set blanking
				if ((hpos>=0 AND hpos<(S_H))  OR  (hpos>=(S_H) 
				AND hpos<(S_H+BP_H)) OR (hpos>=(S_H+BP_H+RGB_H)) 
				OR (vpos>=0 AND vpos<(S_V))  OR  (vpos>=(S_V) 
				AND vpos<(S_V+BP_V)) OR (vpos>=(S_V+BP_V+RGB_V)) )then -- if( front porch, backporch, h_sync,  v_sync){
				  vga_blank <= '0';  											--    set vga_blank to 0
				else 																	-- } else {
				  vga_blank <= '1';	 				
																						--    set vga_blank to 1
				    if (pixel_xr < RGB_H-1) then 							--    if(pixel_xr < RGB_H-1){
				    pixel_xr <= pixel_xr +1 ; 								--add 1 to the current value of pixel_xr
				    else 															--   									 } else [
				    pixel_xr <= 0;   
																						--       set pixel_xr to 0
				    if (pixel_yr < RGB_V-1) then 							--   if(pixel_yr < RGB_V-1){
				      pixel_yr <= pixel_yr+1; 								--    add 1 to the current value of pixel_yr
				    else 															--       } else {
				      pixel_yr <= 0; 											--          set pixel_yr to 0
				  end if; 	
            end if;			 													 --   
        end if;
		end if;
    end process;
end behaviour;

