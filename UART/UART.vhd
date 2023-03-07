--- UART 8 bits transmiter
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uart is
  port(
    clk, reset: 	in 	std_logic;
    tx_start: 	in 	std_logic;
    s_tick: 	in	std_logic;
    d_in: 		in 	std_logic_vector(7 downto 0);
    tx_done_tick:	out	std_logic;
    tx: 		out 	std_logic
  );
end entity;

architecture arch of uart is

  component baudrate_gen is
    port(
      clk, reset: 	in 	std_logic;
      tick: 	out 	std_logic
    );
  end component;
  
  signal tick : std_Logic;
  
  type state_type is (idle, start, data, stop);
  	signal state: state_type;
    signal count: integer range 0 to 8;

begin
  
    baud_gen : baudrate_gen port map(clk, reset, tick);

    process (clk, reset)
    
    begin
    
      if reset = '1' then
        state <= idle;
        count <= 0;
        tx <= '1';
        tx_done_tick <= '0';
        
      elsif rising_edge(clk) then
      
        case state is
        
          when idle =>
            if tx_start = '0' then
              state <= idle;
            elsif tx_start = '1' then
              state <= start;
            end if;
            
          when start =>
              if tick = '0' then
                state <= start;
              elsif tick = '1' then
              	state <= data;
              end if;
              
          when data =>
            if tick = '0' then
              state <= data;
            elsif tick = '1' AND count <= 7 then
              state <= data;
              tx <= d_in(count);
              count <= count + 1;
            elsif tick = '1' AND count > 7 then
              state <= stop;
              count <= 0;
            end if;
            
          when stop =>
            tx <= '1';
            tx_done_tick <= '1';
            if tick = '1' then
              state <= idle;
            end if;
            
        end case;
      end if;
  	end process;
end architecture;