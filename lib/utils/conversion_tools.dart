import 'package:http/http.dart' as http;
import 'dart:convert';

class ConversionTools {
  //Fetch the real time price of bitcoin
  static Future<num> fetchRealTimePrice(http.Client client) async {
    var url =
        Uri.parse('https://api.coindesk.com/v1/bpi/currentprice/usd.json');
    final response = await client.get(url);

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = jsonDecode(response.body);
      return jsonData["bpi"]["USD"]["rate_float"];
    } else {
      throw Exception('Failed to load real time price');
    }
  }

  //Converts usd to btc, rtp = real time price
  static double usdToBTC(double usd, num rtp) {
    return usd / rtp;
  }

  //Convert btc to usd
  static double btcToUSD(double btc, num rtp) {
    return btc * rtp;
  }
}
