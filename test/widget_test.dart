import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:make_my_ride/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: BookMyRideApp()),
    );
    expect(find.byType(MaterialApp), findsNothing); // uses MaterialApp.router
    expect(find.byType(Router<Object>), findsOneWidget);
  });
}
