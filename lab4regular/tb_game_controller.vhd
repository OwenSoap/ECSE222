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
	signal move_left_in  :std_logic;
	signal move_right_in   :std_logic;
	signal pixel_x_in : integer; 
	signal pixel_y_in: integer; 	
	--Outputs
	signal pixel_color_out    :std_logic_vector (2 downto 0);
	signal game_state_out     :std_logic_vector (2 downto 0);
	constant clk_period :time:=10ns;
begin
	dut : entity work.game_controller
	port map(
		clk=>clk_in,
		rst=>rst_in,
		shoot=>shoot_in,
		move_left=>move_left_in,
		move_right=>move_right_in,
		pixel_x => pixel_x_in,
		pixel_y	=> pixel_y_in,
		pixel_color => pixel_color_out,
		game_state => game_state_out
	);
	clk_process: process
	begin
		clk_in <= '0';
		wait for clk_period/2;
		clk_in <= '1';
		wait for clk_period/2;
	end process;
	--the actual check
	test: process
	begin

		rst_in <= '1';
		wait for (clk_period * 3);


		rst_in <= '0';
		wait for (clk_period / 2);
		-- should be pregame


		shoot_in <= '1';
		wait for clk_period;
		--should be in gameplay
		
		move_left_in <='1';
		wait for (clk_period);

		move_left_in <='0';
		wait for (clk_period);
		
		move_right_in <='1';
		wait for (clk_period);

		move_right_in <='0';
		wait for (clk_period);
		
		rst_in <= '1';
		wait for (clk_period*3);

		rst_in <= '0';
		wait for (clk_period / 2);
		-- should be in pregame


		shoot_in <= '1';
		wait for clk_period;
		--should be in gameplay

		wait;
	
		assert false report "Clock Divider test Sucess!" severity failure;
	end process;
end behaviour;

