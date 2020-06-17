pragma solidity ^0.5.0;

contract Switch{

    address primary;
    address recovery;
    uint lastCheckedBlock;
    uint deposits = 0;
    function setPrimaryAddress() external{
        require(primary == address(0x0),"Primary address already set");
        primary = msg.sender;
    }
    
    function setRecoveryAddress(address _recovery) external{
        require(primary != address(0x0) && recovery == address(0x0),"Please provide primary address first/Recovery address already set");
        recovery = _recovery;
        lastCheckedBlock = block.number;
    }
    
    function depositEth() external payable {
        deposits = deposits + msg.value;
    }   

    function checkIn() external {
        require(msg.sender == primary,"Please use your primary address");
        lastCheckedBlock = block.number;
    }    

    function transferFunds() external{
        require(msg.sender == recovery && ((block.number - lastCheckedBlock)>=10),"Please use your recovery address");
        address payable _recovery = address(uint160(recovery));
        _recovery.transfer(address(this).balance);
    }
}