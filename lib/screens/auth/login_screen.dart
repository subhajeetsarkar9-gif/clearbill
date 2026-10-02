import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/business_provider.dart';
import '../../routes/app_routes.dart';
import '../../utils/constants.dart';
import '../../theme/app_colors.dart';
import '../../widgets/common/custom_button.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(28.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              Center(
                child: Image.asset(
                  'assets/logo.png',
                  height: 90,
                  errorBuilder: (context, error, stackTrace) => const CircleAvatar(
                    radius: 40,
                    backgroundColor: AppColors.primary,
                    child: Icon(Icons.receipt_long, size: 40, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Welcome to ${AppConstants.appName}',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                AppConstants.appDescription,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const Spacer(),
              CustomButton(
                text: 'Sign in with Google',
                icon: Icons.login,
                isLoading: authProvider.isLoading,
                onPressed: () async {
                  final success = await authProvider.signInWithGoogle();
                  if (!context.mounted) return;
                  if (success) {
                    final bProvider = Provider.of<BusinessProvider>(context, listen: false);
                    await bProvider.loadBusiness();
                    if (!context.mounted) return;
                    if (bProvider.hasBusinessSetup) {
                      Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
                    } else {
                      Navigator.pushReplacementNamed(context, AppRoutes.businessSetup);
                    }
                  }
                },
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: () async {
                  await authProvider.loginAsGuest();
                  if (!context.mounted) return;
                  final bProvider = Provider.of<BusinessProvider>(context, listen: false);
                  await bProvider.loadBusiness();
                  if (!context.mounted) return;
                  if (bProvider.hasBusinessSetup) {
                    Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
                  } else {
                    Navigator.pushReplacementNamed(context, AppRoutes.businessSetup);
                  }
                },
                icon: const Icon(Icons.person_outline),
                label: const Text('Continue as Guest / Demo Mode'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
