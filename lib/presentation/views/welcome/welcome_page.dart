import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../widgets/index.dart';
import '../../controllers/welcome_controller.dart';

class WelcomePage extends GetView<WelcomeController> {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const Spacer(),

              // App logo and title
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(Icons.flutter_dash, size: 50, color: Colors.white),
              ),
              const SizedBox(height: 24),

              CustomText.subtitle(
                'Welcome to kanz App',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),

              CustomText.body(
                'Sign in to continue or create a new account to get started',
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                textAlign: TextAlign.center,
              ),

              const Spacer(),

              // Authentication buttons
              Column(
                children: [
                  // Sign In button
                  AppButton(
                    label: 'Sign In',
                    isExpanded: true,
                    variant: AppButtonVariant.primary,
                    onPressed: () => controller.onSignInPressed(),
                  ),
                  const SizedBox(height: 16),

                  // Sign Up button
                  AppButton(
                    label: 'Sign Up',
                    isExpanded: false,
                    variant: AppButtonVariant.outline,
                    onPressed: () => controller.onSignUpPressed(),
                  ),
                  const SizedBox(height: 24),

                  // Divider
                  Row(
                    children: [
                      Expanded(
                        child: Divider(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withOpacity(0.2),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: CustomText.bodySmall(
                          'or continue with',
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withOpacity(0.2),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Social login buttons
                  Row(
                    children: [
                      Expanded(
                        child: AppButton(
                          label: 'Google',
                          leadingIcon: Icons.apple,
                          variant: AppButtonVariant.social,
                          onPressed: () => controller.onAppleSignInPressed(),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: AppButton(
                          label: 'Apple',
                          leadingIcon: Icons.apple,
                          variant: AppButtonVariant.social,
                          onPressed: () => controller.onAppleSignInPressed(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class _SocialLoginButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const _SocialLoginButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppButton(
      label: label,
      leadingIcon: icon,
      variant: AppButtonVariant.social,
      onPressed: onPressed,
    );
  }
}
