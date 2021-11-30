**Reentrancy attacks** can occur when an external function is called before internal work can be completed (SWC-107).
Though perhaps not critical in this case, I still made sure that in the `MetaMarket` contract's `createListing()` function called `safeTransferFrom` at the end of the method, after the internal state had been settled.

**Timestamp manipulation** can be achieved by miners, therefore its best to avoid using timestamps when possible (SWC-116).  The `MetaMarket` does not depend on any timestamps.

**Integer overflow** can occur when the value of a uint overflows the allocated memory (ex. uint256).  I've added at `require` check to the `createListing()` method to ensure that the supplied `price` variable does not exceed memory limits.

