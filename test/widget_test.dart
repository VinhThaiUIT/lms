import 'package:flutter_test/flutter_test.dart';
import 'package:opencentric_lms/controller/category_controller.dart';

void main() {
  test('category api test ', () async {
    // Build our app and trigger a frame.
    await CategoryController().getCategoryList();
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
