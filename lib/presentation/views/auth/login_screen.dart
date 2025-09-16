// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/consts/assets.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/config/app_config.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_text_field.dart';
import '../../controllers/auth_controller.dart';

class LoginScreen extends GetView<AuthController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConfig.defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 60),

              // Logo and title
              Column(
                children: [
                  Image.asset(AppAssets.logo, width: 120, height: 120),
                  const SizedBox(height: 24),
                  Text(
                    'Welcome',
                    style: AppTheme.heading2Bold.copyWith(
                      color: AppTheme.onBackgroundColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Sign in to your account',
                    style: AppTheme.body1Medium.copyWith(
                      color: AppTheme.onBackgroundColor.withOpacity(0.7),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 48),

              // Login form
              Form(
                child: Column(
                  children: [
                    // Email field
                    AppTextField(
                      controller: controller.emailController,
                      label: 'Email',
                      hint: 'Enter your email',
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: Icons.email_outlined,
                      onChanged: (value) => controller.clearError(),
                    ),

                    const SizedBox(height: 16),

                    // Password field
                    AppTextField(
                      controller: controller.passwordController,
                      label: 'Password',
                      hint: 'Enter your password',
                      obscureText: true,
                      prefixIcon: Icons.lock_outlined,
                      onChanged: (value) => controller.clearError(),
                    ),

                    const SizedBox(height: 8),

                    // Forgot password
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => Get.toNamed('/forgot-password'),
                        child: Text(
                          'Forgot password?',
                          style: AppTheme.body2Medium.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Error message
                    Obx(
                      () =>
                          controller.errorMessage.value.isNotEmpty
                              ? Container(
                                padding: const EdgeInsets.all(12),
                                margin: const EdgeInsets.only(bottom: 16),
                                decoration: BoxDecoration(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.error.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.error.withOpacity(0.3),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.error_outline,
                                      color:
                                          Theme.of(context).colorScheme.error,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        controller.errorMessage.value,
                                        style: AppTheme.body2Medium.copyWith(
                                          color:
                                              Theme.of(
                                                context,
                                              ).colorScheme.error,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                              : const SizedBox(),
                    ),

                    // Login button
                    Obx(
                      () => AppButton(
                        backgroundColor: AppTheme.primaryColor,
                        onPressed:
                            controller.isLoading.value
                                ? null
                                : controller.signIn,
                        label:
                            controller.isLoading.value
                                ? 'Signing in...'
                                : 'Sign In',
                        isLoading: controller.isLoading.value,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Divider
                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            color: AppTheme.onBackgroundColor.withOpacity(0.2),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'or',
                            style: AppTheme.body2Medium.copyWith(
                              color: AppTheme.onBackgroundColor.withOpacity(
                                0.5,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            color: AppTheme.onBackgroundColor.withOpacity(0.2),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Register button
                    AppButton(
                      onPressed: () => Get.toNamed('/register'),
                      backgroundColor: AppTheme.backgroundColor,
                      label: 'Create Account',
                      textStyle: AppTheme.body1Medium.copyWith(
                        color: AppTheme.primaryColor,
                      ),
                      borderColor: AppTheme.primaryColor,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
