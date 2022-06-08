library lib;

// anything `pub` here will be exported as a part of this library's API

pub enum SomeEnum {
	v1: b256,
	v2: u32
}


abi MyContract {
    fn test_function() -> SomeEnum;
}


