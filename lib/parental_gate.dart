import 'dart:math';
import 'package:flutter/material.dart';

String answer;
int firstNumber = 0;
int secondNumber = 0;
String solution;
final myController = TextEditingController();

void solvePuzzle() {
  firstNumber = generateRandomNumbers();
  secondNumber = generateRandomNumbers();
  solution = (firstNumber + secondNumber).toString();
//  setState(() {});
}

generateRandomNumbers() {
  int min = 1;
  int max = 100;
  int randomNumber = Random().nextInt(max - min);
  if(randomNumber == 0){
    randomNumber = min + (Random().nextInt(max - min));
  }
  return randomNumber;
}

@override
void initState() {
  firstNumber = generateRandomNumbers();
  secondNumber = generateRandomNumbers();
  solution = (firstNumber + secondNumber).toString();
//  super.initState();
}

void iState() {
  firstNumber = generateRandomNumbers();
  secondNumber = generateRandomNumbers();
  solution = (firstNumber + secondNumber).toString();
}

