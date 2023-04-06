import 'package:bitcoin_calculator/utils/conversion_tools.dart';

class Calculator {
  String _choice = "";
  String _result = "";
  double _usd = 0;
  double _btc = 0;

  //Constructor starts off with default values
  Calculator(String choice) {
    _choice = choice;
    _result = "";
    _usd = 0;
    _btc = 0;
  }

  String choice() {
    return _choice;
  }

  String result() {
    return _result;
  }

  double usd() {
    return _usd;
  }

  double btc() {
    return _btc;
  }

  void calculate(String input, num rtp) {
    var amount = double.parse(input);
    if (choice() == "USD to BTC") {
      _result = "Converted to BTC";
      _btc = ConversionTools.usdToBTC(amount, rtp);
    } else {
      _result = "Converted to USD";
      _usd = ConversionTools.btcToUSD(amount, rtp);
    }
  }
}
