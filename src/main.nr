mod ChaChaStruct;

use dep::std;

pub fn main(key: [u8;32], nonce: [u8;12], plaintext: pub [u8;128]) {
    let mut encoder = ChaChaStruct::ChaChaCipher::new(key, 0, nonce);
    let encrypted = encoder.update(plaintext);

    let mut decoder = ChaChaStruct::ChaChaCipher::new(key, 0, nonce);
    let decrypted = decoder.update(encrypted);
    for i in 0..128 {
        assert(plaintext[i] == decrypted[i]);
    }
}

