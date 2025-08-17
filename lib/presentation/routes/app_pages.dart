import 'package:get/get.dart';
import 'app_routes.dart';
import '../views/home/index.dart';
import '../views/splash/index.dart';
import '../views/welcome/index.dart';
import '../views/onboarding/index.dart';
import '../views/auth/sign_in_page.dart';
import '../views/auth/sign_up_page.dart';
import '../bindings/auth_binding.dart';
import '../bindings/onboarding_binding.dart';

/// App pages configuration
class AppPages {
  static const initial = AppRoutes.splash;

  static final routes = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashPage(),
      binding: SplashBindings(),
    ),
    GetPage(
      name: AppRoutes.welcome,
      page: () => const WelcomePage(),
      binding: WelcomeBindings(),
    ),
    GetPage(
      name: AppRoutes.onboarding,
      page: () => const OnboardingPage(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: AppRoutes.signIn,
      page: () => const SignInPage(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.signUp,
      page: () => const SignUpPage(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomePage(),
      binding: HomeBindings(),
    ),
    // Add more routes here
    // Example:
    // GetPage(
    //   name: AppRoutes.login,
    //   page: () => const LoginPage(),
    //   binding: LoginBindings(),
    // ),
  ];
}
