import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:platera_app/screens/sdui_customer_screen.dart';

class MockClient extends Mock implements http.Client {}

void main() {
  late MockClient mockClient;

  setUpAll(() {
    registerFallbackValue(Uri.parse('http://localhost:3000/api'));
  });

  setUp(() {
    mockClient = MockClient();
    clearUiSchemaCache();
  });

  Widget createTestWidget(Map<String, dynamic> schema, List<Map<String, dynamic>> data) {
    return MaterialApp(
      home: Scaffold(
        body: SduiCustomerScreen(client: mockClient),
      ),
    );
  }

  group('OrderCounter Behavior Tests', () {
    testWidgets('increments and decrements locally and triggers API', (tester) async {
      final schema = {
        'type': 'screen',
        'meta': {'cachePolicy': {'ttl': 300}},
        'appBar': {'type': 'appBar', 'title': 'Test'},
        'body': {
          'type': 'list',
          'id': 'customer_list',
          'item': {
            'type': 'orderCounter',
            'customerId': '{id}',
            'value': '{orders}',
            'label': 'Orders'
          }
        }
      };

      final initialData = {
        'data': [
          {'id': 'c1', 'name': 'John', 'orders': '5'}
        ]
      };

      // Mock specific endpoints
      when(() => mockClient.get(
        Uri.parse('http://localhost:3000/api/ui/screen/customer-list'),
        headers: any(named: 'headers'),
      )).thenAnswer((_) async => http.Response(jsonEncode(schema), 200));

      when(() => mockClient.get(
        Uri.parse('http://localhost:3000/api/customers/data'),
        headers: any(named: 'headers'),
      )).thenAnswer((_) async => http.Response(jsonEncode(initialData), 200));
      
      when(() => mockClient.post(any(), headers: any(named: 'headers'), body: any(named: 'body')))
          .thenAnswer((_) async => http.Response(jsonEncode({'success': true}), 200));

      await tester.pumpWidget(MaterialApp(home: SduiCustomerScreen(client: mockClient)));
      await tester.pumpAndSettle();

      expect(find.text('5'), findsOneWidget);

      // Tap Increment (+)
      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();

      // Local state should update immediately (optimistic)
      expect(find.text('6'), findsOneWidget);

      // Verify API call sent the correct value
      verify(() => mockClient.post(
        any(),
        headers: any(named: 'headers'),
        body: jsonEncode({'id': 'c1', 'orders': '6'}),
      )).called(1);

      // Tap Decrement (-)
      await tester.tap(find.byIcon(Icons.remove));
      await tester.pump();

      expect(find.text('5'), findsOneWidget);
    });
  });
}
