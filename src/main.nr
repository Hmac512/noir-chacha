mod ChaCha20Rng;
mod ChaCha20;
mod ChaCha20Encoder;
use dep::std;

use ChaCha20Encoder::ChaChaEncoder;

pub fn main(seed: [u8;32], id: [u8;12], expected: [[u8;16];8]) {
    let mut encoder = ChaChaEncoder::new(seed);
    let labels = encoder.get_encodings(id);
    for i in 0..expected.len() {
        for j in 0..expected[i].len() {
            assert_eq(labels[i][j], expected[i][j]);
        }
    }
}

