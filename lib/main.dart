import 'package:flutter/material.dart';
import 'package:quizzler/quiz_brain.dart';

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
  List<bool> userAnswers = [];

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

    return SafeArea(
      child: Container(
        color: const Color.fromRGBO(1, 48, 70, 1.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 4,
              child: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 0),
                  child: Text(
                    quizBrain.getQuestionText(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25.0,
                      fontFamily: "Poppings",
                    ),
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
                    setState(() {
                      userAnswers.add(true);
                      quizBrain.nextQuestion();
                    });
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith(
                        getColorSuccessButton),
                  ),
                  child: const Text(
                    "True",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontFamily: "Poppins",
                    ),
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
                    setState(() {
                      userAnswers.add(false);
                      quizBrain.nextQuestion();
                    });
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.resolveWith(getColorDangerButton),
                  ),
                  child: const Text(
                    "False",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontFamily: "Poppins",
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
