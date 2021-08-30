// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Token is ERC20 {

    //Variable
    address public minter;

    //Events
    event MinterChanged(address indexed from, address indexed to);

    constructor() public payable ERC20("Decentralized Bank Currency", "DBC") {
        minter = msg.sender;
    }

    function passMinterRole(address dBank) public returns (bool) {
        require(msg.sender == minter, 'Error , msg.sender do not have minter role');
        minter = dBank;

        emit MinterChanged(msg.sender, dBank);
        return true;

    }

    function mint(address account, uint256 amount) public {
       require(msg.sender == minter, 'Error , msg.sender do not have minter role');
        _mint(account, amount);
    }


}
