// Imports the Flutter Driver API.
import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('Demo', () {
    // First, define the Finders and use them to locate widgets from the
    // test suite. Note: the Strings provided to the `byValueKey` method must
    // be the same as the Strings we used for the Keys in step 1.





    late FlutterDriver driver;

    // Connect to the Flutter driver before running any tests.
    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    test('enters email', () async {
      var textField = find.byValueKey('email');
      await driver.tap(textField);  // acquire focus
      await driver.enterText('qa5.kaygees@gmail.com');  // enter text
      await driver.waitFor(find.text('qa5.kaygees@gmail.com'));  // verify text appears on UI
    });

    test('enters password', () async {
      var textField = find.byValueKey('password');
      await driver.tap(textField);  // acquire focus
      await driver.enterText('admin123');  // enter text
      await driver.waitFor(find.text('admin123'));  // verify text appears on UI
    });

    test('taps login', () async {
      // First, tap the button.
      var buttonFinder = find.byValueKey('increment');
      await driver.tap(buttonFinder);

    });


    test('taps a convo', () async {
      await driver.runUnsynchronized(() async {
        // First, tap the button.
        var buttonFinder = find.byValueKey('0');
        await driver.tap(buttonFinder);
      });
    });


    test('enters a message', () async {

        // First, tap the button.
        var buttonFinder = find.byValueKey('msg');
        await driver.tap(buttonFinder);  // acquire focus
        await driver.enterText('admin123');  // enter text
        await driver.waitFor(find.text('admin123'));

        buttonFinder = find.byValueKey('msgbutton');
        await driver.tap(buttonFinder);

    });

    // //Close the connection to the driver after the tests have completed.
    // tearDownAll(() async {
    //   driver.close();
    // });


  });
}