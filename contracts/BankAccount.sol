// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.4.22 <=0.8.24;

// Uncomment this line to use console.log
// import "hardhat/console.sol";
contract BankAccount {
    event Deposit(
        address indexed user,
        uint indexed accountId,
        uint value,
        uint timestamp
    );
    event WithdrawRequested(
        address indexed user,
        uint indexed accountId,
        uint indexed withdrawId,
        uint amount,
        uint timestamp
    );
    // for successfully withdraw
    event Withdraw(uint indexed withdrawId, uint timestamp);
    event AccountCreated(address[] owners, uint indexed id, uint timestamp);

    struct WithdrawRequest {
        address user;
        uint amount;
        uint approvals;
        mapping(address => bool) ownersApproved;
        bool approved;
    }

    struct Account {
        address[] owners;
        uint balance;
        mapping(uint => WithdrawRequest) withdrawRequests;
    }

    mapping(uint => Account) accounts;
    mapping(address => uint[]) userAccounts;
    uint nextAccountId;
    uint nextWithdrawId;
    
    modifier accountOwner(uint accountId) {
        bool isOwner;
        for (uint idx; idx < accounts[accountId].owners.length; idx++) {
            if (accounts[accountId].owners[idx] == msg.sender) {
                isOwner = true;
                break;
            }
        }
        require(isOwner, "you are not owner of this account");
        _;
    }



    function deposit(uint accountId) external payable accountOwner(accountId) {
        accounts[accountId].balance += msg.value;
    }

// account create
    function createAccount(address[] calldata otherOwners) external {
        address[] memory owners = new address[](otherOwners.length+1);
        owners[otherOwners.length] = msg.sender;
        uint id = nextAccountId;
        for (uint idx; idx<owners.length; idx++){
            if(idx<owners.length-1){
                owners[idx] = otherOwners[idx];
            }
            if(userAccounts[owners[idx]].length>2){
                revert("user can have max of 3 accounts);
            }
            userAccounts[owners[idx]].push(owners[idx]);
        }
        accounts[id].owners = owners;
        nextAccountId++;
        emit AccountCreated(owners,id,block.timestamp);
    }

    function requestWithdrawl(uint accountId, uint amount) external {
        uint256 id = nextWithdrawId;
        WithdrawRequest storage request = accounts[accountId].withdrawRequests[id];
        request.user = msg.sender;
        request.ammount = amount;
        nextWithdrawId++;
        emit WithdrawRequested(
            msg.sender,
            accountId,
            id,
            amount,
            block.timestamp
        );
    }

    function approveWithdrawl(uint accountId, uint withdrawId) external {}

    // to withdraw amount into the requister account
    function withdraw(uint accountId, uint withdrawId) external {}

    function getBalance(uint accountId) public view returns (uint) {}

    function getOwners(uint accountId) public view returns (address[] memory) {}

    // return number of approvar
    function getApprovals(
        uint accountId,
        uint withdrawId
    ) public view returns (uint) {}

    function getAccounts() public view returns (uint[] memory) {}
}
