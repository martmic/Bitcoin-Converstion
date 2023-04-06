import 'package:bitcoin_calculator/config/globals.dart';
import 'package:bitcoin_calculator/utils/conversion_tools.dart';
import 'package:flutter/material.dart';
import 'package:bitcoin_calculator/models/calculator.dart';
import 'package:flutter/services.dart';

class CalculationScreen extends StatefulWidget {
  final Calculator calculator;
  CalculationScreen(this.calculator);
  _CalculationScreenState createState() => _CalculationScreenState();
}

class _CalculationScreenState extends State<CalculationScreen> {
  TextEditingController inputController;
  Future<num> futureRTP;
  // ignore: non_constant_identifier_names
  num RTP = 0; //real time price

  bool isButtonActive = false;
  bool clicked = false;
  double value = 0;
  String currency = "";

  @override
  void initState() {
    super.initState();
    //Real time price
    futureRTP = ConversionTools.fetchRealTimePrice(httpClient);

    //input controller
    inputController = TextEditingController();
    inputController.addListener(() {
      clicked = false;
      if (inputController.text == "" ||
          !RegExp(r'^[1-9]\d*(\.\d+)?$').hasMatch(inputController.text)) {
        isButtonActive = false;
      } else if (RegExp(r'^[1-9]\d*(\.\d+)?$').hasMatch(inputController.text)) {
        isButtonActive = true;
      }
      setState(() => this.isButtonActive = isButtonActive);
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Color(0xFF4C748B),
              key: Key('back-button'),
            ),
            iconSize: 15,
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          //DISPLAY VALUE OF BITCOIN
          FutureBuilder<num>(
            future: futureRTP,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                RTP = snapshot.data;
                return Text(
                  "Calculation rate: 1 BTC = ${RTP.toString()} USD",
                  key: Key("rtp-text"),
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500,
                    height: 1.5,
                    color: Color(0xFF4C748B),
                  ),
                );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              return CircularProgressIndicator();
            },
          ),

          //RESULT TEXT
          Container(
              child: Text(
            (clicked ? "Converted value: ${value.toString()} " + currency : ""),
            key: Key("result"),
            style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w400,
                color: Colors.green),
          )),
          //Spacing
          SizedBox(height: 15),
          Container(
            width: 325,
            height: 40,
            decoration: BoxDecoration(
              border: Border.all(color: Color(0xFF4C748B), width: 2),
              color: Color(0xFFF3F3F3),
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 5,
                        height: 5,
                      ),
                      Container(
                        height: 20,
                        width: 280,
                        child: TextField(
                          key: Key('input'),
                          keyboardType: TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          decoration: new InputDecoration.collapsed(
                              hintText: "Enter Value"),
                          controller: inputController,
                          onEditingComplete: () {
                            setState(() {});
                            FocusScope.of(context).unfocus();
                          },
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w500,
                            height: 1.5,
                            color: Color(0xFF4C748B),
                          ),
                        ),
                      ),
                      Expanded(
                        // padding: const EdgeInsets.all(1),
                        child: Text(
                          this.widget.calculator.choice() == "BTC to USD"
                              ? "BTC"
                              : "USD",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w500,
                            height: 1.5,
                            color: Color(0xFF4C748B),
                          ),
                        ),
                      ),
                    ],
                  ),
                ]),
          ),

          Container(
              padding: EdgeInsets.only(left: 18),
              alignment: Alignment.bottomLeft,
              child: Text(
                (isButtonActive ? "" : "Please enter a valid input"),
                key: Key("error-text"),
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400,
                    color: Colors.red),
              )),
          SizedBox(height: 17),
          Container(
              width: 140,
              height: 46,
              child: ElevatedButton(
                key: Key('convert-button'),
                onPressed: isButtonActive
                    ? () {
                        setState(() {
                          this
                              .widget
                              .calculator
                              .calculate(inputController.text, RTP);
                          this.widget.calculator.choice() == "BTC to USD"
                              ? value = this.widget.calculator.usd()
                              : value = this.widget.calculator.btc();
                          this.widget.calculator.choice() == "BTC to USD"
                              ? currency = "USD"
                              : currency = "BTC";

                          clicked = true;
                        });
                      }
                    : null,
                child: Text(
                  "Convert",
                  style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w400,
                      color: isButtonActive
                          ? Color(0xffffffff)
                          : Color(0xff757474)),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      isButtonActive ? Color(0xFF4C748B) : Color(0xffE2E2E2)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25)),
                  ),
                ),
              )),
        ]));
  }
}
