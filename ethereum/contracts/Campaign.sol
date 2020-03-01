pragma solidity ^0.4.17;

contract CampaignFactory {
    address[] public deployedCampaigns;
    
    function createCampaign(uint _minimumContribution) {
        address newCampaign =  new Campaign(_minimumContribution, msg.sender);
        deployedCampaigns.push(newCampaign);
        
    }
    
    function getDeployedCampaigns() public view returns (address[]) {
        return deployedCampaigns;
    }
}

contract Campaign {
    // a struct introduces a new type
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
    uint public contributorsCount;

    modifier restricted() {
        require(msg.sender == manager);
        _;
    }

    
    function Campaign(uint _minimumContribution, address _creatorAddress) public {
        manager = _creatorAddress;
        minimumContribution = _minimumContribution;
    }
    
    function contribute() public payable {
        require(msg.value > minimumContribution);
        approvers[msg.sender] = true;
        contributorsCount++;
    }
    
    function createRequest(string _description, uint _value, address _recipient) 
    public restricted {
        
        // require(approvers[msg.sender]);
        
        Request memory newRequest = Request({
            description: _description,
            value: _value,
            recipient: _recipient,
            complete: false,
            approvalCount: 0
        });
        
        requests.push(newRequest);
        }
        
        function approveRequest(uint _index) public {
            Request storage request = requests[_index];
            
            require(approvers[msg.sender]);
            require(!requests[_index].approvals[msg.sender]);
            
            request.approvals[msg.sender] = true;
            request.approvalCount++;
        }
        
        function finalizeRequest(uint _index) public restricted {
            Request storage request = requests[_index];
            
            require(request.approvalCount > (contributorsCount / 2));
            require(!request.complete);
            
            request.recipient.transfer(request.value);
            request.complete = true;
        }
 
}