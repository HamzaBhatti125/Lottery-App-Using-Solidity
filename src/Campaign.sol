pragma solidity ^ 0.4.17; 

contract Campaign {
    struct Request {
        string description;
        uint value;
        address recipient;
        bool complete;
        uint approvalCount;
        mapping(address => bool) approvals;
    }
    
    Request[] public requests;
    
    address public manager;
    uint public minimumContribution;
    mapping(address => bool) public approvers;
    uint public approversCount;
    
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
        approversCount++;
    }
    
    function createRequest(string description, uint value, address recipient) public restriced {
        Request memory newRequest = Request({
            description: description,
            value:value,
            recipient: recipient,
            complete: false,
            approvalCount: 0
        });
        requests.push(newRequest);
    }
    
    
    function approveRequest(uint index) public {
        Request storage request = requests[index];
        
        require(approvers[msg.sender]); //to check this person has contributed before
        require(!request.approvals[msg.sender]); //to check this person has not previously voted request
        
        request.approvals[msg.sender] = true;
        request.approvalCount++;
        
    }
    
    function finalizeRequest(uint index) public restriced {
        Request storage request = requests[index];
        
        require(request.approvalCount > (approversCount/2));
        require(!request.complete);
        
        request.recipient.transfer(request.value);
        request.complete = true;
    }
   
}