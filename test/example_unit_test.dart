import 'package:bitcoin_calculator/models/calculator.dart';
import 'package:bitcoin_calculator/utils/conversion_tools.dart';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:bitcoin_calculator/config/globals.dart';

//Create new instances of mock in every test
class MockClient extends Mock implements http.Client {}

//final fakeRTPAPIData definition can be found in config/globals.dart

void main() {
  group('fetchRealTimePrice', () {
    test('returns a num if the http call completes successfully', () async {
      final client = MockClient();

      var url =
          Uri.parse('https://api.coindesk.com/v1/bpi/currentprice/usd.json');
      // Use Mockito to return a successful response when it calls the
      // provided http.Client.

      when(client.get(url))
          .thenAnswer((_) async => http.Response(fakeRTPAPIData, 200));

      //the extracted data from JSON
      num rtp = await ConversionTools.fetchRealTimePrice(client);

      //we extract a num so we expect a num
      expect(rtp, isA<num>());

      //does the extracted value match our fake data?
      expect(rtp, 14934.5833);
    });

    test('throws an exception if the http call completes with an error', () {
      final client = MockClient();

      // Use Mockito to return an unsuccessful response when it calls the provided http.Client.
      var url =
          Uri.parse('https://api.coindesk.com/v1/bpi/currentprice/usd.json');
      when(client.get(url))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      expect(ConversionTools.fetchRealTimePrice(client), throwsException);
    });
  });
  group("usdToBTC", () {
    test('calculates 14934.5833 usd as 1 btc', () async {
      final client = MockClient();
      var url =
          Uri.parse('https://api.coindesk.com/v1/bpi/currentprice/usd.json');

      // Use Mockito to return an unsuccessful response when it calls the provided http.Client.
      when(client.get(url))
          .thenAnswer((_) async => http.Response(fakeRTPAPIData, 200));
      //the extracted data from JSON
      num rtp = await ConversionTools.fetchRealTimePrice(client);

      // test our converted value
      var btc = ConversionTools.usdToBTC(14934.5833, rtp);
      expect(btc, 1);
    });
  });

  group("btcToUSD", () {
    test('calculates 1 btc as 14934.5833 usd', () async {
      final client = MockClient();
      var url =
          Uri.parse('https://api.coindesk.com/v1/bpi/currentprice/usd.json');

      // Use Mockito to return an unsuccessful response when it calls the provided http.Client.
      when(client.get(url))
          .thenAnswer((_) async => http.Response(fakeRTPAPIData, 200));
      //the extracted data from JSON
      num rtp = await ConversionTools.fetchRealTimePrice(client);

      // test our converted value
      var usd = ConversionTools.btcToUSD(1, rtp);
      expect(usd, 14934.5833);
    });
  });

  group('Test Calculator Constructor', () {
    test('Function choice() should return the word given to constructor', () {
      //make a variable that we will use to pass to the constructor as our choice
      String choice = 'USD to BTC';
      //pass choice to calculator constructor and create object called calc
      final calc = Calculator(choice);
      //expect that the calculator objects choice matches the originally passed choice
      expect(calc.choice(), choice);
    });

    test('Function result() should return empty string initially', () {
      //make a variable that we will use to pass to the constructor as our choice
      String choice = 'USD to BTC';
      //pass choice to calculator constructor and create object called calc
      final calc = Calculator(choice);
      //expect that the calculator objects choice matches the originally passed choice
      expect(calc.result(), isEmpty);
    });

    test('Function usd() should be zero initially', () {
      //make a variable that we will use to pass to the constructor as our choice
      String choice = 'USD to BTC';
      //pass choice to calculator constructor and create object called calc
      final calc = Calculator(choice);
      //expect that the calculator objects choice matches the originally passed choice
      expect(calc.usd(), 0);
    });

    test('Function btc() should be zero initially', () {
      //make a variable that we will use to pass to the constructor as our choice
      String choice = 'USD to BTC';
      //pass choice to calculator constructor and create object called calc
      final calc = Calculator(choice);
      //expect that the calculator objects choice matches the originally passed choice
      expect(calc.btc(), 0);
    });
  });

  group('Test Conversion Calculations', () {
    test(
        'An input of 14934.5833 USD on a USD to BTC conversion will result in 1.0 BTC',
        () async {
      final client = MockClient();
      var url =
          Uri.parse('https://api.coindesk.com/v1/bpi/currentprice/usd.json');

      // Use Mockito to return an unsuccessful response when it calls the provided http.Client.
      when(client.get(url))
          .thenAnswer((_) async => http.Response(fakeRTPAPIData, 200));
      //the extracted data from JSON
      num rtp = await ConversionTools.fetchRealTimePrice(client);

      //make a variable that we will use to pass to the constructor as our choice
      String choice = 'USD to BTC';
      //pass choice to calculator constructor and create object called calc
      final calc = Calculator(choice);
      calc.calculate("14934.5833", rtp);
      //expect that the hangmanGame objects word matches the originally passed word
      expect(calc.btc(), 1);
    });

    test(
        'An input of 1 BTC on a BTC to USD conversion will result in 14934.5833 USD',
        () async {
      final client = MockClient();
      var url =
          Uri.parse('https://api.coindesk.com/v1/bpi/currentprice/usd.json');

      // Use Mockito to return an unsuccessful response when it calls the provided http.Client.
      when(client.get(url))
          .thenAnswer((_) async => http.Response(fakeRTPAPIData, 200));
      //the extracted data from JSON
      num rtp = await ConversionTools.fetchRealTimePrice(client);

      //make a variable that we will use to pass to the constructor as our choice
      String choice = 'BTC to USD';
      //pass choice to calculator constructor and create object called calc
      final calc = Calculator(choice);
      calc.calculate("1", rtp);
      //expect that the hangmanGame objects word matches the originally passed word
      expect(calc.usd(), 14934.5833);
    });
    // No need to test for negative or decimal numbers. RegEx expression forces the user to input an integer.
  });
}
