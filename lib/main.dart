import 'package:math_expressions/math_expressions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

void main() {
  runApp(const MyApp());
}

final Color colorBtnNumber = Color.fromRGBO(39, 55, 77, 1);
final Color colorDigits = Color.fromRGBO(245, 245, 245, 1);
final Color schemeColor = Color.fromRGBO(51, 70, 95, 1);

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CalculatorState(),
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

class CalculatorState extends ChangeNotifier {
  var input = "";
  var output = "";

  void calculate() {
    if (input.isEmpty) {
      return;
    }
    try {
      final Variable pi = Variable("π");
      input.replaceAll("%", "/");
      Parser p = Parser();
      ContextModel cm = ContextModel();
      cm.bindVariable(pi, Number(math.pi));
      Expression exp = p.parse(input);
      double result = exp.evaluate(EvaluationType.REAL, cm);
      output = result.toString();
      input = result.toString();
      super.notifyListeners();
    } catch (e) {
      print(e);
      return;
    }
  }

  void clear() {
    output = "";
    input = "";
    super.notifyListeners();
  }

  void add(String s) {
    input += s;
    super.notifyListeners();
  }

  void remove() {
    if (input.isEmpty) {
      return;
    }
    input = input.substring(0, input.length - 1);
    super.notifyListeners();
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});
  final String title = "Calculator";

  @override
  Widget build(BuildContext context) {
    var calculatorState = context.watch<CalculatorState>();
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
                Text(calculatorState.input,
                    style: TextStyle(fontSize: 40.0, color: colorDigits)),
                Text(
                  calculatorState.output,
                  style: TextStyle(
                      fontSize: 32.0,
                      color: colorDigits,
                      fontWeight: FontWeight.w400),
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
                  children: [
                    DelBtn(),
                    CalculatorBtn(char: "π"),
                  ],
                ),
                Row(
                  children: [
                    ClearBtn(),
                    CalculatorBtn(char: "!"),
                    CalculatorBtn(char: "^"),
                    CalculatorBtn(char: "%")
                  ],
                ),
                Row(
                  children: [
                    CalculatorBtn(char: "7"),
                    CalculatorBtn(char: "8"),
                    CalculatorBtn(char: "9"),
                    CalculatorBtn(char: "/")
                  ],
                ),
                Row(
                  children: [
                    CalculatorBtn(char: "4"),
                    CalculatorBtn(char: "5"),
                    CalculatorBtn(char: "6"),
                    CalculatorBtn(char: "*"),
                  ],
                ),
                Row(
                  children: [
                    CalculatorBtn(char: "1"),
                    CalculatorBtn(char: "2"),
                    CalculatorBtn(char: "3"),
                    CalculatorBtn(char: "+")
                  ],
                ),
                Row(
                  children: [
                    CalculatorBtn(char: "0"),
                    CalculatorBtn(char: "."),
                    EqualBtn(),
                    CalculatorBtn(char: "-")
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

class CalculatorBtn extends StatelessWidget {
  final String char;
  CalculatorBtn({super.key, required this.char});
  @override
  Widget build(BuildContext context) {
    var calcState = context.watch<CalculatorState>();
    return Expanded(
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: colorBtnNumber),
            onPressed: () => calcState.add(char),
            child: Text(char,
                style: TextStyle(fontSize: 40.0, color: colorDigits))));
  }
}

class EqualBtn extends StatelessWidget {
  final String equal = "=";
  EqualBtn({super.key});
  @override
  Widget build(BuildContext context) {
    var calcState = context.watch<CalculatorState>();
    return Expanded(
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: colorBtnNumber),
            onPressed: () => calcState.calculate(),
            child: Text(equal,
                style: TextStyle(fontSize: 34.0, color: colorDigits))));
  }
}

class ClearBtn extends StatelessWidget {
  final String ac = "AC";
  ClearBtn({super.key});
  @override
  Widget build(BuildContext context) {
    var calcState = context.watch<CalculatorState>();
    return Expanded(
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: colorBtnNumber),
            onPressed: () => calcState.clear(),
            child: Text(ac,
                style: TextStyle(fontSize: 34.0, color: colorDigits))));
  }
}

class DelBtn extends StatelessWidget {
  final String ac = "DEL";
  DelBtn({super.key});
  @override
  Widget build(BuildContext context) {
    var calcState = context.watch<CalculatorState>();
    return Expanded(
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: colorBtnNumber),
            onPressed: () => calcState.remove(),
            child: Text(ac,
                style: TextStyle(fontSize: 34.0, color: colorDigits))));
  }
}
