// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract Users {
    Calculator[] calculators;

    function createCalculator() public {
        Calculator calc = new Calculator();
        calculators.push(calc);
    }

    function additionCalc(address calc, uint256 num1, uint256 num2) public {
        Calculator(calc).addition(num1, num2);
    }

    function subtractionCalc(address calc, uint256 num1, uint256 num2) public {
        Calculator(calc).subtraction(num1, num2);
    }

    function multiplicationCalc(
        address calc,
        uint256 num1,
        uint256 num2
    ) public {
        Calculator(calc).multiplication(num1, num2);
    }

    function divisionCalc(address calc, uint256 num1, uint256 num2) public {
        Calculator(calc).division(num1, num2);
    }

    function getSingleCalculation(
        address calc
    )
        public
        view
        returns (
            uint256 num1,
            uint256 num2,
            uint256 result,
            Calculator.Operators operator
        )
    {
        return Calculator(calc).getCalculation();
    }

    function getHistory(
        address calc
    ) public view returns (Calculator.Calculation[] memory) {
        return Calculator(calc).getHistory();
    }

    function getCalculatorUsers() public view returns (Calculator[] memory) {
        return calculators;
    }
}

contract Calculator {
    struct Calculation {
        uint256 num1;
        uint256 num2;
        uint256 result;
        Operators operator;
    }

    enum Operators {
        ADD,
        SUB,
        MUL,
        DIV
    }

    mapping(address => Calculation) user;
    mapping(address => Calculation[]) history;

    function addition(uint256 num1, uint256 num2) public {
        uint256 result = num1 + num2;
        storeCalculation(num1, num2, result, Operators.ADD);
    }

    function subtraction(uint256 num1, uint256 num2) public {
        uint256 result = num1 - num2;
        storeCalculation(num1, num2, result, Operators.SUB);
    }

    function multiplication(uint256 num1, uint256 num2) public {
        uint256 result = num1 * num2;
        storeCalculation(num1, num2, result, Operators.MUL);
    }

    function division(uint256 num1, uint256 num2) public {
        require(num2 != 0, "0 is not Valid.");
        uint256 result = num1 / num2;
        storeCalculation(num1, num2, result, Operators.DIV);
    }

    function storeCalculation(
        uint256 _num1,
        uint256 _num2,
        uint256 _result,
        Operators _operator
    ) public {
        Calculation memory calculation = Calculation({
            num1: _num1,
            num2: _num2,
            result: _result,
            operator: _operator
        });
        user[msg.sender] = calculation;
        history[msg.sender].push(calculation);
    }

    function getCalculation()
        public
        view
        returns (uint256 num1, uint256 num2, uint256 result, Operators operator)
    {
        Calculation memory calculation = user[msg.sender];
        return (
            calculation.num1,
            calculation.num2,
            calculation.result,
            calculation.operator
        );
    }

    function getHistory() public view returns (Calculation[] memory) {
        return history[msg.sender];
    }
}
