import 'package:flutter/material.dart';
import 'package:quiz_app/colors.dart';
import 'package:quiz_app/screens/quiz_splashscrren.dart';

class ResultScreen extends StatelessWidget {
  final int correctAnswer;
  final int incorrectAnswer;
  final int totalQuestion;
  const ResultScreen(
    this.correctAnswer,
    this.incorrectAnswer,
    this.totalQuestion,
    {super.key,});

  @override
  Widget build(BuildContext context) {
    double correctPercentage = (correctAnswer/totalQuestion*100); //formula to convert the number of percentage
    return Scaffold(
      body: Container(
         width: double.infinity,
          height: double.infinity,
          padding: const EdgeInsets.all(15),
          decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [Colors.blue, blue, darkBlue])),
        child:  Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/images/trophy.png",
                          width: 80,
                          height: 80,),
              const SizedBox(height: 10),            
              const Text("Congratulation You Got",style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.white
              ),),
               Text(
                "${correctPercentage.toStringAsFixed(1)}%",style: const TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.white
              ),),
               Text(
                "Correct Answer: $correctAnswer",style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green
              ),),
               Text(
                "Incorrect Answer: $incorrectAnswer",style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.red
              ),),
              const SizedBox(height: 20,),
              ElevatedButton(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> const QuizSplashScreen()));
                }, 
                child: const Text("Back to Home"))
            ],
          ),
        ),
      ),
    );
  }
}