// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract SimpleStorage{
    // This is set as a default value of zero
     uint256 public  favoriteNumber;

     // Heres an exemple of Structs 
     struct People {
         string name ;
         uint256 PhoneNumber;
         string Email;
     }

     function store(uint256 _favoriteNumber) public {
         favoriteNumber = _favoriteNumber;
     }

     function retrive() public view returns(uint256){
         return favoriteNumber;
     }
}