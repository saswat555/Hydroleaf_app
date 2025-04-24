// test/widget_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:hydroleaf_app/src/app.dart';
import 'package:hydroleaf_app/src/providers/auth_provider.dart';
import 'package:hydroleaf_app/src/providers/farm_provider.dart';
import 'package:hydroleaf_app/src/services/api_service.dart';
import 'package:hydroleaf_app/src/ui/widgets/primary_button.dart';

/// A fake ApiService that only needs to satisfy AuthProvider.login.
class MockApiService extends ApiService {
  MockApiService() : super(baseUrl: '');
  @override
  Future<String> login(String email, String password) async {
    // simulate an API call
    return 'fake-token';
  }
}

void main() {
  /// Wrap the HydroleafApp in the exact same providers as `main.dart`.
  Widget makeTestable(Widget child, ApiService api) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => AuthProvider(apiService: api),
        ),
        ChangeNotifierProxyProvider<AuthProvider, FarmProvider>(
          create: (_) => FarmProvider(apiService: api, token: ''),
          update: (_, auth, __) =>
              FarmProvider(apiService: api, token: auth.token ?? ''),
        ),
      ],
      child: child,
    );
  }

  testWidgets('LoginScreen renders correctly', (WidgetTester tester) async {
    final mockApi = MockApiService();

    await tester.pumpWidget(
      makeTestable(HydroleafApp(apiService: mockApi), mockApi),
    );

    // Should see the app title and two text fields + a login button
    expect(find.text('Hydroleaf'), findsOneWidget);
    expect(find.byType(TextField), findsNWidgets(2));
    expect(find.byType(PrimaryButton), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
  });

  testWidgets('Tapping Login navigates to Dashboard',
      (WidgetTester tester) async {
    final mockApi = MockApiService();

    await tester.pumpWidget(
      makeTestable(HydroleafApp(apiService: mockApi), mockApi),
    );

    // Enter email & password
    final emailField = find.byType(TextField).first;
    final passField = find.byType(TextField).at(1);
    await tester.enterText(emailField, 'test@example.com');
    await tester.enterText(passField, 'password123');

    // Tap the login button
    await tester.tap(find.text('Login'));
    await tester.pump(); // start the tap animation
    await tester.pump(const Duration(seconds: 1)); // wait out Future.delayed
    await tester.pumpAndSettle(); // finish navigation animations

    // On Dashboard: we should see our summary cards
    expect(find.text('Total Farms'), findsOneWidget);
    expect(find.text('Active Devices'), findsOneWidget);
  });
}
