// Imports the Flutter Driver API.
import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  FlutterDriver driver;
  setUpAll(() async {
    driver = await FlutterDriver.connect();
  });

  tearDownAll(() async {
    if (driver != null) {
      driver.close();
    }
  });

  group('Happy Paths', () {
    /*
      Given I am on the Conversion Selection Screen
      When I tap "USD to BTC"
      And I enter "14,934.5833"
      And I tap "Convert"
      Then I should see "1.0 BTC"
    */

    test("should convert USD value to BTC", () async {
      final choiceText = find.byValueKey("choice-text");
      final usdToBtc = find.byValueKey('usd-to-btc');
      final input = find.byValueKey("input");
      final convertButton = find.byValueKey("convert-button");
      final resultFinder = find.byValueKey("result");
      final backButtonFinder = find.byValueKey("back-button");

      expect(await driver.getText(choiceText), "Please Click Your Choice");
      await driver.tap(usdToBtc);
      await driver.tap(input);
      await driver.enterText("14934.5833");
      await driver.tap(convertButton);
      expect(await driver.getText(resultFinder), "Converted value: 1.0 BTC");

      //testing back button
      await driver.tap(backButtonFinder);
      expect(await driver.getText(choiceText), "Please Click Your Choice");
    });

    /*
      Given I am on the Conversion Selection Screen
      When I tap "BTC to USD"
      And I enter "1"
      And I tap "Convert"
      Then I should see "14,934.5833 USD"
    */
    test("should convert BTC value to USD", () async {
      final choiceText = find.byValueKey("choice-text");
      final btcToUsd = find.byValueKey('btc-to-usd');
      final input = find.byValueKey("input");
      final convertButton = find.byValueKey("convert-button");
      final resultFinder = find.byValueKey("result");
      final backButtonFinder = find.byValueKey("back-button");

      expect(await driver.getText(choiceText), "Please Click Your Choice");
      await driver.tap(btcToUsd);
      await driver.tap(input);
      await driver.enterText("1");
      await driver.tap(convertButton);
      expect(await driver.getText(resultFinder),
          "Converted value: 14934.5833 USD");
      await driver.tap(backButtonFinder);
    });
  });

  group('Sad Paths', () {
    /*
      Given I am on the Conversion Selection Screen
      When I tap "USD to BTC"
      And I enter "27101.8."
      Then I should see "Please enter a valid input"
    */
    test("should flash an error message with an invalid input for USD to BTC",
        () async {
      final usdToBtc = find.byValueKey('usd-to-btc');
      final input = find.byValueKey("input");
      final errorTextFinder = find.byValueKey("error-text");

      await driver.tap(usdToBtc);
      await driver.tap(input);
      await driver.enterText("27101.8.");
      expect(
          await driver.getText(errorTextFinder), 'Please enter a valid input');

      //return to selection screen
    });
    /*
      Given I chose "USD to BTC" on the Selection Screen
      And I enter "-1"
      Then I should not see the result text
    */

    test("should not show result with an invalid input for USD to BTC",
        () async {
      final input = find.byValueKey("input");
      final resultFinder = find.byValueKey("result");
      final backButtonFinder = find.byValueKey("back-button");
      final choiceText = find.byValueKey("choice-text");

      await driver.tap(input);
      await driver.enterText("-1");
      expect(await driver.getText(resultFinder), '');

      //testing back button
      await driver.tap(backButtonFinder);
      expect(await driver.getText(choiceText), "Please Click Your Choice");
    });

    /*
      Given I am on the Conversion Selection Screen
      When I tap "BTC to USD"
      And I enter "1.0."
      Then I should see "Please enter a valid input"
    */

    test("should flash an error message with an invalid input for BTC to USD",
        () async {
      final btcToUsd = find.byValueKey('btc-to-usd');
      final input = find.byValueKey("input");
      final errorTextFinder = find.byValueKey("error-text");

      await driver.tap(btcToUsd);
      await driver.tap(input);
      await driver.enterText("1.0.");
      expect(
          await driver.getText(errorTextFinder), 'Please enter a valid input');
    });

    /*
      Given I chose "BTC to USD" on the Selection Screen
      And I enter "-1"
      Then I should not see the result text
    */

    test("should not show result with an invalid input", () async {
      final input = find.byValueKey("input");
      final resultFinder = find.byValueKey("result");

      await driver.tap(input);
      await driver.enterText("-1");
      expect(await driver.getText(resultFinder), '');
    });
  });
}
