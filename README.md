# CRC Channel Coder and Decoder

In this project i have implemented a 7-bit CRC channel coder and decoder with 1 bit **error correction** for Xilinx FPGA's using VHDL.

Here Im using hamming ploynomial ( g(x) = x^3 + x + 1 )

## Encoder FSM (Finite State Machine)
![Encoder Stage Machine](https://user-images.githubusercontent.com/47427690/124732954-f78f9480-df28-11eb-8999-1c501adceccd.png)

In encoding process we are adding 3 bit (overhead bits) to every 4 bit (message bits), so output of encoder is 7 bit for every 4 bit message

## Encoder Simulation Snapshot
![sim_encoder](https://user-images.githubusercontent.com/47427690/124734008-fad75000-df29-11eb-90d9-ca2241490c60.png)


## Decoder FSM
![decode_fsm](https://user-images.githubusercontent.com/47427690/124732901-e9417880-df28-11eb-9ec0-7a365d8f34c6.png)

Decoding process consists of creating **syndrom sequence** and using **lookup table** for error correction.

***NOTE: If you want more than 1 bit eror corection you can choose a polynomial with a higher digree***

## Decoder Simulation SnapShot
![sim_decoder](https://user-images.githubusercontent.com/47427690/124734555-7cc77900-df2a-11eb-96d4-f3f243cdd572.png)
