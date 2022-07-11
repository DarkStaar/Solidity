// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract Structs
{
    struct Car 
    {
        string model;
        uint year;
        address owner;
    }

    Car public car; //define

    Car[] public cars; //Array

    mapping(address => Car[]) public carsByOwner; // We can map array of cars for 1 owner

    //Some ways to init struct
    function examples() external
    {
        Car memory toyota = Car("Toyota", 1990, msg.sender); //When using memory it exists only in current function.
        Car memory lambo = Car({model : "Lamborghini", year: 1980, owner: msg.sender}); //For key-value pairs order of assigning doesnt matter
        Car memory tesla;
        tesla.model = "Tesla";
        tesla.owner = msg.sender;
        tesla.year = 2020;

        cars.push(toyota);
        cars.push(lambo);
        cars.push(tesla);

        cars.push(Car ("Ferrari", 2020, msg.sender)); //init car and push it in the same time

        Car storage _car = cars[0]; //Read 1st element of Cars array
        //MEMORY VS STORAGE
        // Memory means we want to load some variable inside of memory of this function and when function finishes it doesnt change
        //Storage means that we want to update variable stored in this smart contract.
        
        _car.year = 1999;

        delete _car.owner; //Reset to default value

        delete cars[1]; //Reset to default whole structure
    }

    //ENUMERATION

    enum Status 
    {
        None,
        Pending,
        Shipped,
        Completed,
        Rejected,
        Canceled
    }

    Status public status;

    struct Order
    {
        address buyer;
        Status status;
    }

    Order[] public orders;

    function get() view external returns(Status)
    {
        return status;  //Return current status of status variable
    }

    function set(Status _status) external 
    {
        status = _status;   //Set status for status variable
    }

    function shipped() external 
    {
        status = Status.Shipped;    //Change status to Shipped
    }

    function reset() external
    {
        delete status; //Resets status var to default value, default is first in enum
    }
}