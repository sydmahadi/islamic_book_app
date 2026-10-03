import 'package:flutter_test/flutter_test.dart';

import 'package:islamic_book_app/main.dart';

void main() {
  testWidgets('Islamic Book App loads', (WidgetTester tester) async {
    await tester.pumpWidget(const IslamicBookApp());

    expect(find.text('ইসলামিক বই'), findsOneWidget);
  });
}
