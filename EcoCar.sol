// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import "./../../interfaces/ICar.sol";

contract EcoCar is ICar {
    function takeYourTurn(
        Monaco monaco,
        Monaco.CarData[] calldata allCars,
        uint256[] calldata /*bananas*/,
        uint256 ourCarIndex
    ) external override {
        Monaco.CarData memory ourCar = allCars[ourCarIndex];
       
        //win the race if possible 
            if (
            ourCar.y > 750 &&
            ourCar.balance >= monaco.getAccelerateCost(1000 - (ourCar.y + ourCar.speed))
        ) {
            monaco.buyAcceleration(1000 - (ourCar.y + ourCar.speed));
            return;
        }


        
        // buy almost for free expnesive actions 
        if(monaco.getShellCost(1)<10 || monaco.getBananaCost()<10 || monaco.getSuperShellCost(1)<10){ 

             if(monaco.getSuperShellCost(1)<10 && ourCar.balance > monaco.getSuperShellCost(3))
            monaco.buySuperShell(3);

            if(monaco.getShellCost(1)<10 && ourCar.balance > monaco.getShellCost(3))
            monaco.buyShell(3);

            if(monaco.getBananaCost()<10 && ourCar.balance > monaco.getBananaCost())
             monaco.buyBanana();

                        
        }

        //logic for when our car is in the first place
        if(ourCarIndex==0){
               
                if(allCars[1].balance > monaco.getShellCost(1) && ourCar.balance > monaco.getShieldCost(2) ){
                      ourCar.balance -= uint24(monaco.buyShield(2));
                }
                //maintain speed above the other cars 
               if(allCars[1].speed > ourCar.speed){
                if(ourCar.balance>monaco.getAccelerateCost(allCars[1].speed - ourCar.speed)){
                     ourCar.balance -= uint24(monaco.buyAcceleration(allCars[1].speed - ourCar.speed));
                }
            }
            //throw banana if it's chepaer than regain the speed for the car behind
            else if(monaco.getBananaCost() < monaco.getAccelerateCost(allCars[1].speed) && ourCar.balance >monaco.getBananaCost()){
                  ourCar.balance   -= uint24(monaco.buyBanana());
            }
               //accelration boost 
             if(monaco.getAccelerateCost(1)<100 && ourCar.balance > monaco.getAccelerateCost(5)){
               ourCar.balance -= uint24( monaco.buyAcceleration(5));
             }


            


        }
        //logic for when our car is in the second place 
        if(ourCarIndex == 1){

               if(allCars[2].balance > monaco.getShieldCost(1) && ourCar.balance > monaco.getShieldCost(1) ){
                    ourCar.balance -= uint24(monaco.buyShield(1));
                }
               if(monaco.getBananaCost() < monaco.getAccelerateCost(allCars[2].speed) && ourCar.balance >monaco.getBananaCost()){
                    ourCar.balance -= uint24(monaco.buyBanana());
            }

               if(monaco.getAccelerateCost(allCars[0].speed)> monaco.getShellCost(1) &&  ourCar.balance>monaco.getShellCost(1) && allCars[0].shield == 0){
               ourCar.balance -= uint24( monaco.buyShell(1));
            }

         
                //gain the speed of the fastest car 
               if((ourCar.speed < allCars[0].speed || ourCar.speed < allCars[2].speed) && ourCar.balance > monaco.getAccelerateCost(allCars[0].speed > allCars[2].speed? allCars[0].speed-ourCar.speed : allCars[2].speed- ourCar.speed)){
                ourCar.balance -= uint24(monaco.buyAcceleration(allCars[0].speed > allCars[2].speed? allCars[0].speed-ourCar.speed : allCars[2].speed- ourCar.speed));
            }


               if(monaco.getAccelerateCost(1)<100 && ourCar.balance > monaco.getAccelerateCost(6)){
               ourCar.balance -= uint24 (monaco.buyAcceleration(6));
             }

        }
       

           //logic for third place
        if(ourCarIndex == 2){

            //use super shell only if its price is lower than the price of speed we decresse from the cars infront
            if(monaco.getAccelerateCost(allCars[1].speed + allCars[0].speed -1) > monaco.getSuperShellCost(1) && 
            ourCar.balance > monaco.getSuperShellCost(1)){
                ourCar.balance -= uint24(monaco.buySuperShell(1));
            }
            if(monaco.getAccelerateCost(allCars[1].speed)> monaco.getShellCost(1) &&  ourCar.balance>monaco.getShellCost(1) && allCars[1].shield == 0){
               ourCar.balance -= uint24( monaco.buyShell(1));
            }

            if(ourCar.balance > monaco.getAccelerateCost(allCars[0].speed > allCars[1].speed? allCars[0].speed : allCars[1].speed)){
                ourCar.balance -= uint24( monaco.buyAcceleration((allCars[0].speed > allCars[1].speed? allCars[0].speed : allCars[1].speed)));
            }
  else if(monaco.getAccelerateCost(1)<100 && ourCar.balance > monaco.getAccelerateCost(6)){
               ourCar.balance -= uint24(  monaco.buyAcceleration(6));
            
            }
        }
    }


    function sayMyName() external pure returns (string memory) {
        return "EcoCar";
    }
}
