import 'package:elaichi/ui/widgets/appbar.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../setup/test_helpers.dart';

void main() {
  testWidgets(
    'Appbar is rendered with correct title',
    (WidgetTester tester) async {
      const title = 'Test Title';
      await tester.pumpWidget(wrappedWidget(const ElaichiAppbar(
        title: title,
        centerTitle: true,
        appbarHeight: 80,
      )));
      expect(find.text(title), findsOneWidget);
    },
  );
}
