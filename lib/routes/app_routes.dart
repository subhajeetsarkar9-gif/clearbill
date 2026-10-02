import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/splash/splash_screen.dart';
import '../screens/onboarding/onboarding_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/setup/business_setup_screen.dart';
import '../screens/dashboard/dashboard_screen.dart';
import '../screens/invoice/create_invoice_screen.dart';
import '../screens/invoice/invoice_list_screen.dart';
import '../screens/invoice/invoice_detail_screen.dart';
import '../screens/client/client_list_screen.dart';
import '../screens/client/add_client_screen.dart';
import '../screens/product/product_list_screen.dart';
import '../screens/product/add_product_screen.dart';
import '../screens/reports/reports_screen.dart';
import '../screens/settings/settings_screen.dart';
import '../screens/premium/premium_upgrade_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String businessSetup = '/business-setup';
  static const String dashboard = '/dashboard';
  static const String createInvoice = '/invoice/create';
  static const String invoiceList = '/invoice/list';
  static const String invoiceDetail = '/invoice/detail';
  static const String clientList = '/clients';
  static const String addClient = '/clients/add';
  static const String productList = '/products';
  static const String addProduct = '/products/add';
  static const String reports = '/reports';
  static const String settings = '/settings';
  static const String premiumUpgrade = '/premium';

  static final GoRouter router = GoRouter(
    initialLocation: splash,
    routes: [
      GoRoute(path: splash, builder: (context, state) => const SplashScreen()),
      GoRoute(path: onboarding, builder: (context, state) => const OnboardingScreen()),
      GoRoute(path: login, builder: (context, state) => const LoginScreen()),
      GoRoute(path: businessSetup, builder: (context, state) => const BusinessSetupScreen()),
      GoRoute(path: dashboard, builder: (context, state) => const DashboardScreen()),
      GoRoute(path: createInvoice, builder: (context, state) => const CreateInvoiceScreen()),
      GoRoute(path: invoiceList, builder: (context, state) => const InvoiceListScreen()),
      GoRoute(
        path: invoiceDetail,
        builder: (context, state) {
          final id = state.extra as int? ?? 1;
          return InvoiceDetailScreen(invoiceId: id);
        },
      ),
      GoRoute(path: clientList, builder: (context, state) => const ClientListScreen()),
      GoRoute(path: addClient, builder: (context, state) => const AddClientScreen()),
      GoRoute(path: productList, builder: (context, state) => const ProductListScreen()),
      GoRoute(path: addProduct, builder: (context, state) => const AddProductScreen()),
      GoRoute(path: reports, builder: (context, state) => const ReportsScreen()),
      GoRoute(path: settings, builder: (context, state) => const SettingsScreen()),
      GoRoute(path: premiumUpgrade, builder: (context, state) => const PremiumUpgradeScreen()),
    ],
  );

  static Map<String, WidgetBuilder> get routes {
    return {
      splash: (context) => const SplashScreen(),
      onboarding: (context) => const OnboardingScreen(),
      login: (context) => const LoginScreen(),
      businessSetup: (context) => const BusinessSetupScreen(),
      dashboard: (context) => const DashboardScreen(),
      createInvoice: (context) => const CreateInvoiceScreen(),
      invoiceList: (context) => const InvoiceListScreen(),
      clientList: (context) => const ClientListScreen(),
      addClient: (context) => const AddClientScreen(),
      productList: (context) => const ProductListScreen(),
      addProduct: (context) => const AddProductScreen(),
      reports: (context) => const ReportsScreen(),
      settings: (context) => const SettingsScreen(),
      premiumUpgrade: (context) => const PremiumUpgradeScreen(),
    };
  }

  static Route<dynamic>? onGenerateRoute(RouteSettings settingsParam) {
    if (settingsParam.name == invoiceDetail) {
      final invoiceId = settingsParam.arguments as int? ?? 1;
      return MaterialPageRoute(
        builder: (context) => InvoiceDetailScreen(invoiceId: invoiceId),
      );
    }
    return null;
  }
}
