pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Token is ERC20{
    constructor(
        string memory name, 
        string memory sympol, 
        uint256 initialSupply
    )ERC20(name, sympol){
        _mint(msg.sender, initialSupply);
    }
}