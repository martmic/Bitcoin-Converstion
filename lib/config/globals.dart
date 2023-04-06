library globals;

import 'package:http/http.dart' as http;

http.Client httpClient = http.Client();

final fakeRTPAPIData = '''
      {
        "time": {
                "updated": "Mar 31, 2023 00:03:00 UTC",
                "updatedISO": "2023-03-31T00:03:00+00:00",
                "updateduk": "Mar 31, 2023 at 01:03 GMT"
              },
        "disclaimer": "This data was produced from the CoinDesk Bitcoin Price Index (USD). Non-USD currency data converted using hourly conversion rate from openexchanges.org",
        "bpi": {
          "USD": {
            "code": "USD",
            "rate": "14,934.5833",
            "description": "United States Dollar",
            "rate_float": 14934.5833
          }
        }
      }
''';
