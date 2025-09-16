import 'package:get/get.dart';
import '../theme/theme_bindings.dart';

// Data layer - Repository implementations
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/repositories/entreprise_repository_impl.dart';
import '../../data/repositories/job_offer_repository_impl.dart';
import '../../data/repositories/application_repository_impl.dart';
import '../../data/repositories/profile_repository_impl.dart';

// Domain layer - Repository interfaces
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/entreprise_repository.dart';
import '../../domain/repositories/job_offer_repository.dart';
import '../../domain/repositories/application_repository.dart';
import '../../domain/repositories/profile_repository.dart';

// Domain layer - Use cases
import '../../domain/usecases/auth_usecases.dart';
import '../../domain/usecases/entreprise_usecases.dart';
import '../../domain/usecases/job_offer_usecases.dart';
import '../../domain/usecases/application_usecases.dart';
import '../../domain/usecases/profile_usecases.dart';

// Presentation layer - Controllers
import '../../presentation/controllers/auth_controller.dart';
import '../../presentation/controllers/onboarding_controller.dart';
import '../../presentation/controllers/splash_controller.dart';
import '../../presentation/controllers/welcome_controller.dart';
import '../../presentation/controllers/registration_controller.dart';
import '../../presentation/controllers/candidate_controller.dart';
import '../../presentation/controllers/hr_controller.dart';
import '../../presentation/controllers/profile_controller.dart';
import '../../presentation/controllers/audio_search_controller.dart';

/// Initial bindings for core dependencies following clean architecture principles
class InitialBindings extends Bindings {
  @override
  void dependencies() {
    // Initialize theme bindings
    ThemeBindings().dependencies();

    // ===== REPOSITORIES =====
    // Register repository implementations as their interfaces
    Get.lazyPut<AuthRepository>(() => AuthRepositoryImpl(), fenix: true);
    Get.lazyPut<EntrepriseRepository>(
      () => EntrepriseRepositoryImpl(),
      fenix: true,
    );
    Get.lazyPut<JobOfferRepository>(
      () => JobOfferRepositoryImpl(),
      fenix: true,
    );
    Get.lazyPut<ApplicationRepository>(
      () => ApplicationRepositoryImpl(),
      fenix: true,
    );
    Get.lazyPut<ProfileRepository>(() => ProfileRepositoryImpl(), fenix: true);

    // ===== AUTH USE CASES =====
    Get.lazyPut<SignInUseCase>(
      () => SignInUseCase(Get.find<AuthRepository>()),
      fenix: true,
    );
    Get.lazyPut<SignUpUseCase>(
      () => SignUpUseCase(Get.find<AuthRepository>()),
      fenix: true,
    );
    Get.lazyPut<SignOutUseCase>(
      () => SignOutUseCase(Get.find<AuthRepository>()),
      fenix: true,
    );
    Get.lazyPut<ForgotPasswordUseCase>(
      () => ForgotPasswordUseCase(Get.find<AuthRepository>()),
      fenix: true,
    );
    Get.lazyPut<GetCurrentUserUseCase>(
      () => GetCurrentUserUseCase(Get.find<AuthRepository>()),
      fenix: true,
    );
    Get.lazyPut<GetUserByIdUseCase>(
      () => GetUserByIdUseCase(Get.find<AuthRepository>()),
      fenix: true,
    );

    Get.lazyPut<UpdateUserFavoritesUseCase>(
      () => UpdateUserFavoritesUseCase(Get.find<AuthRepository>()),
      fenix: true,
    );

    // ===== PROFILE USE CASES =====
    Get.lazyPut<UpdateProfileUseCase>(
      () => UpdateProfileUseCase(Get.find<ProfileRepository>()),
      fenix: true,
    );
    Get.lazyPut<ChangePasswordUseCase>(
      () => ChangePasswordUseCase(Get.find<ProfileRepository>()),
      fenix: true,
    );
    Get.lazyPut<DeleteAccountUseCase>(
      () => DeleteAccountUseCase(Get.find<ProfileRepository>()),
      fenix: true,
    );
    Get.lazyPut<GetProfileStatisticsUseCase>(
      () => GetProfileStatisticsUseCase(Get.find<ProfileRepository>()),
      fenix: true,
    );
    Get.lazyPut<UpdatePreferencesUseCase>(
      () => UpdatePreferencesUseCase(Get.find<ProfileRepository>()),
      fenix: true,
    );
    Get.lazyPut<GetPreferencesUseCase>(
      () => GetPreferencesUseCase(Get.find<ProfileRepository>()),
      fenix: true,
    );

    // ===== ENTREPRISE USE CASES =====
    Get.lazyPut<CreateEntrepriseUseCase>(
      () => CreateEntrepriseUseCase(Get.find<EntrepriseRepository>()),
      fenix: true,
    );
    Get.lazyPut<GetEntrepriseUseCase>(
      () => GetEntrepriseUseCase(Get.find<EntrepriseRepository>()),
      fenix: true,
    );
    Get.lazyPut<UpdateEntrepriseUseCase>(
      () => UpdateEntrepriseUseCase(Get.find<EntrepriseRepository>()),
      fenix: true,
    );
    Get.lazyPut<DeleteEntrepriseUseCase>(
      () => DeleteEntrepriseUseCase(Get.find<EntrepriseRepository>()),
      fenix: true,
    );
    Get.lazyPut<GetAllEntreprisesUseCase>(
      () => GetAllEntreprisesUseCase(Get.find<EntrepriseRepository>()),
      fenix: true,
    );

    // ===== JOB OFFER USE CASES =====
    Get.lazyPut<GetAllJobOffersUseCase>(
      () => GetAllJobOffersUseCase(Get.find<JobOfferRepository>()),
      fenix: true,
    );
    Get.lazyPut<GetJobOffersByEntrepriseUseCase>(
      () => GetJobOffersByEntrepriseUseCase(Get.find<JobOfferRepository>()),
      fenix: true,
    );
    Get.lazyPut<GetJobOfferByIdUseCase>(
      () => GetJobOfferByIdUseCase(Get.find<JobOfferRepository>()),
      fenix: true,
    );
    Get.lazyPut<CreateJobOfferUseCase>(
      () => CreateJobOfferUseCase(Get.find<JobOfferRepository>()),
      fenix: true,
    );
    Get.lazyPut<UpdateJobOfferUseCase>(
      () => UpdateJobOfferUseCase(Get.find<JobOfferRepository>()),
      fenix: true,
    );
    Get.lazyPut<DeleteJobOfferUseCase>(
      () => DeleteJobOfferUseCase(Get.find<JobOfferRepository>()),
      fenix: true,
    );
    Get.lazyPut<SearchJobOffersUseCase>(
      () => SearchJobOffersUseCase(Get.find<JobOfferRepository>()),
      fenix: true,
    );

    // ===== APPLICATION USE CASES =====
    Get.lazyPut<GetApplicationsByJobOfferUseCase>(
      () => GetApplicationsByJobOfferUseCase(Get.find<ApplicationRepository>()),
      fenix: true,
    );
    Get.lazyPut<GetApplicationsByCandidateUseCase>(
      () =>
          GetApplicationsByCandidateUseCase(Get.find<ApplicationRepository>()),
      fenix: true,
    );
    Get.lazyPut<GetApplicationByIdUseCase>(
      () => GetApplicationByIdUseCase(Get.find<ApplicationRepository>()),
      fenix: true,
    );
    Get.lazyPut<CreateApplicationUseCase>(
      () => CreateApplicationUseCase(Get.find<ApplicationRepository>()),
      fenix: true,
    );
    Get.lazyPut<UpdateApplicationStatusUseCase>(
      () => UpdateApplicationStatusUseCase(Get.find<ApplicationRepository>()),
      fenix: true,
    );
    Get.lazyPut<DeleteApplicationUseCase>(
      () => DeleteApplicationUseCase(Get.find<ApplicationRepository>()),
      fenix: true,
    );
    Get.lazyPut<HasCandidateAppliedUseCase>(
      () => HasCandidateAppliedUseCase(Get.find<ApplicationRepository>()),
      fenix: true,
    );

    // ===== SHARED CONTROLLERS =====
    Get.lazyPut<AuthController>(
      () => AuthController(
        Get.find<SignInUseCase>(),
        Get.find<SignUpUseCase>(),
        Get.find<SignOutUseCase>(),
        Get.find<ForgotPasswordUseCase>(),
        Get.find<GetCurrentUserUseCase>(),
      ),
      fenix: true,
    );

    Get.lazyPut<ProfileController>(
      () => ProfileController(
        Get.find<SignInUseCase>(),
        Get.find<SignUpUseCase>(),
        Get.find<SignOutUseCase>(),
        Get.find<ForgotPasswordUseCase>(),
        Get.find<GetCurrentUserUseCase>(),
        Get.find<UpdateProfileUseCase>(),
        Get.find<ChangePasswordUseCase>(),
        Get.find<DeleteAccountUseCase>(),
        Get.find<GetProfileStatisticsUseCase>(),
        Get.find<UpdatePreferencesUseCase>(),
        Get.find<GetPreferencesUseCase>(),
        Get.find<GetEntrepriseUseCase>(),
      ),
      fenix: true,
    );

    Get.lazyPut<OnboardingController>(
      () => OnboardingController(),
      fenix: true,
    );

    Get.lazyPut<SplashController>(
      () => SplashController(
        getCurrentUserUseCase: Get.find<GetCurrentUserUseCase>(),
      ),
      fenix: true,
    );

    Get.lazyPut<WelcomeController>(() => WelcomeController(), fenix: true);

    Get.lazyPut<RegistrationController>(
      () => RegistrationController(
        Get.find<SignUpUseCase>(),
        Get.find<CreateEntrepriseUseCase>(),
        Get.find<AuthRepository>(),
      ),
      fenix: true,
    );

    // ===== AUDIO SEARCH CONTROLLER =====
    Get.lazyPut<AudioSearchController>(
      () => AudioSearchController(),
      fenix: true,
    );

    // ===== CANDIDATE CONTROLLER =====
    Get.lazyPut<CandidateController>(
      () => CandidateController(
        Get.find<GetAllJobOffersUseCase>(),
        Get.find<SearchJobOffersUseCase>(),
        Get.find<GetApplicationsByCandidateUseCase>(),
        Get.find<CreateApplicationUseCase>(),
        Get.find<HasCandidateAppliedUseCase>(),
        Get.find<GetCurrentUserUseCase>(),
        Get.find<UpdateUserFavoritesUseCase>(),
        Get.find<GetEntrepriseUseCase>(),
      ),
      fenix: true,
    );

    // ===== HR CONTROLLER =====
    Get.lazyPut<HRController>(
      () => HRController(
        Get.find<GetJobOffersByEntrepriseUseCase>(),
        Get.find<CreateJobOfferUseCase>(),
        Get.find<UpdateJobOfferUseCase>(),
        Get.find<DeleteJobOfferUseCase>(),
        Get.find<GetApplicationsByJobOfferUseCase>(),
        Get.find<UpdateApplicationStatusUseCase>(),
        Get.find<GetCurrentUserUseCase>(),
      ),
      fenix: true,
    );
  }
}
