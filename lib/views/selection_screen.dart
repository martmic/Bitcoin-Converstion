import 'package:flutter/material.dart';
import 'calculation_screen.dart';
import 'package:bitcoin_calculator/models/calculator.dart';

class SelectionScreen extends StatefulWidget {
  @override
  _SelectionScreenState createState() => _SelectionScreenState();
}

class _SelectionScreenState extends State<SelectionScreen> {
  String _choice;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Container(
          child: Text(
        "Please Click Your Choice",
        key: Key("choice-text"),
        style: TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.w500,
          height: 1.5,
          color: Color(0xFF4C748B),
        ),
      )),
      SizedBox(height: 30),
      Container(
          alignment: Alignment.center,
          child: ElevatedButton(
              key: Key('usd-to-btc'),
              onPressed: () {
                setState(() {
                  _choice = "USD to BTC";
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              CalculationScreen(Calculator(_choice))));
                });
              },
              child: Text(
                "USD to BTC",
              ),
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Color(0xFF4C748B)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25)),
                  )))),
      SizedBox(
        height: 30,
      ),
      Container(
          alignment: Alignment.center,
          child: ElevatedButton(
              key: Key('btc-to-usd'),
              onPressed: () {
                setState(() {
                  _choice = "BTC to USD";
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              CalculationScreen(Calculator(_choice))));
                });
              },
              child: Text(
                "BTC to USD",
              ),
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Color(0xFF4C748B)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25)),
                  )))),
    ]));
  }
}
