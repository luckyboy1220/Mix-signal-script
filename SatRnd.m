%% define a rounding function
%% din : The input number
%% number 0  1  0 ... 1 0 0 0
%% index 63 62 61 ... 3 2 1 0
%% msb : The msb index going to take from din
%% lsb : The lsb index going to take from din
%% rnd = 1, means do rounding. rnd = 0, means do truncation

function [dout, ov] = SatRnd(din, msb, lsb, rnd)

%% convert the types into int64
din = int64(din);
msb = int64(msb);
lsb = int64(lsb);
rnd = int64(rnd);

%% temp variable
max_signed = bitshift(1, msb - lsb) - 1;
min_signed = bitshift(-1, msb - lsb);
dout = 0;
dout_ov = 0; %temp for dout if overflow
dout_rnd = 0; %temp for dout if we have a valid rounding
dout_trunc = 0; % temp for dout if using truncation
ov = int64(0);

%% rnd_bit will be 1 if it's in rnd mode and a valid rnd condition
if rnd == 1 &&  lsb > 0
  rnd_bit = bitand(bitshift(din, -lsb + 1), 1);
else
  rnd_bit = 0;
end

%% check if ov
msb_bit = bitand(bitshift(din, -msb), 1); %% get the bit of the msb

%% check if the bit from msb + 1 to 63 is the same with the bit of msb
for i = msb + 1 : 63
    
  bitget = bitand(bitshift(din, -i), 1);
    
  if (bitget != msb_bit)
    ov = int64(1);
  end
    
end
 
%% if overflow, assign dout to max_signed if msb_bit = 0, else dout to min_signed if msb_bit = 1
if ov && msb_bit == 1
  dout_ov = min_signed;
elseif ov && msb_bit == 0
  dout_ov = max_signed;
end
  
%% convert the msb to lsb range into it's corresponding number
converted_din = din;

if (msb_bit)
  bitmask = bitshift(int64(-1), msb + 1);
  converted_din = bitor(bitmask, din);
  converted_din = bitshift(converted_din, -lsb);
else % msb == 0 
  bitmask = bitshift(int64(1), msb + 1) - 1;
  converted_din = bitand(bitmask, din);
  converted_din = bitshift(converted_din, -lsb);
end  

%% check if we need to round, may overflow if the selected range is already the max
if rnd_bit == 1 && converted_din == max_signed
  ov = int64(1);
  dout_ov = max_signed;
elseif rnd_bit == 1 && converted_din != max_signed;
  dout_rnd = converted_din + rnd_bit;
else % rnd_bit = 0
  dout_trunc = converted_din;
end    

%% depending on the status simply assign dout to dout_temp
if (ov)
  dout = int64(dout_ov);
elseif (rnd_bit)
  dout = int64(dout_rnd);
else %truncation
  dout = int64(dout_trunc);
end

endfunction