// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

contract MultiSigWallet {
    //events

    //storage variables

    address[] public owners;
    mapping(address => bool) public isOwner;
    uint256 public immutable numConfirmationsRequired;

    struct Transaction {
        address to;
        uint256 value;
        bytes32 data;
        bool executed;
        uint256 numConfirmations;
    }

    //mapping from tx index => owner => bool
    mapping(uint256 => mapping(address => bool)) public isConfirmed;

    Transaction[] public transactions;

    //modifers
    modifier onlyOwner() {
        require(isOwner[msg.sender], "not owner");
        _;
    }

    modifier txExists(uint256 txIndex) {
        require(txIndex < transactions.length, "tx does not exist");
        _;
    }

    modifier notExecuted(uint256 txIndex) {
        require(transactions[txIndex].executed == false, "tx already executed");
        _;
    }

    modifier notConfirmed(uint256 txIndex) {
        require(isConfirmed[txIndex][msg.sender] == false, "tx already confirmed");
        _;
    }

    //constructor
    constructor(address[] memory _owners, uint256 _numConfirmationsRequired) {
        require(_owners.length > 0, "owners required");
        require(
            _numConfirmationsRequired > 0 && _numConfirmationsRequired <= _owners.length,
            "invliad number of required confirmations"
        );

        for (uint256 i = 0; i < owners.length; i++) {
            address owner = _owners[i];

            require(owner != address(0), "invalid address");
            require(!isOwner[owner], "owner must be unique");

            isOwner[owner] = true;
            owners.push(owner);
        }
        numConfirmationsRequired = _numConfirmationsRequired;
    }

    //public functions
    function submitTransaction(address _to, uint256 _value, bytes memory _data) public onlyOwner {
        uint256 txIndex = transactions.length;

        transactions.push(Transaction({to: _to, value: _value, data: _data, executed: false, numConfirmations: 0}));
        emit SubmitTransaction(msg.sender, txIndex, _to, _value, _data);
    }

    //public view functions
}
