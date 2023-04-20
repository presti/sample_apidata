import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sample_apidata/res/keys.dart';

import '../../_utils/external/stub_http_service.dart';
import '../../_utils/test_utils.dart';

void main() {
  final keys = Keys.i.users;
  HttpServiceStubs stubs() => TestUtils.i.httpServiceStubs;

  Future<void> pumpWidget(
    WidgetTester tester, {
    String? usersResponse,
  }) async {
    await TestUtils.i.pumpWidget(
      tester,
      stubs: () {
        if (usersResponse != null) {
          stubs().usersResponse = usersResponse;
        }
      },
    );
    await tester.pump();
  }

  testWidgets('page is loaded with title', (tester) async {
    await pumpWidget(tester);
    keys.page.expectOne();
    keys.txTitle.expectWithText(tester, 'Users');
  });

  testWidgets('when response is empty, error is shown', (tester) async {
    await pumpWidget(tester, usersResponse: '');
    keys.page.expectOne();
    keys.txError.expectOne();
  });

  testWidgets('when response is successful, user is loaded', (tester) async {
    const userId = 4;

    // For simplicity for this sample, there is no Json builder for a
    // user, so instead we manually input a String of the full response.
    const userResponse = '''
  [
  {
    "id": $userId,
    "name": "Leanne Graham",
    "username": "Bret",
    "email": "Sincere@april.biz",
    "address": {
      "street": "Kulas Light",
      "suite": "Apt. 556",
      "city": "Gwenborough",
      "zipcode": "92998-3874",
      "geo": {
        "lat": "-37.3159",
        "lng": "81.1496"
      }
    },
    "phone": "1-770-736-8031 x56442",
    "website": "hildegard.org",
    "company": {
      "name": "Romaguera-Crona",
      "catchPhrase": "Multi-layered client-server neural-net",
      "bs": "harness real-time e-markets"
    }
  }
  ]
  ''';
    await pumpWidget(tester, usersResponse: userResponse);
    keys.txError.expectNone();
    keys.lsCards.expectOne();
    keys.lsCards.expectNWidgets<Card>(1);
    keys.wdCard(userId).expectOne();
  });
}
