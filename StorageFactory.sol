//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;
import "./simpleStorage.sol";

// Adding "is simpleStorage " in our contract SrorageFactory name ,make us to inhereted all the functionality from simpleStorage contract
contract StorageFactory is SimpleStorage {
    SimpleStorage[] public simpleStoragearray;

    function createaNewStorageContract()public{
        SimpleStorage simpleStorage = new SimpleStorage();
        simpleStoragearray.push(simpleStorage);
        
    }

    function sfStore(uint256 _simpleStorageIndex, uint256 _simpleStorageNumber)public {
        // Any Time you want to interact with another contract you need to things 
        // contract address
        // And the ABI
        // In order to get the address of the simplesStorage contract we can do like that 
        SimpleStorage(address(simpleStoragearray[_simpleStorageIndex])).store(_simpleStorageNumber);
        // now that we manage to get our address we're able to access any function from our outside contract
        // and we can access lets say a function Store like that 
          
    }
    function sfGet(uint256 _simpleStorageIndex) public view returns (uint256){
        return SimpleStorage(address(simpleStoragearray[_simpleStorageIndex])).retrive();
        //Wth this line of code we're accessing our array index and retriving the value we want with the help of our function retrive
                
    }
}
// if we dewploy our contract we'll see our functions createNewStorageContract -> Which are responsible to create our contract and 
// -> adds to our arrays
// also we'll see our function sfStore that store number to our array
// and our function sfRetrive that you return the value we store at the function sfStore 