#[macro_use] extern crate magic_crypt;

use magic_crypt::MagicCryptTrait;

fn main() {
    let encrypted_string = encryptPassword("mykey", "hallowelt1234");
    println!("Encrypted String: {}", encrypted_string);
    let decrypted_string = decryptPassword("mykey", encrypted_string)
    println!("Decrypted String: {}", decrypted_string);
}

fn encryptPassword(key:String, password: String ) -> String {
    let mcrypt = new_magic_crypt!(key, 256);
    return mcrypt.encrypt_str_to_base64(password);
}

fn decryptPassword(key:String, password: String ) -> String) {
    let mcrypt = new_magic_crypt!(key, 256);
    return mcrypt.decrypt_base64_to_string(password);
}


use wasm_bindgen::prelude::*;

#[wasm_bindgen]
extern {
    pub fn alert(s: &str);
}

#[wasm_bindgen]
pub fn greet(name: &str) {
    alert(&format!("Hello, {}!", name));
}