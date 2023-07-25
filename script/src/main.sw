script;

use abi::MyContract;
use std::assert::assert_eq;
use std::constants::ZERO_B256;

configurable {
    CONTRACT_ID: b256 = ZERO_B256
}

fn main() {
    let call_me = abi(MyContract, CONTRACT_ID);
    let nani: Vec<u8> = call_me.nested_vec();

    require(nani.get(0).unwrap() == 16u8, "Vec first element got corrupted before");
    require(nani.get(1).unwrap() == 32u8, "Vec second element got corrupted before");

    let mut another_vec: Vec<u8> = Vec::new();
    let mut counter = 0;
    while counter < 50 {
        counter += 1;
        another_vec.push(1u8);
    }

    // fails here with revert message 56656320666972737420656c656d656e7420676f7420636f72727570746564206166746572000000
    // meaning:
    // 	Vec first element got corrupted after
    require(nani.get(0).unwrap() == 16u8, "Vec first element got corrupted after");
    require(nani.get(1).unwrap() == 32u8, "Vec second element got corrupted after");
}
