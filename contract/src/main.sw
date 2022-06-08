contract;

use lib::{MyContract, SomeEnum};

impl MyContract for Contract {
    fn test_function() -> SomeEnum {
        SomeEnum::v2(2)
    }
}
