import 'package:flutter_driver/driver_extension.dart';
import 'package:bitcoin_calculator/main.dart' as app;
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:bitcoin_calculator/config/globals.dart' as globals;

class MockClient extends Mock implements http.Client {}

void main() {
  // This line enables the extension.
  enableFlutterDriverExtension();

  //Set up mock client, fakeRTPAPIData defined in config/globals.dart
  final MockClient client = MockClient();
  var url = Uri.parse('https://api.coindesk.com/v1/bpi/currentprice/usd.json');

  when(client.get(url))
      .thenAnswer((_) async => http.Response(globals.fakeRTPAPIData, 200));

  globals.httpClient = client;

  // Call the `main()` function of the app, or call `runApp` with
  // any widget you are interested in testing.
  app.main();
}
