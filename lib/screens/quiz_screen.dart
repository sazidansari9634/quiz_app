import 'dart:async';

import 'package:flutter/material.dart';
import 'package:quiz_app/colors.dart';
import 'package:quiz_app/screens/result_screen.dart';
import 'package:quiz_app/services/api_services.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
    late Future quiz;
  int seconds = 60;
  var currentIndexOfQuestion = 0;
  Timer? timer;
  bool isLoading = false;
  var optionList = [];
  int correctAnswers = 0;
  int incorrectAnswers = 0;
  
  @override
  void initState() {
    super.initState();
    quiz = getQuizData();
    startTime();
  }

  var optionColor = [
   Colors.white,
   Colors.white,
   Colors.white,
   Colors.white,
   Colors.white,
  ];
  //reset color in every question
  resetColor(){
    optionColor = [
   Colors.white,
   Colors.white,
   Colors.white,
   Colors.white,
   Colors.white,
  ];
  }



  startTime(){
    timer = Timer.periodic(const Duration(seconds: 1), (timer){
      setState(() {
        if(seconds > 0){
          seconds--;
        } else{
          gotNextQuestion();
        }
      });
    });
  }
  gotNextQuestion(){
   setState(() {
    isLoading = false;
   resetColor();
   currentIndexOfQuestion++;
   timer!.cancel();
   seconds = 60;
   startTime();
   });
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.all(15),
        decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [Colors.blue, blue, darkBlue])),
        child: FutureBuilder(
            future: quiz,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              //for error handing
              if(snapshot.connectionState == ConnectionState.waiting){
                 return const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Colors.white),
                  ),
                );
              } else if (snapshot.hasError){
                return Center(
                  child: Text("Error:${snapshot.error}",
                  style: const TextStyle(color: Colors.white),
                  ),
                );
              }
              else if (snapshot.hasData) {
                var data = snapshot.data["results"];
                if (isLoading == false){
                  optionList = data[currentIndexOfQuestion]['incorrect_answers'];
                  optionList.add(data[currentIndexOfQuestion]['correct_answer']);
                  optionList.shuffle();
                  isLoading = true;
                }
                return SafeArea(
                    child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  border:
                                      Border.all(color: Colors.red, width: 3)),
                              child: IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: const Icon(
                                    Icons.close,
                                    color: Colors.red,
                                    size: 30,
                                  ))),
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Text(
                                "$seconds",
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 25),
                              ),
                              SizedBox(
                                height: 70,
                                width: 70,
                                child: CircularProgressIndicator(
                                  value: seconds / 60,
                                  valueColor: const AlwaysStoppedAnimation(
                                      Colors.white),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: Image.asset(
                          "assets/images/quiz.png",
                          width: 150,
                          height: 80,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Align(
                        alignment: Alignment.centerLeft,
                        child:  Text(
                            "Question ${currentIndexOfQuestion + 1} of ${data.length}",
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold
                            ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(data[currentIndexOfQuestion]['question'],style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18
                      ),),
                      const SizedBox(height: 20,),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: optionList.length,
                        itemBuilder: (BuildContext context , int index){
                        var correctAnswer = data[currentIndexOfQuestion]['correct_answer'];
                        return GestureDetector(
                          onTap: () {
                         
                            setState(() {
                              if (correctAnswer.toString() ==
                              optionList[index].toString()
                            ){
                              //correct option color
                              optionColor[index] = Colors.green;
                              correctAnswers++; //it means add the correctAnswer number until the last question;
                            } else {
                              optionColor[index] = Colors.red;
                              incorrectAnswers++; //it means add the incorrectAnswer number until the last question;

                            }
                            if (currentIndexOfQuestion < data.length - 1){
                              //delay 1 section after selection any option
                              Future.delayed(const Duration(milliseconds: 400),(){
                                gotNextQuestion();
                              });
                            } else {
                              timer!.cancel();
                             Navigator.push(context, 
                             MaterialPageRoute(builder: (context)=> ResultScreen(
                              correctAnswers, 
                             incorrectAnswers, 
                             currentIndexOfQuestion+1))
                             );
                            }
                            });
                            
                          },
                          child: Container(
                            margin: EdgeInsets.only(bottom: 20),
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width - 100,
                            padding: EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: optionColor[index],
                              borderRadius: BorderRadius.circular(10)
                            ),
                            child: Text(
                              optionList[index].toString(),
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.black
                              ),
                            ),
                          ),
                        );
                        },
                      )
                    ],
                  ),
                ));
              } else {
                return const Center(
                  child: Text("No data Found")
                );
              }
            }),
      ),
    );
  }
}
