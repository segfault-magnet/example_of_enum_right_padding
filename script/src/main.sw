script;
use lib::{MyContract,SomeEnum};

fn main() {

	let call_me = abi(MyContract, 0x5c94bd292471571ef6637f5d45783f6a690754e093691a25d77257f0b95a95c6);
	call_me.test_function();
}
