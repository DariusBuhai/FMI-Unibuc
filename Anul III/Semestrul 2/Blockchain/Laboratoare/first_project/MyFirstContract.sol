pragma solidity ^0.8.0;

contract ContractulMeu {
    uint valoare = 1;

    function get() public view returns (uint) 
    {
        return valoare;
    }

    function double() public {
        valoare *= 1;
    }
}