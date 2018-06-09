pragma solidity ^0.4.0;

contract PaymentChannel
{
    
    address owner = msg.sender;
    address to;
    uint256 value;

    function openChannel(address _to)public payable
    {           
          if(msg.value == 0){throw;}
             if(msg.sender != owner){throw;}
                to = _to; 
                value = msg.value;
    }
    
    
    function closeChannel(
        bytes32 msg_hashValue, 
        bytes32 r, 
        bytes32 s, 
        uint8 v, 
        uint8 payment_value, 
        string prefix)
    {   
        if(msg.sender != to){throw;}
        address signer = ecrecover(msg_hashValue, v, r, s);
        if(signer == owner){
                bytes32 proof = sha3(prefix, value);
                       if(proof !=msg_hashValue){throw;}
                                 if(value >= payment_value){
                                     
                                       to.transfer(payment_value);
                                       value  -= payment_value;
                                       selfdestruct(owner);
                                       
                                 }
                                 else{throw;}
        }
        else{
            throw;
        }
    }
    
    }

    
