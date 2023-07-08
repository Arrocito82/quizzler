import 'package:flutter/material.dart';

void main() {
  runApp(const QuizzlerApp());
}

class QuizzlerApp extends StatelessWidget {
  const QuizzlerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          appBar: AppBar(
            title: Text(
              "Quizzler",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontFamily: "Poppings",
                fontSize: 30.0,
              ),
            ),
            titleSpacing: 8.0,
            leading: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: ImageIcon(AssetImage("images/quizzler-logo.png")),
            ),
            toolbarHeight: 60.0,
            leadingWidth: 40.0,
            flexibleSpace: Container(
              decoration: BoxDecoration(
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
          body: QuizzlerPage()),
    );
  }
}

class QuizzlerPage extends StatefulWidget {
  const QuizzlerPage({super.key});

  @override
  State<QuizzlerPage> createState() => _QuizzlerPageState();
}

class _QuizzlerPageState extends State<QuizzlerPage> {
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
        color: Color.fromRGBO(1, 48, 70, 1.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 4,
              child: Center(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24.0, vertical: 0),
                  child: Text(
                    "This is where the question text will go.",
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
                  onPressed: () {},
                  child: Text(
                    "True",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontFamily: "Poppings",
                    ),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith(
                        getColorSuccessButton),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    "False",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontFamily: "Poppings",
                    ),
                  ),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.resolveWith(getColorDangerButton),
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
