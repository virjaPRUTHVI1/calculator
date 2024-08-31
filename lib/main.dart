import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: BasicCalculator(),
    debugShowCheckedModeBanner: false,
  ));
}

class BasicCalculator extends StatefulWidget {
  @override
  State<BasicCalculator> createState() => _BasicCalculatorState();
}

class _BasicCalculatorState extends State<BasicCalculator> {
  String display = '';
  double result = 0;
  String operand = '';

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double buttonHeight = size.height * 0.1;
    double buttonFontSize = size.width * 0.08;
    double displayFontSize = size.width * 0.12;
///this is just for checking push into github.....
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CalcyUI(
            display: display,
            fontSize: displayFontSize,
          ),
          Expanded(
            child: GridView(
              padding: EdgeInsets.all(10),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                mainAxisExtent: buttonHeight,
              ),
              children: buttons.map((button) {
                return CalculatorButton(
                  button: button,
                  onPressed: () {
                    handleButtonPressed(button);
                  },
                  fontSize: buttonFontSize,
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  List<ButtonModel> buttons = [
    ButtonModel(value: 'AC', buttonType: ButtonType.allClear),
    ButtonModel(value: 'C', buttonType: ButtonType.clear),
    ButtonModel(value: '%', buttonType: ButtonType.operator),
    ButtonModel(value: '/', buttonType: ButtonType.operator),
    ButtonModel(value: '7', buttonType: ButtonType.digit),
    ButtonModel(value: '8', buttonType: ButtonType.digit),
    ButtonModel(value: '9', buttonType: ButtonType.digit),
    ButtonModel(value: '*', buttonType: ButtonType.operator),
    ButtonModel(value: '4', buttonType: ButtonType.digit),
    ButtonModel(value: '5', buttonType: ButtonType.digit),
    ButtonModel(value: '6', buttonType: ButtonType.digit),
    ButtonModel(value: '-', buttonType: ButtonType.operator),
    ButtonModel(value: '1', buttonType: ButtonType.digit),
    ButtonModel(value: '2', buttonType: ButtonType.digit),
    ButtonModel(value: '3', buttonType: ButtonType.digit),
    ButtonModel(value: '+', buttonType: ButtonType.operator),
    ButtonModel(value: '0', buttonType: ButtonType.digit),
    ButtonModel(value: '.', buttonType: ButtonType.digit),
    ButtonModel(value: '=', buttonType: ButtonType.equal),
  ];

  void handleButtonPressed(ButtonModel button) {
    setState(() {
      if (button.buttonType == ButtonType.digit) {
        display += button.value;
      } else if (button.buttonType == ButtonType.operator) {
        if (display.isNotEmpty) {
          operand = button.value;
          result = double.parse(display);
          display = '';
        }
      } else if (button.buttonType == ButtonType.clear) {
        display = '';
      } else if (button.buttonType == ButtonType.allClear) {
        display = '';
        result = 0;
        operand = '';
      } else if (button.buttonType == ButtonType.equal) {
        if (display.isNotEmpty && operand.isNotEmpty) {
          double parsedDisplay = double.parse(display);
          switch (operand) {
            case '+':
              result += parsedDisplay;
              break;
            case '-':
              result -= parsedDisplay;
              break;
            case '*':
              result *= parsedDisplay;
              break;
            case '/':
              if (parsedDisplay != 0) {
                result /= parsedDisplay;
              } else {
                display = 'Error';
                return;
              }
              break;
            case '%':
              result %= parsedDisplay;
              break;
          }
          display = result.toString();
          operand = '';
        }
      }
    });
  }
}

class CalcyUI extends StatelessWidget {
  const CalcyUI({required this.display, required this.fontSize});

  final String display;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: double.infinity,
      color: Colors.black,
      alignment: Alignment.bottomRight,
      padding: EdgeInsets.all(16),
      child: Text(
        display,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: fontSize,
          color: Colors.white,
        ),
      ),
    );
  }
}

class CalculatorButton extends StatelessWidget {
  const CalculatorButton({
    required this.button,
    required this.onPressed,
    required this.fontSize,
  });

  final ButtonModel button;
  final void Function() onPressed;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color textColor = Colors.white;
    switch (button.buttonType) {
      case ButtonType.equal:
        bgColor = Colors.orange;
        break;
      case ButtonType.clear:
      case ButtonType.allClear:
        bgColor = Colors.red;
        break;
      case ButtonType.operator:
        bgColor = Colors.blueAccent;
        break;
      case ButtonType.digit:
      default:
        bgColor = Colors.grey[800]!;
        break;
    }

    return InkWell(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(10),
        ),
        alignment: Alignment.center,
        child: Text(
          button.value,
          style: TextStyle(
            fontSize: fontSize,
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

enum ButtonType { equal, clear, allClear, operator, digit }

class ButtonModel {
  String value;
  ButtonType buttonType;

  ButtonModel({required this.value, required this.buttonType});
}
