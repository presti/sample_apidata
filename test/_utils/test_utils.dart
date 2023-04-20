import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sample_apidata/external/service_locator.dart';
import 'package:sample_apidata/main.dart';

import 'external/stub_http_service.dart';
import 'external/test_service_locator.dart';

class TestUtils {
  TestUtils._();

  static final TestUtils i = TestUtils._();

  HttpServiceStubs get httpServiceStubs =>
      (sl().httpService as StubHttpService).stubs;

  Future<void> pumpWidget(
    WidgetTester tester, {
    void Function()? stubs,
  }) async {
    ServiceLocator.i = TestServiceLocator();
    stubs?.call();
    main();
    await tester.pump();
  }

  T widgetOfFinder<T extends Widget>(
    WidgetTester tester,
    Finder finder, {
    bool getFirst = false,
  }) {
    final descendant = find.descendant(
      of: finder,
      matching: find.byType(T),
      matchRoot: true,
    );
    return tester.widget(getFirst ? descendant.first : descendant);
  }
}

extension ComponentWidget on Key {
  Finder get finder => find.byKey(this);

  void expectOne() => expect(finder, findsOneWidget);

  void expectNone() => expect(finder, findsNothing);

  void expectWithText(WidgetTester tester, String text) {
    tester.expectText(this, text);
  }

  void expectNWidgets<T>(int n) {
    final finder = find.descendant(of: this.finder, matching: find.byType(T));
    expect(finder, findsNWidgets(n));
  }

  T widget<T extends Widget>(WidgetTester tester) {
    return TestUtils.i.widgetOfFinder(tester, finder);
  }
}

extension ComponentTest on WidgetTester {
  void expectText(Key key, String expected) {
    _expectText(
      expected,
      getTextWidget: () => key.widget(this),
      getFinder: () => find.byKey(key),
    );
  }

  void _expectText(
    String expected, {
    required Text Function() getTextWidget,
    required Finder Function() getFinder,
  }) {
    try {
      expect(getTextWidget().data, expected);
    } on StateError {
      // If we have too many elements, we find by text.
      final textFinder = find.descendant(
        of: getFinder(),
        matching: find.byType(Text),
        matchRoot: true,
      );
      final finder = find.descendant(
        of: textFinder,
        matching: find.text(expected),
        matchRoot: true,
      );
      final strings = widgetList<Text>(textFinder).map((e) => '"${e.data}"');
      final failReason = 'Not found exactly one match of: "$expected". '
          'Texts found: ${strings.toList()}';
      expect(finder, findsOneWidget, reason: failReason);
    }
  }
}
