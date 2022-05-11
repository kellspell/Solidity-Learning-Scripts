//SPDX-License-Identifier: MIT
// In this lesson we are making a contract using the real currency values to be able to compare with ether
// What we're going to need
// What the ETH value in -> USD conversion rate ,for that import from chainlink

pragma solidity >=0.6.6 <0.9.0;

import "@chainlink/contracts/src/v0.6/interfaces?AggregatorV3Interface.sol";
import "@chainlink/contracts/src/v0.6/vendor/SafeMathChainlink.sol";

contract PriceFeed {
    using SafeMathChainlink for uint256;

    mapping(address => uint256) public addressToAmountFunded;
    //By adding a variable owner we set the owner for our contract
    address public owner;
    address[]public funders;

    constructor() public {
        // By using the constrauctor the first thing that will be compile at the start of our contract is to set the owner 
        owner = msg.sender;
    }

    function fund() public payable {
        // This bellow  sets a minimum value of 50 dollars as inicial amount
        uint256 minimumUsd = 50 * 10 ** 18;
        // 1gwey < $50
        require(getConversionRate(msg.value) >= minimumUsd, "You need to spend more Eth!");
        addressToAmountFunded[msg.sender] += msg.value;
        funders.push(msg.sender);
    }

    function getVersion() public view returns (uint256) {
        // Order to find the ETH -> USD priceFeed we need to grab the web link from Chainlink Documentation like bellow
        // but this functions is set to show us the version of the Interface us we usinf getVersion function
        AggregatorV3Interface priceFeed = AggregatorV3Interface(
            0x8A753747A1Fa494EC906cE90E9f37563A8AF630e
        );
        return priceFeed.version();
    }
    function getPrice() public view returns(uint256){
        AggregatorV3Interface priceFeed = AggregatorV3Interface(
            0x8A753747A1Fa494EC906cE90E9f37563A8AF630e
        );
        // Here bellow I'm using this commas as away to leave in blank  variables that are not in use Which coming from latesRoundData function
        // As you can see I'm just using " int256 answer"
        (,int256 answer,,,) = priceFeed.latestRoundData();
        return uint256(answer * 10000000000);
        // This answer will bring us a value of current price rate of Ethereum like this 256254442540
        // so we need to count 8 decimals like that 2,562.54442540


    }
    // How we converte this 10000000000 to USD
    function getConversionRate (uint256 ethAmount) public view returns (uint256){
        uint256 ethPrice = getPrice();
        // we need to do 
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1000000000000000000;
        return ethAmountInUsd;
         
    }
    modifier onlyOwner{
        require(msg.sender == owner);
        _; // Never forgets the underscore and a semicollen
        // What the modifier will do is ,Before the withdraw function start to run the modifier will say hey 
        // do this riquire statement firts  and then where your underscore on the modifier run the rest of the code 

    }
    function withdraw() payable onlyOwner public {
        // When we refers to (this like bellow ) we're refering  to this current contract        
        msg.sender.transfer(address(this).balance);
        // There's a easy way to work with our require statement up here 
        // is by using modifiers
        // Modifiers: A modifier is used to change the behavior of a funfction in a declarative way
        for (uint256 funderIndex=0; funderIndex < funders.length; funderIndex++){
            address funder = funders[funderIndex];
            addressToAmountFunded[funder]= 0;  
        }
        funders = new address[](0);
    }
    
}
