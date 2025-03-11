import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_driver/flutter_driver.dart';
import 'package:flutter_driver/driver_extension.dart';
import 'package:test/test.dart';
import 'package:opencentric_lms/training/form_custom.dart';
import 'package:opencentric_lms/main.dart' as app;
import 'package:opencentric_lms/controller/category_controller.dart';
import 'package:opencentric_lms/training/form_validation.dart';


void main() {
  group('form', (){
    final button = find.byValueKey('route_form');
    final nameField = find.byValueKey('field_name_key');
    final emailField = find.byValueKey('field_email_key');
    final genderField = find.byValueKey('field_gender_key');
    final roleField = find.byValueKey('field_role_key');
    final iamgeField = find.byValueKey('field_image_key');

    enableFlutterDriverExtension();
    // const app.MyApp(languages: languages, bookingID: bookingID)();
    FlutterDriver? driver;
    // connect flutter driver to app before the executing run
    setUpAll(() async{
      driver = await FlutterDriver.connect();
    });
    // disconnect flutter driver to app before the executing run
    tearDownAll(() async {
      if(driver != null) {
        driver!.close();
      }
    });
    // start test 
    test('Routing to form', () async {
      await driver!.tap(button);

    });

  });


}
