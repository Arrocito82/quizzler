import 'package:flutter/material.dart';
import 'package:quizzler/quiz_brain.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

void main() {
  runApp(const QuizzlerApp());
}

QuizBrain quizBrain = QuizBrain();

class QuizzlerApp extends StatelessWidget {
  const QuizzlerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          appBar: AppBar(
            title: const Text(
              "Quizzler",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontFamily: "Poppins",
                fontSize: 30.0,
              ),
            ),
            titleSpacing: 8.0,
            leading: const Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: ImageIcon(AssetImage("images/quizzler-logo.png")),
            ),
            toolbarHeight: 60.0,
            leadingWidth: 40.0,
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color.fromRGBO(9, 120, 166, 1),
                      Color.fromRGBO(251, 148, 71, 1)
                    ]),
              ),
            ),
          ),
          body: const QuizzlerPage()),
    );
  }
}

class QuizzlerPage extends StatefulWidget {
  const QuizzlerPage({super.key});

  @override
  State<QuizzlerPage> createState() => _QuizzlerPageState();
}

class _QuizzlerPageState extends State<QuizzlerPage> {
  int wrongAnswersCounter = 0;
  int rightAnswersCounter = 0;
  bool reviewMode = false;

  void restartQuiz() {
    Navigator.pop(context);
    setState(() {
      wrongAnswersCounter = 0;
      rightAnswersCounter = 0;
      quizBrain.restart();
      reviewMode = false;
    });
  }

  void reviewQuiz() {
    Navigator.pop(context);
    setState(() {
      reviewMode = true;
    });
  }

  bool areQuestionsRemaining() {
    return wrongAnswersCounter + rightAnswersCounter < quizBrain.count();
  }

  void previousQuestion() {
    setState(() {
      quizBrain.previousQuestion();
    });
  }

  void nextQuestion() {
    setState(() {
      quizBrain.nextQuestion();
    });
  }

  void checkAnswer(bool userPickedAnswer) {
    setState(() {
      if (areQuestionsRemaining()) {
        if (userPickedAnswer == quizBrain.getQuestionAnswer()) {
          rightAnswersCounter++;
        } else {
          wrongAnswersCounter++;
        }
      } else {
        displayResults();
      }
      quizBrain.nextQuestion();
    });
  }

  DialogButton getReviewButton() => DialogButton(
        child: Text(
          "Review",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        onPressed: reviewQuiz,
        color: Colors.grey.shade600,
      );

  DialogButton getRestartButton() => DialogButton(
        child: Text(
          "Restart",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        onPressed: restartQuiz,
        color: Colors.blue,
      );

  void displayOptions() {
    List<DialogButton> buttons = [];
    if (!areQuestionsRemaining() && reviewMode == false) {
      buttons.add(getReviewButton());
    }
    buttons.add(getRestartButton());
    Alert(
      context: context,
      title: "Options",
      type: AlertType.warning,
      buttons: buttons,
    ).show();
  }

  void displayResults() {
    List<DialogButton> buttons = [];
    Icon resultIcon = Icon(
      Icons.sentiment_very_dissatisfied,
      size: 50.0,
      color: Colors.red,
    );

    String description =
        "Oops! Try again! \nRestart the quiz and give it another shot. \nYou've got this!";
    if (reviewMode == false) {
      buttons.add(getReviewButton());
    }
    buttons.add(getRestartButton());
    if (rightAnswersCounter / quizBrain.count() >= 0.7) {
      resultIcon = Icon(
        Icons.emoji_events_sharp,
        size: 50.0,
        color: Colors.amber,
      );
      ;
      description =
          "Congratulations, winner!\nYou're a quiz master!\nShare your victory and keep the knowledge flowing. \nWell done!";
    }
    Widget results = Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: resultIcon,
                ),
                Text(
                  "$rightAnswersCounter/${quizBrain.count()}",
                  style: TextStyle(
                    fontSize: 40.0,
                  ),
                ),
              ],
            ),
          ),
          Text(
            description,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
    Alert(
      context: context,
      title: "Results",
      content: results,
      buttons: buttons,
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    Color getColorDangerButton(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.red.shade900;
      }
      return Colors.red.shade500;
    }

    Color getColorSuccessButton(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.green.shade800;
      }
      return Colors.green.shade500;
    }

    final buttonTextStyle = TextStyle(
      color: Colors.white,
      fontSize: 20.0,
      fontFamily: "Poppins",
    );
    // Question Section
    List<Expanded> quizContent = [
      Expanded(
          child: Container(
              alignment: Alignment.centerRight,
              padding: EdgeInsets.only(right: 8.0),
              child: TextButton(
                onPressed: () {
                  displayOptions();
                },
                child: Icon(
                  Icons.more_vert,
                  size: 35.0,
                  weight: 16.0,
                  color: Colors.white,
                ),
              ))),
      Expanded(
        flex: 4,
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 0),
            child: Text(
              quizBrain.getQuestionText(),
              style: buttonTextStyle,
            ),
          ),
        ),
      ),
    ];

    //Buttons Section
    if (reviewMode == false) {
      quizContent.addAll(<Expanded>[
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextButton(
              onPressed: () {
                checkAnswer(true);
              },
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.resolveWith(getColorSuccessButton),
              ),
              child: Text(
                "True",
                style: buttonTextStyle,
              ),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextButton(
              onPressed: () {
                checkAnswer(false);
              },
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.resolveWith(getColorDangerButton),
              ),
              child: Text(
                "False",
                style: buttonTextStyle,
              ),
            ),
          ),
        )
      ]);
    } else {
      //When review Mode it shows the answer
      quizContent.addAll(<Expanded>[
        Expanded(
            child: Text(
          "Answer: ${quizBrain.getQuestionAnswer() == true ? "True" : "False"}",
          style: TextStyle(
              color: Colors.white,
              fontSize: 16.0,
              fontFamily: "Poppins",
              fontStyle: FontStyle.italic),
          textAlign: TextAlign.center,
        )),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {
                  previousQuestion();
                },
                child: Icon(
                  Icons.arrow_back,
                  size: 50.0,
                  color: Colors.white,
                ),
              ),
              TextButton(
                onPressed: () {
                  nextQuestion();
                },
                child: Icon(
                  Icons.arrow_forward,
                  size: 50.0,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        )
      ]);
    }

    // Scores Section
    quizContent.add(Expanded(
      flex: 1,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Scores",
              style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w700,
                  fontFamily: "Poppins",
                  color: Colors.white),
            ),
            Row(
              children: [
                Text(
                  '$rightAnswersCounter',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w900),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: Icon(
                    Icons.check,
                    color: Colors.green,
                    weight: 12.0,
                    size: 30.0,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  '$wrongAnswersCounter',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w900),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: Icon(
                    Icons.close,
                    color: Colors.redAccent,
                    weight: 12.0,
                    size: 30.0,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    ));
    return SafeArea(
      child: Container(
        color: const Color.fromRGBO(1, 48, 70, 1.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: quizContent,
        ),
      ),
    );
  }
}
