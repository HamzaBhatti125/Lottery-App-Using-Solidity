pragma solidity ^ 0.4.17; 

contract Campaign {
    struct Request {
        string description;
        uint value;
        address recipient;
        bool complete;
    }
    
    Request[] public requests;
    
    address public manager;
    uint public minimumContribution;
    mapping(address => bool) public approvers;
    
     modifier restriced() {
        require(msg.sender == manager );
        _;
    }
    
    constructor(uint minimum) public{ //arg to functions are memory data
        manager = msg.sender;
        minimumContribution = minimum;
        
    }
    
    function contribute() public payable {
        require(msg.value > minimumContribution);
        
        approvers[msg.sender] = true; //key would not store in mapping
    }
    
    function createRequest(string description, uint value, address recipient) public restriced {
        Request memory newRequest = Request({
            description: description,
            value:value,
            recipient: recipient,
            complete: false
        });
        requests.push(newRequest);
    }
   
}