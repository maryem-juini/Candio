import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_theme.dart';
import '../../../widgets/index.dart';
import '../../controllers/auth_controller.dart';

class SignInPage extends GetView<AuthController> {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: controller.signInFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CustomText.title('Sign In', textAlign: TextAlign.center),
                  const SizedBox(height: 8),
                  CustomText.body(
                    'Welcome back! Please sign in to continue.',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  AppTextField(
                    controller: controller.emailController,
                    label: 'Email',
                    hint: 'Enter your email',
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    isRequired: true,
                    validator: controller.validateEmail,
                  ),
                  const SizedBox(height: 16),
                  Obx(
                    () => AppTextField(
                      controller: controller.passwordController,
                      label: 'Password',
                      hint: 'Enter your password',
                      obscureText: !controller.isPasswordVisible.value,
                      showPasswordToggle: true,
                      isRequired: true,
                      textInputAction: TextInputAction.done,
                      validator: controller.validatePassword,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Obx(
                    () => AppButton(
                      label: 'Sign In',
                      isExpanded: true,
                      isLoading: controller.isLoading.value,
                      onPressed:
                          controller.isLoading.value ? null : controller.signIn,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomText.bodySmall('Don\'t have an account?'),
                      AppButton(
                        label: 'Sign Up',
                        variant: AppButtonVariant.text,
                        textStyle: AppTheme.body2Medium,
                        onPressed: controller.goToSignUp,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
