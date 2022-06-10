script;
use lib::{MyContract,SomeEnum};

fn main() {

	let call_me = abi(MyContract, CONTRACT_ID);
	call_me.test_function();
}
