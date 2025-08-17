import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kanz/core/theme/app_theme.dart';
import '../../../widgets/index.dart';
import '../../controllers/auth_controller.dart';

class SignUpPage extends GetView<AuthController> {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: controller.signUpFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CustomText.title('Sign Up', textAlign: TextAlign.center),
                  const SizedBox(height: 8),
                  CustomText.body(
                    'Create a new account to get started.',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  AppTextField(
                    controller: controller.nameController,
                    label: 'Name',
                    hint: 'Enter your name',
                    textInputAction: TextInputAction.next,
                    isRequired: true,
                    validator: controller.validateName,
                  ),
                  const SizedBox(height: 16),
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
                      hint: 'Create a password',
                      obscureText: !controller.isPasswordVisible.value,
                      showPasswordToggle: true,
                      isRequired: true,
                      textInputAction: TextInputAction.next,
                      validator: controller.validatePassword,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Obx(
                    () => AppTextField(
                      controller: controller.confirmPasswordController,
                      label: 'Confirm Password',
                      hint: 'Re-enter your password',
                      obscureText: !controller.isConfirmPasswordVisible.value,
                      showPasswordToggle: true,
                      isRequired: true,
                      textInputAction: TextInputAction.done,
                      validator: controller.validateConfirmPassword,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Obx(
                    () => AppButton(
                      label: 'Sign Up',
                      isExpanded: true,
                      isLoading: controller.isLoading.value,
                      onPressed:
                          controller.isLoading.value ? null : controller.signUp,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomText.bodySmall('Already have an account?'),
                      AppButton(
                        label: 'Sign In',
                        variant: AppButtonVariant.text,
                        textStyle: AppTheme.body2Medium,
                        onPressed: controller.goToSignIn,
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
