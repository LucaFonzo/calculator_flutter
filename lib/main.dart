import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

final Color colorBtnNumber = Color.fromRGBO(39, 55, 77, 1);
final Color colorDigits = Color.fromRGBO(221, 230, 237, 1);
final Color schemeColor = Color.fromRGBO(51, 70, 95, 1);

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Calculator',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: schemeColor),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var output = "";
  var currentNumber = "";
  var operator = "";
  var result = 0.0;
  var resultView = 0;

  void onClearPressed() {
    output = "";
    currentNumber = "";
    operator = "";
    result = 0;
    super.notifyListeners();
  }

  void onNumberPressed(String number) {
    if (currentNumber.isEmpty) {
      currentNumber = number;
    } else {
      currentNumber += number;
    }
    output += number;
    super.notifyListeners();
  }

  void onOperatorPressed(String op) {
    if (currentNumber.isEmpty) {
      return;
    }
    operator = op;
    result = double.parse(currentNumber);
    currentNumber = "";
    output += operator;
    super.notifyListeners();
  }

  void onResultPressed() {
    if (operator == "+") {
      result += double.parse(currentNumber);
    } else if (operator == "-") {
      result -= double.parse(currentNumber);
    } else if (operator == "/") {
      result /= double.parse(currentNumber);
    } else if (operator == "x") {
      result *= double.parse(currentNumber);
    }
    super.notifyListeners();
    output = result.toString();
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});
  final String title = "Calculator";

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    return Scaffold(
      backgroundColor: schemeColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
      ),
      body: Column(
        children: [
          Container(
            alignment: Alignment.centerRight,
            padding: EdgeInsets.symmetric(vertical: 24.0, horizontal: 12.0),
            child: Column(
              children: [
                Text(appState.output,
                    style: TextStyle(
                      fontSize: 40.0,
                    )),
                Text(
                  appState.result.toString(),
                  style: TextStyle(fontSize: 40.0, fontWeight: FontWeight.w400),
                )
              ],
            ),
          ),
          Expanded(child: Divider()),
          Container(
            padding: EdgeInsets.only(bottom: 20),
            child: Column(
              children: [
                Row(
                  children: [ClearBtn()],
                ),
                Row(
                  children: [
                    NubmerBtn(number: "7"),
                    NubmerBtn(number: "8"),
                    NubmerBtn(number: "9"),
                    OperatorBtn(operator: "/")
                  ],
                ),
                Row(
                  children: [
                    NubmerBtn(number: "4"),
                    NubmerBtn(number: "5"),
                    NubmerBtn(number: "6"),
                    OperatorBtn(operator: "x"),
                  ],
                ),
                Row(
                  children: [
                    NubmerBtn(number: "1"),
                    NubmerBtn(number: "2"),
                    NubmerBtn(number: "3"),
                    OperatorBtn(operator: "+")
                  ],
                ),
                Row(
                  children: [
                    NubmerBtn(number: "0"),
                    NubmerBtn(number: "."),
                    EqualBtn(),
                    OperatorBtn(operator: "-")
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class NubmerBtn extends StatelessWidget {
  final String number;
  NubmerBtn({super.key, required this.number});
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    return Expanded(
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: colorBtnNumber),
            onPressed: () => appState.onNumberPressed(number),
            child: Text(number,
                style: TextStyle(fontSize: 40.0, color: colorDigits))));
  }
}

class OperatorBtn extends StatelessWidget {
  final String operator;
  const OperatorBtn({super.key, required this.operator});
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    return Expanded(
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: colorBtnNumber),
            onPressed: () => appState.onOperatorPressed(operator),
            child: Text(operator,
                style: TextStyle(fontSize: 40.0, color: colorDigits))));
  }
}

class ClearBtn extends StatelessWidget {
  final clear = 'AC';
  const ClearBtn({super.key});
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    return Expanded(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: colorBtnNumber),
        onPressed: () => appState.onClearPressed(),
        child: Text(
          clear,
          style: TextStyle(fontSize: 40.0, color: colorDigits),
        ),
      ),
    );
  }
}

class EqualBtn extends StatelessWidget {
  final equal = '=';
  const EqualBtn({super.key});
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    return Expanded(
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: colorBtnNumber),
          onPressed: () => appState.onResultPressed(),
          child: Text(equal,
              style: TextStyle(fontSize: 40.0, color: colorDigits))),
    );
  }
}
