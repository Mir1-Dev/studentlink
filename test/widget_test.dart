import 'package:flutter_test/flutter_test.dart';

import 'package:studentlink/main.dart';

void main() {
  testWidgets('opens the home screen from splash', (tester) async {
    await tester.pumpWidget(const StudentLinkApp());

    expect(find.text('Get Started'), findsOneWidget);
    await tester.tap(find.text('Get Started'));
    await tester.pumpAndSettle();

    expect(find.text('Good morning,'), findsOneWidget);
    expect(find.text('Upcoming tasks'), findsOneWidget);
  });
}
