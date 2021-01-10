# Mix-signal-script

Some script developed for the design of mix signal ic

SatRnd.m : bit true with truncation/rounding/saturation/overflow modeling in MATLAB with fixed point binary format
SatRnd_test.m : The unit test for SatRnd.m
dectobin4.vams : Converts a voltage in decimal format into binary format, which simplifies the testbench in DAC DNL/INL testing
inl_endpoint.ils : SKILL program used to characterize the INL/DNL of data converters in cadence virtuoso environement
