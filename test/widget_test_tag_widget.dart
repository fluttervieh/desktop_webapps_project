// Flutter widget test.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:desktop_webapp/main.dart';
import 'package:desktop_webapp/mainScreen.dart';

void main() {
  testWidgets('Test whole app and expect Shopping category to exist and Streaming Category not to exist.',
      (WidgetTester tester) async {
    await tester.pumpWidget(MyApp(key: UniqueKey()));

    // Verify that Shopping is present
    expect(find.text('Shopping'), findsOneWidget);
    // Verify that Streaming is present
    expect(find.text('Streaming'), findsNothing);
  });

  testWidgets("Tag Container click and change color", (WidgetTester tester) async {
    String title = "Category1";
    List<String> selectedTags = ["Category1"];
    bool isSelected = true;

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: TagContainer(title: title, selectedTags: selectedTags, isSelected: isSelected),
      ),
    ));

    expect(find.text('Category1'), findsOneWidget);
    expect(((tester.firstWidget(find.byType(Container)) as Container).decoration as BoxDecoration).color, Colors.green);

    await tester.tap(find.text('Category1'));
    await tester.pump();

    expect(find.text('Category1'), findsOneWidget);
    expect(((tester.firstWidget(find.byType(Container)) as Container).decoration as BoxDecoration).color, Colors.grey);
  });
}
