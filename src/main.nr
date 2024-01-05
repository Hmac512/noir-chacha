use dep::std::collections::vec::Vec;

struct ChaChaState {
    a: [u32;4],
    b: [u32;4],
    c: [u32;4],
    d: [u32;4],
}

struct ChaCha20 {
    state: ChaChaState,
    output: [u8; 64],
    offset: u32,
}

fn main() {}

pub fn read_u32_le(input: &mut [u8]) -> u32 {
    assert(input.len() == 4);
    // unsafe {
    //     let mut tmp = mem::MaybeUninit::uninit();
    //     ptr::copy_nonoverlapping(input.get_unchecked(0), tmp.as_mut_ptr() as *mut u8, 4);
    //     u32::from_le(tmp.assume_init())
    // }
    4
}

pub fn rotl(x: u32, b: u32) -> u32 {
    (x << b) | (x >> (32 - b))
}

// pub fn round(state: &mut ChaChaState) {
// state.a = state.a + state.b;
// }

// ($state: expr) => {{
//         $state.a = $state.a + $state.b;
//         rotate!($state.d, $state.a, S16);
//         $state.c = $state.c + $state.d;
//         rotate!($state.b, $state.c, S12);
//         $state.a = $state.a + $state.b;
//         rotate!($state.d, $state.a, S8);
//         $state.c = $state.c + $state.d;
//         rotate!($state.b, $state.c, S7);
//     }}

impl ChaCha20 {

    pub fn new(key: &mut [u8], nonce: &mut [u8]) -> ChaCha20 {
        assert((key.len() == 16) | (key.len() == 32));
        assert((nonce.len() == 8) | (nonce.len() == 12));

        ChaCha20 {
            state: ChaChaState { a: [0x61707865, 0x3320646e, 0x79622d32, 0x6b206574], b: [0; 4], c: [0; 4], d: [0; 4] },
            output: [0; 64],
            offset: 64
        }
    }



    pub fn new_xchacha20(key: &mut [u8], nonce: &mut [u8]) -> ChaCha20 {
            assert(key.len() == 32);
            assert(nonce.len() == 24);


            let mut subNonce1:[u8] = [0; 16];

            for i in 0..16 {
                subNonce1[i] = nonce[i];
            };



            // HChaCha20 produces a 256-bit output block starting from a 512 bit
            // input block where (x0,x1,...,x15) where
            //
            //  * (x0, x1, x2, x3) is the ChaCha20 constant.
            //  * (x4, x5, ... x11) is a 256 bit key.
            //  * (x12, x13, x14, x15) is a 128 bit nonce.
            let mut xchacha20 = ChaCha20 {
                state: ChaCha20::expand(key, &mut subNonce1),
                output: [0; 64],
                offset: 64,
            };

            // Use HChaCha to derive the subkey, and initialize a ChaCha20 instance
            // with the subkey and the remaining 8 bytes of the nonce.
            let mut new_key = [0; 32];
            let mut subNonce2:[u8] = [0; 8];
            for i in 16..24 {
                subNonce2[i] = nonce[i];
            };
            // xchacha20.hchacha20(&mut new_key);
            xchacha20.state = ChaCha20::expand(&mut new_key, &mut subNonce2);

            xchacha20
        }

    fn expand(key: &mut [u8], nonce: &mut [u8]) -> ChaChaState {
        let constant = [101, 120, 112, 97, 110, 100, 32, 51, 50, 45, 98, 121, 116, 101, 32, 107];
        ChaChaState {
            a: [
                read_u32_le(&mut [constant[0], constant[1], constant[2], constant[3]]),
                read_u32_le(&mut [constant[4], constant[5], constant[6], constant[7]]),
                read_u32_le(&mut [constant[8], constant[9], constant[10], constant[11]]),
                read_u32_le(&mut [constant[12], constant[13], constant[14], constant[15]])
            ],
            b: [
                read_u32_le(&mut [key[0], key[1], key[2], key[3]]),
                read_u32_le(&mut [key[4], key[5], key[6], key[7]]),
                read_u32_le(&mut [key[8], key[9], key[10], key[11]]),
                read_u32_le(&mut [key[12], key[13], key[14], key[15]])
            ],
            c: [
                read_u32_le(&mut [key[16], key[17], key[18], key[19]]),
                read_u32_le(&mut [key[20], key[21], key[22], key[23]]),
                read_u32_le(&mut [key[24], key[25], key[26], key[27]]),
                read_u32_le(&mut [key[28], key[29], key[30], key[31]])
            ],
            d: [
                read_u32_le(&mut [nonce[0], nonce[1], nonce[2], nonce[3]]),
                read_u32_le(&mut [nonce[4], nonce[5], nonce[6], nonce[7]]),
                read_u32_le(&mut [nonce[8], nonce[9], nonce[10], nonce[11]]),
                read_u32_le(&mut [nonce[12], nonce[13], nonce[14], nonce[15]])
            ]
        }
    }

    fn half_round(output: &mut [u32;4], a:u32,b:u32,c:u32,d:u32) {

        //    output[d] = this._rotl(output[d] ^ (output[a] += output[b]), 16)
        // output.d =



    }



   fn hchacha20(&mut self, out: &mut [u8]) -> () {


        // Apply r/2 iterations of the same "double-round" function,
        // obtaining (z0, z1, ... z15) = doubleround r/2 (x0, x1, ... x15).


        let mix = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
        let i = 0;
        let b = 0;


        for _ in 0..10 {

      //  self.half_round(self.state.a[0], self.state.b[0], self.state.c[0], self.state.d[0]);



        //     round(state);
        //     let u32x4(b10, b11, b12, b13) = state.b;
        //     state.b = u32x4(b11, b12, b13, b10);
        //     let u32x4(c10, c11, c12, c13) = state.c;
        //     state.c = u32x4(c12, c13, c10, c11);
        //     let u32x4(d10, d11, d12, d13) = state.d;
        //     state.d = u32x4(d13, d10, d11, d12);
        //     round!(state);
        //     let u32x4(b20, b21, b22, b23) = state.b;
        //     state.b = u32x4(b23, b20, b21, b22);
        //     let u32x4(c20, c21, c22, c23) = state.c;
        //     state.c = u32x4(c22, c23, c20, c21);
        //     let u32x4(d20, d21, d22, d23) = state.d;
        //     state.d = u32x4(d21, d22, d23, d20);
        }

        // // HChaCha20 then outputs the 256-bit block (z0, z1, z2, z3, z12, z13,
        // // z14, z15).  These correspond to the constant and input positions in
        // // the ChaCha matrix.
        // let u32x4(a1, a2, a3, a4) = state.a;
        // let u32x4(d1, d2, d3, d4) = state.d;
        // let lens = [a1, a2, a3, a4, d1, d2, d3, d4];
        // for i in 0..lens.len() {
        //     write_u32_le(&mut out[i * 4..(i + 1) * 4], lens[i]);
        // }
    }




}
