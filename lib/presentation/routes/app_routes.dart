/// App route constants
abstract class AppRoutes {
  // Main routes
  static const home = '/home';
  static const splash = '/splash';
  static const welcome = '/welcome';
  static const onboarding = '/onboarding';

  // Authentication routes
  static const auth = '/auth';
  static const login = '/login';
  static const register = '/register';
  static const forgotPassword = '/forgot-password';

  // Candidate routes
  static const candidateMain = '/candidate/main';
  static const candidateHome = '/candidate/home';
  static const candidateProfile = '/candidate/profile';
  static const candidateEditProfile = '/candidate/edit-profile';
  static const candidateChangePassword = '/candidate/change-password';
  static const candidateCompanyProfile = '/candidate/company-profile';
  static const candidateApplications = '/candidate/applications';
  static const candidateFavorites = '/candidate/favorites';
  static const candidateJobDetail = '/candidate/job-detail';
  static const candidateExperienceManagement =
      '/candidate/experience-management';
  static const candidateExperienceForm = '/candidate/experience-form';

  // HR routes
  static const hrMain = '/hr/main';
  static const hrDashboard = '/hr/dashboard';
  static const hrProfile = '/hr/profile';
  static const hrEditProfile = '/hr/edit-profile';
  static const hrChangePassword = '/hr/change-password';
  static const hrJobOffers = '/hr/job-offers';
  static const hrApplications = '/hr/applications';
  static const hrJobPosts = '/hr/job-posts';
  static const hrApplicationsManagement = '/hr/applications-management';
  static const hrCompany = '/hr/company';

  // Profile routes
  static const profile = '/profile';
  static const settings = '/settings';

  // Search routes
  static const search = '/search';

  // Add more routes as needed
  // static const detail = '/detail';
  // static const edit = '/edit';
}
