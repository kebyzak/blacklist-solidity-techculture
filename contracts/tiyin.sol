// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

contract Token {
    uint public allSupply = 1000000e18;

    address public owner = msg.sender;

    mapping(address=>uint) public balance;
    mapping(address=>mapping(address=>uint)) public allow;
    mapping(address => bool) public blacklisted;
    
    string public name = "Tyiyn";
    string public symbol = "TYI";
    uint8 public decimal = 18;

    function blacklist(address _account) public{
        require(owner == msg.sender, "should be owner");
        require(!blacklisted[_account], "blacklisted");
        blacklisted[_account] = true;
    }

    function unBlacklist(address _account) public{
        require(owner == msg.sender, "should be owner");
        require(blacklisted[_account], "whitelisted");
        blacklisted[_account] = false;
    }

    function totalSupply() external view returns(uint){
        return allSupply;
    }

    function balanceOf(address account) external view returns(uint){
        return balance[account];
    }

    function transfer(address recipient, uint amount) external returns(bool){
        require(!blacklisted[recipient], "user is backlisted");
        balance[owner] -= amount;
        balance[recipient] += amount; 
        emit Transfer(msg.sender, recipient, amount);
        return true;
    }

    function allowance(address ownerr, address spender) external view returns(uint){
        return allow[ownerr][spender];
    }

    function mint() public{
        require(owner == msg.sender, "should be owner");
        balance[msg.sender] = 500e18;
    }

    function approve(address spender, uint amount) external returns(bool){
        allow[msg.sender][spender] = amount;
        emit Approve(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint amount) external returns(bool){
        allow[sender][recipient] -= amount;
        balance[sender] -= amount;
        balance[recipient] += amount;
        emit Transfer(owner, recipient, amount);
        return true;
    }

    event Transfer(address indexed from, address indexed to, uint amount);
    event Approve(address indexed owner, address indexed spender, uint amount);
}