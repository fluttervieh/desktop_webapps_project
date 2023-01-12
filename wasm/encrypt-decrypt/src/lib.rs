use wasm_bindgen::prelude::*;

#[wasm_bindgen]
//pub fn encryptPassword(key:&str, password: &str ) -> Result<String, MagicCryptError> {
pub fn encryptPassword(key:String, password: String ) -> String {
    //let mcrypt = new_magic_crypt!(key, 256);
    //return mcrypt.encrypt_str_to_base64(password);
    return password;
}

#[wasm_bindgen]
pub fn decryptPassword(key:String, password: String ) -> String {
    //let mcrypt = new_magic_crypt!(key, 256);
    //return mcrypt.decrypt_base64_to_string(password);
    return password;
}