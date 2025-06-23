`ifndef apb_ram
`define apb_ram
module apb_ram #( parameter ADDR_WIDTH =8,
				  parameter DATA_WIDTH =8,
				  parameter RAM_SIZE =8,
				  parameter EN_WAIT_DELAY_FUNC=0,
                  parameter MIN_RAND_WAIT_CYC=0, 
                  parameter MAX_RAND_WAIT_CYC=1)
 (
	input pclk,
	input presetn,
	input penable,
	input pwrite,
	input psel,
	input [DATA_WIDTH-1:0] pwdata,
	input reg [ADDR_WIDTH-1:0] paddr,
	output reg [DATA_WIDTH-1:0] prdata,
	output reg pready, pslverr
	);
	int wait_cyc_limit;
	reg [DATA_WIDTH-1:0] mem [0:(RAM_SIZE)-1];

	typedef enum {idle =0, setup =1, access =2, transfer =3} state_type;
	state_type state = idle;
	state_type nextstate = idle;
	reg counter=0;
	initial begin
		wait_cyc_limit =$urandom_range(MIN_RAND_WAIT_CYC, MAX_RAND_WAIT_CYC);
	end

	always @(posedge pclk) begin
		if (presetn) begin
			state <= idle;
			foreach (mem[i]) begin
				mem[i] <= i;
			end
		end
		else begin
			counter <= counter+1;
			state <= nextstate;
		end
	end

	always @(*) begin
		
		case(state) 
		
			idle: begin
				prdata<=0;
				pready<=0;
				pslverr <=1'b0; 
				nextstate <= setup;
				
			end
			setup: begin
				if(psel==1'b1)
					nextstate <=access;
				else
					nextstate <=setup;
			end

			access: begin
				if(pwrite&&penable) begin
					if (EN_WAIT_DELAY_FUNC) begin
					repeat(wait_cyc_limit ) begin
						@(posedge pclk);
					end
					end
					nextstate<=transfer;
					
					if (paddr <RAM_SIZE) begin
						pslverr <= 1'b0;
						mem[paddr] <= pwdata;
						pready <=1'b1;
					$display("Time [%0t] the memory written is mem[%0h] =  %0h",$time,paddr, mem[paddr] );
					end 
					else begin
						pslverr <= 1'b1;
						pready <= 1'b0;
					end

				end
				else if (!pwrite && penable) begin
					nextstate<=transfer;
					if(paddr <RAM_SIZE) begin
						
						pslverr <=1'b0;
						pready <= 1'b1;
						prdata <= mem[paddr];
						$display("Time[%0t] in memory Addr you gave is %0h, and memory u should get =%0h",$time,paddr, mem[paddr]);
					end
				 	else begin
						prdata <= 'hx;
						pslverr <= 1'b1;
						pready <= 1'b0;
					end
					
				end 
				else 
						nextstate<= setup;
				end
	  transfer: begin
				nextstate <= setup;
				pready <= 1'b0;
				pslverr <= 1'b0;
				end

	  default : nextstate <= idle;

	endcase

  end
endmodule
`endif			
