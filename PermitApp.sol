pragma solidity >=0.4.22 <0.6.0;
contract PermitApp {
    struct Permission {
        uint id;
        address owner;
        address receiver;
    }
    Permission[] private permissions;
    address public manager;
    mapping(address => Permission) public hasAccess;
    mapping(address => bool) public hasGiven;

    //only allows the contact deployer to check and give contract address access.
    modifier onlyManager(address tempName) {
        if(tempName == address(this)) {
            require(msg.sender == manager);
        }
        _;
    }
    function init() public{
        manager = msg.sender;
    }
    
    // event Transaction(address receiver, address giver);
    function getCount() private view returns(uint count) {
        return permissions.length;
    }
    
    function giveAccess(address toBeGiven) onlyManager(toBeGiven) public{
        // emit Transaction(toBeGiven, msg.sender);
        Permission memory newPermission = Permission({
            id: getCount(),
            owner: msg.sender,
            receiver: toBeGiven
        });
        hasAccess[toBeGiven] = newPermission;
        hasGiven[msg.sender] = true;
        permissions.push(newPermission);
        
    }
    
    //enter the id associated with your transaction, followed by the address you want to check
    //you'll then receive a boolean saying true if you have received Permission from entered address
    function checkAccess(uint _id, address toBeChekced) onlyManager(toBeChekced) public view returns(bool){
        if(permissions[_id].receiver == msg.sender) {
            return true;
        }
        else {
            return false;
        }
    }
}
