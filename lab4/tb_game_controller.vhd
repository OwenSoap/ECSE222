library ieee;
use ieee.std_logic_1164.all;

entity tb_game_controller is
end tb_game_controller;

architecture behaviour of tb_game_controller is

    component game_controller is
    	port (
        	clk             : in std_logic; -- Clock for the system
        	rst             : in std_logic; -- Resets the state machine

        -- Inputs
        	shoot           : in std_logic; -- User shoot
        	move_left       : in std_logic; -- User left
        	move_right      : in std_logic; -- User right
  		pixel_x         : in integer; -- X position of the cursor
		pixel_y		: in integer; -- Y position of the cursor

		  -- Outputs
       		pixel_color		: out std_logic_vector (2 downto 0);
        	game_state		: out std_logic_vector (2 downto 0)
         );
	end component;
	
	--Inputs
	signal clk_in :std_logic;
	signal rst_in  :std_logic;
	signal shoot_in   :std_logic;
	signal move_left_in   :std_logic;
	signal move_right_in   :std_logic;
	signal pixel_x_in : integer; 
	signal pixel_y_in: integer; 	
	--Outputs
	signal pixel_color_out    :std_logic_vector (2 downto 0);
	signal game_state_out     :std_logic_vector (2 downto 0);
begin
	dut: game_controller
	port map(
		clk=>clk_in,
		rst=>rst_in,
		shoot=>shoot_in,
		move_left=>move_left_in,
		move_right=>move_right_in,
		game_state=>game_state_out,
		pixel_x => pixel_x_in,
		pixel_y	=> pixel_y_in
	);
	--create clock signal
	clk_process: process
	begin
    		clk_in<='0';
    		wait for 5ns;
    		clk_in<='1';
    		wait for 5ns;
	end process;
	--check the initial state
	init:process
	begin
    		wait for 10ns;
    		rst_in<='1';
    		wait for 10ns;
    		rst_in<='0';
    		wait;
    	end process;
--the actual check
	test:process
	begin
		shoot_in<='1';
		wait for 10ns;
		assert game_state_out="001"report "Error, Case 1" severity Error;
--check move left button
		move_left_in<='1';
		wait for 10ns;
		assert game_state_out="010"report "Error, Case 2" severity Error;
--check move right button
		move_right_in<='1';
		wait for 10ns;
		assert game_state_out="011"report "Error, Case 3" severity Error;
		report "game controller test Success!";
		wait;
	end process;
end behaviour;

