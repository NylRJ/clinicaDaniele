// Basic smoke test for the root widget.
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:plataforma_daniela/main.dart";

void main() {
  testWidgets('App renders MaterialApp', (tester) async {
    await tester.pumpWidget(const App());
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}