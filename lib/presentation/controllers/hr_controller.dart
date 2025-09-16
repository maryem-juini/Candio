import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../domain/entities/job_offer_entity.dart';
import '../../domain/entities/application_entity.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/job_offer_usecases.dart';
import '../../domain/usecases/application_usecases.dart';
import '../../domain/usecases/auth_usecases.dart';

class HRController extends GetxController {
  final GetJobOffersByEntrepriseUseCase _getJobOffersByEntrepriseUseCase;
  final CreateJobOfferUseCase _createJobOfferUseCase;
  final UpdateJobOfferUseCase _updateJobOfferUseCase;
  final DeleteJobOfferUseCase _deleteJobOfferUseCase;
  final GetApplicationsByJobOfferUseCase _getApplicationsByJobOfferUseCase;
  final UpdateApplicationStatusUseCase _updateApplicationStatusUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;

  HRController(
    this._getJobOffersByEntrepriseUseCase,
    this._createJobOfferUseCase,
    this._updateJobOfferUseCase,
    this._deleteJobOfferUseCase,
    this._getApplicationsByJobOfferUseCase,
    this._updateApplicationStatusUseCase,
    this._getCurrentUserUseCase,
  );

  // Observable variables
  final RxList<JobOfferEntity> jobOffers = <JobOfferEntity>[].obs;
  final RxList<ApplicationEntity> applications = <ApplicationEntity>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isCreatingOffer = false.obs;
  final Rx<UserEntity?> currentUser = Rx<UserEntity?>(null);
  final RxString selectedJobOfferId = ''.obs;

  // Form variables for creating/editing job offers
  final RxString jobTitle = ''.obs;
  final RxString jobLocation = ''.obs;
  final RxString jobContractType = ''.obs;
  final RxString jobDescription = ''.obs;
  final RxList<String> jobRequirements = <String>[].obs;
  final RxString jobSalaryRange = ''.obs;
  final Rx<DateTime> jobDeadline =
      DateTime.now().add(const Duration(days: 30)).obs;

  // Navigation
  final RxInt currentTab = 0.obs;

  // Filter for applications
  final RxString selectedFilter = 'all'.obs;

  @override
  void onInit() {
    super.onInit();
    loadCurrentUser();
    loadAllApplications();
  }

  Future<void> loadCurrentUser() async {
    try {
      final user = await _getCurrentUserUseCase();
      currentUser.value = user;
      if (user != null && user.entrepriseId != null) {
        await loadJobOffers();
      }
    } catch (e) {
      debugPrint('Error loading current user: $e');
    }
  }

  Future<void> loadJobOffers() async {
    try {
      if (currentUser.value?.entrepriseId == null) return;

      isLoading.value = true;
      final offers = await _getJobOffersByEntrepriseUseCase(
        currentUser.value!.entrepriseId!,
      );
      jobOffers.value = offers;

      // Load applications after job offers are loaded
      await loadAllApplications();
    } catch (e) {
      debugPrint('Error loading job offers: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadApplicationsForJob(String jobOfferId) async {
    try {
      isLoading.value = true;
      final apps = await _getApplicationsByJobOfferUseCase(jobOfferId);
      applications.value = apps;
      selectedJobOfferId.value = jobOfferId;
    } catch (e) {
      debugPrint('Error loading applications: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadAllApplications() async {
    try {
      if (currentUser.value?.entrepriseId == null) return;

      debugPrint(
        'Loading all applications for entreprise: ${currentUser.value!.entrepriseId}',
      );

      // Load applications for all job offers of this entreprise
      final allApplications = <ApplicationEntity>[];
      for (final jobOffer in jobOffers) {
        debugPrint('Loading applications for job offer: ${jobOffer.id}');
        final apps = await _getApplicationsByJobOfferUseCase(jobOffer.id);
        debugPrint(
          'Found ${apps.length} applications for job offer: ${jobOffer.id}',
        );
        allApplications.addAll(apps);
      }

      applications.value = allApplications;
      debugPrint('Total applications loaded: ${allApplications.length}');
    } catch (e) {
      debugPrint('Error loading all applications: $e');
      // Don't throw the error, just log it and continue
    }
  }

  Future<void> createJobOffer() async {
    try {
      if (currentUser.value?.entrepriseId == null) return;

      isCreatingOffer.value = true;

      final jobOffer = JobOfferEntity(
        id: '',
        title: jobTitle.value,
        company: currentUser.value!.name, // This should be entreprise name
        location: jobLocation.value,
        contractType: jobContractType.value,
        description: jobDescription.value,
        requirements: jobRequirements,
        salaryRange:
            jobSalaryRange.value.isNotEmpty ? jobSalaryRange.value : null,
        deadline: jobDeadline.value,
        entrepriseId: currentUser.value!.entrepriseId!,
        createdAt: DateTime.now(),
      );

      await _createJobOfferUseCase(jobOffer);

      // Clear form
      clearJobOfferForm();

      // Reload offers
      await loadJobOffers();

      Get.snackbar('Success', 'Job offer created successfully!');
    } catch (e) {
      Get.snackbar('Error', 'Failed to create job offer: $e');
    } finally {
      isCreatingOffer.value = false;
    }
  }

  Future<void> updateJobOffer(JobOfferEntity jobOffer) async {
    try {
      await _updateJobOfferUseCase(jobOffer);
      await loadJobOffers();
      Get.snackbar('Success', 'Job offer updated successfully!');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update job offer: $e');
    }
  }

  Future<void> deleteJobOffer(String jobOfferId) async {
    try {
      await _deleteJobOfferUseCase(jobOfferId);
      await loadJobOffers();
      Get.snackbar('Success', 'Job offer deleted successfully!');
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete job offer: $e');
    }
  }

  Future<void> updateApplicationStatus(
    String applicationId,
    ApplicationStatus status,
  ) async {
    try {
      await _updateApplicationStatusUseCase(applicationId, status);

      // Reload applications for the current job offer
      if (selectedJobOfferId.value.isNotEmpty) {
        await loadApplicationsForJob(selectedJobOfferId.value);
      }

      Get.snackbar('Success', 'Application status updated successfully!');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update application status: $e');
    }
  }

  void clearJobOfferForm() {
    jobTitle.value = '';
    jobLocation.value = '';
    jobContractType.value = '';
    jobDescription.value = '';
    jobRequirements.clear();
    jobSalaryRange.value = '';
    jobDeadline.value = DateTime.now().add(const Duration(days: 30));
  }

  void addRequirement(String requirement) {
    if (requirement.isNotEmpty) {
      jobRequirements.add(requirement);
    }
  }

  void removeRequirement(int index) {
    if (index >= 0 && index < jobRequirements.length) {
      jobRequirements.removeAt(index);
    }
  }

  void setJobOfferForm(JobOfferEntity jobOffer) {
    jobTitle.value = jobOffer.title;
    jobLocation.value = jobOffer.location;
    jobContractType.value = jobOffer.contractType;
    jobDescription.value = jobOffer.description;
    jobRequirements.value = List.from(jobOffer.requirements);
    jobSalaryRange.value = jobOffer.salaryRange ?? '';
    jobDeadline.value = jobOffer.deadline;
  }

  List<ApplicationEntity> getApplicationsForJob(String jobOfferId) {
    return applications.where((app) => app.jobOfferId == jobOfferId).toList();
  }

  int getApplicationCount(String jobOfferId) {
    return applications.where((app) => app.jobOfferId == jobOfferId).length;
  }

  int getPendingApplicationCount(String jobOfferId) {
    return applications
        .where(
          (app) =>
              app.jobOfferId == jobOfferId &&
              app.status == ApplicationStatus.pending,
        )
        .length;
  }

  void changeTab(int index) {
    currentTab.value = index;
  }

  Future<void> forceRefreshApplications() async {
    debugPrint('Force refreshing applications for HR...');
    await loadAllApplications();
  }

  // Method to refresh statistics specifically
  Future<void> refreshStatistics() async {
    // Reload job offers and applications to update statistics
    await loadJobOffers();
    await loadAllApplications();
  }

  // Getter for statistics
  Map<String, int> get statistics {
    final totalJobOffers = jobOffers.length;
    final activeJobOffers = jobOffers.where((offer) => offer.isActive).length;
    final totalApplications = applications.length;
    final hiredCandidates =
        applications
            .where((app) => app.status == ApplicationStatus.accepted)
            .length;
    final pendingApplications =
        applications
            .where((app) => app.status == ApplicationStatus.pending)
            .length;
    final rejectedApplications =
        applications
            .where((app) => app.status == ApplicationStatus.rejected)
            .length;

    return {
      'jobOffers': totalJobOffers,
      'activeOffers': activeJobOffers,
      'applications': totalApplications,
      'hired': hiredCandidates,
      'pending': pendingApplications,
      'rejected': rejectedApplications,
    };
  }
}
