clear all;
close all;

%test overflow if msb = 1, pos number
[dout0, ov0] = SatRnd(8, 3, 0, 1);
assert(ov0, int64(1));
assert(dout0, int64(-8));

%test overflow if msb = 1, neg number
[dout1, ov1] = SatRnd(-24, 3, 0, 1);
assert(ov1, int64(1));
assert(dout1, int64(-8)); 

%test overflow if msb = 0, pos number
[dout2, ov2] = SatRnd(8, 2, 0, 1);
assert(ov2, int64(1));
assert(dout2, int64(3));

%test overflow if msb = 0, neg number
%number:1 1 1 0 0 0 0
%index: 6 5 4 3 2 1 0  
[dout3, ov3] = SatRnd(-16, 3, 1, 1);
assert(ov3, int64(1));
assert(dout3, int64(3));

%test truncation, neg number
%number:1 1 0 0 0 1 0 
%index: 6 5 4 3 2 1 0  
[dout4, ov4] = SatRnd(-30, 5, 1, 0);
assert(ov4, int64(0));
assert(dout4, int64(-15));

%test truncation, pos number
%number:0 0 1 0 0 0 1 0 
%index: 7 6 5 4 3 2 1 0  
[dout5, ov5] = SatRnd(34, 6, 2, 0);
assert(ov5, int64(0));
assert(dout5, int64(8));

%test rnd,valid rnd, pos number
%number:0 0 1 0 0 0 1 0 
%index: 7 6 5 4 3 2 1 0  
[dout6, ov6] = SatRnd(34, 6, 2, 1);
assert(ov6, int64(0));
assert(dout6, int64(9));

%test rnd,valid rnd, neg number
%number:1 1 1 0 0 0 1 0 
%index: 7 6 5 4 3 2 1 0  
[dout7, ov7] = SatRnd(-30, 5, 2, 1);
assert(ov7, int64(0));
assert(dout7, int64(-7));

%test rnd, unvalid rnd, pos number
%number:0 0 1 0 0 0 1 0 
%index: 7 6 5 4 3 2 1 0  
[dout8, ov8] = SatRnd(34, 6, 3, 1);
assert(ov8, int64(0));
assert(dout8, int64(4));


%test rnd, unvalid rnd, neg number
%number:1 1 1 0 0 0 1 0 
%index: 7 6 5 4 3 2 1 0  
[dout9, ov9] = SatRnd(-30, 6, 3, 1);
assert(ov9, int64(0));
assert(dout9, int64(-4));

%test overflow if selected number is already largest with effetive rnd_bit
%number:0 0 1 1 1 1 1 0 
%index: 7 6 5 4 3 2 1 0  
[dout9, ov9] = SatRnd(62, 6, 2, 1);
assert(ov9, int64(1));
assert(dout9, int64(15));

