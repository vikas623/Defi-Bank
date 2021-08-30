// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;


import "./Token.sol";

contract dBank {

    //Assign Imported Contract to Variable
    Token private token;

    //Mapping
    mapping(address => uint) public etherBalanceOf;
    mapping(address => uint) public depositStart;
    mapping(address => bool) public isDeposited;
    mapping(address => uint256) public balanceOf;

    //events
    event Deposit(address indexed user, uint etherAmount, uint timestart);
    event Withdraw(address indexed user, uint etherAmount, uint depositTime, uint interest);
    constructor(Token _token)  {
        token = _token;
    }

    function deposit() payable public {
        // check if deposit is active or not
        require(isDeposited[msg.sender] == false, 'Error, deposit already active');
        require(msg.value >= 1e16, 'Error, deposit must be>= 0.01 ETH');
        
        //Deposit balace Deducted From Account
        etherBalanceOf[msg.sender] += msg.value;
        depositStart[msg.sender] += block.timestamp; 

        isDeposited[msg.sender] = true;
        emit Deposit(msg.sender, msg.value, block.timestamp);

    }
    function withdraw() payable public  {
        require(isDeposited[msg.sender] ==true, 'Error, deposit should be done before withdrawing');
        uint userBalance = etherBalanceOf[msg.sender];

        //check user's hodl time
        uint depositTime = block.timestamp - depositStart[msg.sender];

        //31668017 - interest(10% APY) per second for min. deposit amount (0.01 ETH), cuz:
        //1e15(10% of 0.01 ETH) / 31577600 (seconds in 365.25 days)

        //(etherBalanceOf[msg.sender] / 1e16) - calc. how much higher interest will be (based on deposit), e.g.:
        //for min. deposit (0.01 ETH), (etherBalanceOf[msg.sender] / 1e16) = 1 (the same, 31668017/s)
        //for deposit 0.02 ETH, (etherBalanceOf[msg.sender] / 1e16) = 2 (doubled, (2*31668017)/s)

        uint interestPerSecond = 3166801 * (userBalance / 1e16);
        uint interest = interestPerSecond * depositTime;

        balanceOf[msg.sender] = balanceOf[msg.sender] + userBalance;

        // msg.sender.transfer(msg.sender, userBalance); 
        token.mint(msg.sender, interest);

        // reset values
        depositStart[msg.sender] = 0;
        etherBalanceOf[msg.sender] = 0;
        isDeposited[msg.sender] = false;

        // emit logs
        emit Withdraw(msg.sender, userBalance, depositTime, interest);

    }
    function borrow() payable public {

    }
    function payoff() payable public {

    }
}