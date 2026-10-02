import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:clearbill/app.dart';
import 'package:clearbill/providers/auth_provider.dart';
import 'package:clearbill/providers/theme_provider.dart';
import 'package:clearbill/providers/business_provider.dart';
import 'package:clearbill/providers/client_provider.dart';
import 'package:clearbill/providers/product_provider.dart';
import 'package:clearbill/providers/invoice_provider.dart';

void main() {
  testWidgets('App initialization test', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
          ChangeNotifierProvider(create: (_) => AuthProvider()),
          ChangeNotifierProvider(create: (_) => BusinessProvider()),
          ChangeNotifierProvider(create: (_) => ClientProvider()),
          ChangeNotifierProvider(create: (_) => ProductProvider()),
          ChangeNotifierProvider(create: (_) => InvoiceProvider()),
        ],
        child: const ClearBillApp(),
      ),
    );

    expect(find.byType(ClearBillApp), findsOneWidget);
  });
}
