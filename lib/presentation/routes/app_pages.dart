import 'package:get/get.dart';
import 'app_routes.dart';
import '../views/home/index.dart';
import '../views/splash/index.dart';
import '../views/welcome/index.dart';
import '../views/onboarding/onboarding_screen.dart';
import '../views/auth/login_screen.dart';
import '../views/auth/register_screen.dart';
import '../views/auth/forgot_password_screen.dart';
import '../views/candidate/candidate_main_screen.dart';
import '../views/candidate/candidate_home_screen.dart';
import '../views/candidate/candidate_profile_screen.dart';
import '../views/candidate/edit_profile_screen.dart';
import '../views/candidate/change_password_screen.dart';
import '../views/candidate/candidate_company_profile_screen.dart';
import '../views/candidate/candidate_job_detail_screen.dart';
import '../views/candidate/candidate_applications_screen.dart';
import '../views/candidate/candidate_favorites_screen.dart';
import '../views/candidate/experience_management_screen.dart';
import '../views/candidate/experience_form_screen.dart';
import '../views/hr/hr_main_screen.dart';
import '../views/hr/hr_dashboard_screen.dart';
import '../views/hr/hr_profile_screen.dart';
import '../views/hr/hr_edit_profile_screen.dart';
import '../views/hr/hr_change_password_screen.dart';
import '../views/hr/hr_applications_screen.dart';
import '../views/hr/hr_entreprise_profile_screen.dart';
import '../views/search/search_page.dart';
import '../bindings/auth_binding.dart';
import '../bindings/onboarding_binding.dart';
import '../bindings/registration_binding.dart';
import '../bindings/candidate_binding.dart';
import '../bindings/hr_binding.dart';

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
      page: () => const OnboardingScreen(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: AppRoutes.auth,
      page: () => const LoginScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.register,
      page: () => const RegisterScreen(),
      binding: RegistrationBinding(),
    ),
    GetPage(
      name: AppRoutes.forgotPassword,
      page: () => const ForgotPasswordScreen(),
      binding: AuthBinding(),
    ),
    // Candidate routes
    GetPage(
      name: AppRoutes.candidateMain,
      page: () => const CandidateMainScreen(),
      binding: CandidateBinding(),
    ),
    GetPage(
      name: AppRoutes.candidateHome,
      page: () => const CandidateHomeScreen(),
      binding: CandidateBinding(),
    ),
    GetPage(
      name: AppRoutes.candidateProfile,
      page: () => const CandidateProfileScreen(),
      binding: CandidateBinding(),
    ),
    GetPage(
      name: AppRoutes.candidateEditProfile,
      page: () => const EditProfileScreen(),
      binding: CandidateBinding(),
    ),
    GetPage(
      name: AppRoutes.candidateChangePassword,
      page: () => const ChangePasswordScreen(),
      binding: CandidateBinding(),
    ),
    GetPage(
      name: AppRoutes.candidateCompanyProfile,
      page: () => const CandidateCompanyProfileScreen(),
      binding: CandidateBinding(),
    ),
    GetPage(
      name: AppRoutes.candidateJobDetail,
      page: () => const CandidateJobDetailScreen(),
      binding: CandidateBinding(),
    ),
    GetPage(
      name: AppRoutes.candidateApplications,
      page: () => const CandidateApplicationsScreen(),
      binding: CandidateBinding(),
    ),
    GetPage(
      name: AppRoutes.candidateFavorites,
      page: () => const CandidateFavoritesScreen(),
      binding: CandidateBinding(),
    ),
    GetPage(
      name: AppRoutes.candidateExperienceManagement,
      page: () => const ExperienceManagementScreen(),
      binding: CandidateBinding(),
    ),
    GetPage(
      name: AppRoutes.candidateExperienceForm,
      page: () => const ExperienceFormScreen(),
      binding: CandidateBinding(),
    ),
    // HR routes
    GetPage(
      name: AppRoutes.hrMain,
      page: () => const HRMainScreen(),
      binding: HrBinding(),
    ),
    GetPage(
      name: AppRoutes.hrDashboard,
      page: () => const HRDashboardScreen(),
      binding: HrBinding(),
    ),
    GetPage(
      name: AppRoutes.hrProfile,
      page: () => const HRProfileScreen(),
      binding: HrBinding(),
    ),
    GetPage(
      name: AppRoutes.hrEditProfile,
      page: () => const HREditProfileScreen(),
      binding: HrBinding(),
    ),
    GetPage(
      name: AppRoutes.hrChangePassword,
      page: () => const HRChangePasswordScreen(),
      binding: HrBinding(),
    ),
    GetPage(
      name: AppRoutes.hrApplications,
      page: () => const HRApplicationsScreen(),
      binding: HrBinding(),
    ),
    GetPage(
      name: AppRoutes.hrCompany,
      page: () => const HREntrepriseProfileScreen(),
      binding: HrBinding(),
    ),
    GetPage(
      name: AppRoutes.search,
      page: () => const SearchPage(),
      binding: BindingsBuilder(() {}),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomePage(),
      binding: HomeBindings(),
    ),
  ];
}
