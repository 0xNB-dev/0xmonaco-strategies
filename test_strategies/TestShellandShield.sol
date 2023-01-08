// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import "./../../interfaces/ICar.sol";

contract TestShellandShield is ICar {
    function takeYourTurn(
        Monaco monaco,
        Monaco.CarData[] calldata allCars,
        uint256[] calldata /*bananas*/,
        uint256 ourCarIndex
    ) external override {
        Monaco.CarData memory ourCar = allCars[ourCarIndex];
        
        //testing shell<>shield realtions with floor prices 
        if (ourCar.balance > monaco.getAccelerateCost(1) && ourCar.speed <=10)
            monaco.buyAcceleration(1);
           


        if(ourCar.balance>monaco.getShellCost(1) && monaco.getShellCost(1) < /*200*/ && ourCarIndex>0)
                if(allCars[ourCarIndex+1].shield ==0)
                monaco.buyShell(1);

        if(ourCar.balance> monaco.getShieldCost(1) && monaco.getShieldCost(1)</*150*/  && ourCarIndex<2)
            monaco.buyShield(1);
        
    }

    function sayMyName() external pure returns (string memory) {
        return "TestShellandShield";
    }
}
