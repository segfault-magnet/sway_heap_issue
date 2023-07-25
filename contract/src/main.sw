contract;

use abi::MyContract;

impl MyContract for Contract {
    fn nested_vec() -> Vec<u8> {
        let mut nani = Vec::new();
        nani.push(16);
        nani.push(32);
        nani
    }
}
