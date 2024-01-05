use dep::std;


fn u32t8le(v: u32, output: &mut [u8;64]) {
    output[0] = v as u8 & 0xff;
    output[1] = (v >> 8) as u8 & 0xff;
    output[2] = (v >> 16) as u8 & 0xff;
    output[3] = (v >> 24) as u8 & 0xff;
    
}

fn u8t32le(p:[u8;4]) -> u32 {
    p[0] as u32 | (p[1] as u32) << 8 | (p[2] as u32) << 16 | (p[3] as u32) << 24
}

pub fn rot32(x: u32, n: i32) -> u32 {
    (x << (n as u32)) | (x >> (std::wrapping_mul(n,-1) as u32 & 31))
}

fn quarterround(x: &mut [u32;16], a: u32, b: u32, c: u32, d: u32) {
    x[a] = std::wrapping_add(x[a],x[b]);
    x[d] = rot32(x[d] ^ x[a], 16);
    x[c] = std::wrapping_add(x[c],x[d]);
    x[b] = rot32(x[b] ^ x[c], 12);
    x[a] = std::wrapping_add(x[a],x[b]);
    x[d] = rot32(x[d] ^ x[a], 8);
    x[c] = std::wrapping_add(x[c],x[d]);
    x[b] = rot32(x[b] ^ x[c], 7);

}

fn chacha20_serialize(input: &mut [u32;16], output: &mut [u8;64])->[u8;64] {
    // let mut out:[u8;4] = [0;4];
    for i in 0..16 {
        u32t8le(input[i], output);
        
        for j in 4..64 {
            output[j - 4] = output[j];
        }
        output[60] = 0;
        output[61] = 0;
        output[62] = 0;
        output[63] = 0;
    //    let out = u32t8le(input[i]);
    }
    *output
}


fn chacha20_block(input: &mut [u32;16]) -> [u8;64] {
    let mut x:[u32;16] = [0;16];
    for i in 0..16 {
        x[i] = input[i];
    }

    
    for _ in 0..10 {
        quarterround(&mut x, 0, 4, 8, 12);
        quarterround(&mut x, 1, 5, 9, 13);
        quarterround(&mut x, 2, 6, 10, 14);
        quarterround(&mut x, 3, 7, 11, 15);
        quarterround(&mut x, 0, 5, 10, 15);
        quarterround(&mut x, 1, 6, 11, 12);
        quarterround(&mut x, 2, 7, 8, 13);
        quarterround(&mut x, 3, 4, 9, 14);
    }
    for i in 0..16 {
        input[i] = std::wrapping_add(input[i], x[i]);
    }
    chacha20_serialize(input, &mut [0;64])
}



fn chacha20_init_state(state: &mut [u32;16], key: [u8;32], counter: u32,nonce: [u8;12]) {

    state[0] = 0x61707865;
    state[1] = 0x3320646e;
    state[2] = 0x79622d32;
    state[3] = 0x6b206574;
    for i in 0..8 {
        state[4 + i] = u8t32le([key[4 * i], key[4 * i + 1], key[4 * i + 2], key[4 * i + 3]]);
    }


    state[12] = counter;
    for i in 0..3 {
        state[13 + i] = u8t32le([nonce[4 * i], nonce[4 * i + 1], nonce[4 * i + 2], nonce[4 * i + 3]]);
    }
  
}

pub fn ChaCha20XOR(key: [u8;32], counter:u32, nonce: [u8;12], input: &mut [u8], output: &mut [u8;128]) {
    let mut state:[u32;16] = [0;16];
    let mut block:[u8;64] = [0;64];
    let in_len = 114;

    chacha20_init_state(&mut state, key, counter, nonce);
    

    let mut i = 0;

    for j in 0..3 {
        i = j*64;

        if ((i as u16)<in_len) {
            block = chacha20_block(&mut state);
            state[12] = std::wrapping_add(state[12], 1);
            for k in 0..64 {
                output[i + k] = input[i + k] ^ block[k];
            }
        }

    }


}


