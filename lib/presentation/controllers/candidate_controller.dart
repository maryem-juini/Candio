import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../domain/entities/job_offer_entity.dart';
import '../../domain/entities/application_entity.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/entities/entreprise_entity.dart';
import '../../domain/usecases/job_offer_usecases.dart';
import '../../domain/usecases/application_usecases.dart';
import '../../domain/usecases/auth_usecases.dart';
import '../../domain/usecases/entreprise_usecases.dart';

class CandidateController extends GetxController {
  final GetAllJobOffersUseCase _getAllJobOffersUseCase;
  final SearchJobOffersUseCase _searchJobOffersUseCase;
  final GetApplicationsByCandidateUseCase _getApplicationsByCandidateUseCase;
  final CreateApplicationUseCase _createApplicationUseCase;
  final HasCandidateAppliedUseCase _hasCandidateAppliedUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;
  final UpdateUserFavoritesUseCase _updateUserFavoritesUseCase;
  final GetEntrepriseUseCase _getEntrepriseUseCase;

  CandidateController(
    this._getAllJobOffersUseCase,
    this._searchJobOffersUseCase,
    this._getApplicationsByCandidateUseCase,
    this._createApplicationUseCase,
    this._hasCandidateAppliedUseCase,
    this._getCurrentUserUseCase,
    this._updateUserFavoritesUseCase,
    this._getEntrepriseUseCase,
  );

  // Observable variables
  final RxList<JobOfferEntity> jobOffers = <JobOfferEntity>[].obs;
  final RxList<JobOfferEntity> filteredOffers = <JobOfferEntity>[].obs;
  final RxList<ApplicationEntity> applications = <ApplicationEntity>[].obs;
  final RxList<String> favorites = <String>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isSearching = false.obs;
  final Rx<UserEntity?> currentUser = Rx<UserEntity?>(null);

  // Enterprise cache
  final Map<String, EntrepriseEntity> _enterpriseCache = {};
  final RxInt enterpriseCacheVersion = 0.obs;

  // Search filters
  final RxString searchQuery = ''.obs;
  final RxString selectedLocation = ''.obs;
  final RxString selectedContractType = ''.obs;
  final RxString selectedCompany = ''.obs;
  final RxList<String> selectedSkills = <String>[].obs;
  final RxString selectedSalaryRange = ''.obs;
  final RxString selectedExperienceLevel = ''.obs;

  // Search debounce timer
  Timer? _searchTimer;

  // Navigation
  final RxInt currentTab = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeData();
  }

  Future<void> _initializeData() async {
    // First load the current user
    await loadCurrentUser();

    // Then load job offers and applications
    await loadJobOffers();
    await loadApplications();

    // Load enterprise data for company logos
    await loadEnterpriseData();
  }

  Future<void> loadCurrentUser() async {
    try {
      final user = await _getCurrentUserUseCase();
      currentUser.value = user;
      if (user != null) {
        favorites.value = user.favorites;
      }
    } catch (e) {
      debugPrint('Error loading current user: $e');
    }
  }

  Future<void> loadJobOffers() async {
    try {
      isLoading.value = true;
      final offers = await _getAllJobOffersUseCase();
      jobOffers.value = offers;
      filteredOffers.value = offers;
    } catch (e) {
      debugPrint('Error loading job offers: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadApplications() async {
    try {
      if (currentUser.value != null) {
        debugPrint('Loading applications for user: ${currentUser.value!.uid}');
        final apps = await _getApplicationsByCandidateUseCase(
          currentUser.value!.uid,
        );
        applications.value = apps;
        debugPrint(
          'Loaded ${apps.length} applications for user ${currentUser.value!.uid}',
        );

        // Log each application for debugging
        for (final app in apps) {
          debugPrint(
            'Application: ${app.id} - Job: ${app.jobOfferId} - Status: ${app.status}',
          );
        }
      } else {
        debugPrint('Current user is null, cannot load applications');
      }
    } catch (e) {
      debugPrint('Error loading applications: $e');
      // Don't throw the error, just log it and continue
    }
  }

  Future<void> forceRefreshApplications() async {
    debugPrint('Force refreshing applications...');
    await loadApplications();
  }

  Future<void> searchJobOffers() async {
    try {
      isSearching.value = true;
      final offers = await _searchJobOffersUseCase(
        location:
            selectedLocation.value.isNotEmpty ? selectedLocation.value : null,
        contractType:
            selectedContractType.value.isNotEmpty
                ? selectedContractType.value
                : null,
        company:
            selectedCompany.value.isNotEmpty ? selectedCompany.value : null,
        skills: selectedSkills.isNotEmpty ? selectedSkills : null,
        searchQuery: searchQuery.value.isNotEmpty ? searchQuery.value : null,
        salaryRange:
            selectedSalaryRange.value.isNotEmpty
                ? selectedSalaryRange.value
                : null,
        experienceLevel:
            selectedExperienceLevel.value.isNotEmpty
                ? selectedExperienceLevel.value
                : null,
      );
      filteredOffers.value = offers;
    } catch (e) {
      debugPrint('Error searching job offers: $e');
    } finally {
      isSearching.value = false;
    }
  }

  void onSearchQueryChanged(String query) {
    searchQuery.value = query;

    // Cancel previous timer
    _searchTimer?.cancel();

    // Set new timer for debounced search
    _searchTimer = Timer(const Duration(milliseconds: 500), () {
      if (query.isEmpty) {
        // If search is empty, show all job offers
        filteredOffers.value = jobOffers;
      } else {
        // Perform search
        searchJobOffers();
      }
    });
  }

  Future<void> applyToJob(String jobOfferId) async {
    try {
      if (currentUser.value == null) {
        Get.snackbar('Error', 'Please log in to apply for jobs');
        return;
      }

      // Find the job offer
      final jobOffer = jobOffers.firstWhereOrNull(
        (offer) => offer.id == jobOfferId,
      );
      if (jobOffer == null) {
        Get.snackbar('Error', 'Job offer not found');
        return;
      }

      // Check if already applied
      final hasApplied = await _hasCandidateAppliedUseCase(
        currentUser.value!.uid,
        jobOfferId,
      );

      if (hasApplied) {
        Get.snackbar(
          'Already Applied',
          'You have already applied to this position.',
        );
        return;
      }

      // Create application
      final application = ApplicationEntity(
        id: '',
        jobOfferId: jobOfferId,
        candidateId: currentUser.value!.uid,
        candidateName: currentUser.value!.name,
        candidateEmail: currentUser.value!.email,
        candidatePhone: currentUser.value!.phone,
        candidateCvUrl: currentUser.value!.cvUrl,
        candidateProfilePictureUrl: currentUser.value!.profilePictureUrl,
        appliedAt: DateTime.now(),
      );

      debugPrint('Creating application for job: $jobOfferId');
      await _createApplicationUseCase(application);
      debugPrint('Application created successfully');

      // Wait a moment for the database write to complete
      await Future.delayed(const Duration(milliseconds: 500));

      // Reload applications immediately
      await loadApplications();

      Get.snackbar('Success', 'Application submitted successfully!');
    } catch (e) {
      debugPrint('Error applying to job: $e');
      Get.snackbar('Error', 'Failed to submit application: $e');
    }
  }

  Future<void> toggleFavorite(String jobOfferId) async {
    try {
      if (currentUser.value == null) {
        Get.snackbar('Error', 'Please log in to save favorites');
        return;
      }

      // Toggle the favorite status
      if (favorites.contains(jobOfferId)) {
        favorites.remove(jobOfferId);
      } else {
        favorites.add(jobOfferId);
      }

      // Update user favorites in database
      await _updateUserFavoritesUseCase(currentUser.value!.uid, favorites);

      // Update the current user's favorites
      if (currentUser.value != null) {
        currentUser.value = currentUser.value!.copyWith(favorites: favorites);
      }

      Get.snackbar(
        'Success',
        favorites.contains(jobOfferId)
            ? 'Added to favorites'
            : 'Removed from favorites',
      );
    } catch (e) {
      debugPrint('Error toggling favorite: $e');
      // Revert the change if there was an error
      if (favorites.contains(jobOfferId)) {
        favorites.remove(jobOfferId);
      } else {
        favorites.add(jobOfferId);
      }
      Get.snackbar('Error', 'Failed to update favorites');
    }
  }

  bool isFavorite(String jobOfferId) {
    return favorites.contains(jobOfferId);
  }

  void clearFilters() {
    searchQuery.value = '';
    selectedLocation.value = '';
    selectedContractType.value = '';
    selectedCompany.value = '';
    selectedSkills.clear();
    selectedSalaryRange.value = '';
    selectedExperienceLevel.value = '';
    filteredOffers.value = jobOffers;
  }

  @override
  void onClose() {
    _searchTimer?.cancel();
    super.onClose();
  }

  List<JobOfferEntity> get favoriteOffers {
    return jobOffers.where((offer) => favorites.contains(offer.id)).toList();
  }

  ApplicationEntity? getApplicationForJob(String jobOfferId) {
    try {
      return applications.firstWhere((app) => app.jobOfferId == jobOfferId);
    } catch (e) {
      return null;
    }
  }

  void changeTab(int index) {
    currentTab.value = index;
  }

  Future<void> refreshAllData() async {
    await _initializeData();
  }

  // Method to refresh statistics specifically
  Future<void> refreshStatistics() async {
    // Reload applications and favorites to update statistics
    await loadApplications();
    await loadCurrentUser(); // This will refresh favorites
  }

  // Getter for statistics
  Map<String, int> get statistics {
    final totalApplications = applications.length;
    final acceptedApplications =
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
    final favoritesCount = favorites.length;

    return {
      'applications': totalApplications,
      'accepted': acceptedApplications,
      'pending': pendingApplications,
      'rejected': rejectedApplications,
      'favorites': favoritesCount,
    };
  }

  // Get enterprise by ID with caching
  EntrepriseEntity? getEnterpriseById(String enterpriseId) {
    // Return from cache if available
    if (_enterpriseCache.containsKey(enterpriseId)) {
      return _enterpriseCache[enterpriseId];
    }

    // If not in cache, trigger loading and return null
    _loadEnterpriseIfNeeded(enterpriseId);
    return null;
  }

  // Load a specific enterprise if not in cache
  Future<void> _loadEnterpriseIfNeeded(String enterpriseId) async {
    if (_enterpriseCache.containsKey(enterpriseId)) return;

    try {
      final enterprise = await _getEntrepriseUseCase(enterpriseId);
      if (enterprise != null) {
        _enterpriseCache[enterpriseId] = enterprise;
        // Trigger UI update by incrementing cache version
        enterpriseCacheVersion.value++;
      }
    } catch (e) {
      debugPrint('Error loading enterprise $enterpriseId: $e');
    }
  }

  // Load enterprise data for job offers
  Future<void> loadEnterpriseData() async {
    try {
      // Get unique enterprise IDs from job offers
      final enterpriseIds =
          jobOffers
              .map((offer) => offer.entrepriseId)
              .toSet()
              .where((id) => !_enterpriseCache.containsKey(id))
              .toList();

      // Load each enterprise
      for (final enterpriseId in enterpriseIds) {
        try {
          final enterprise = await _getEntrepriseUseCase(enterpriseId);
          if (enterprise != null) {
            _enterpriseCache[enterpriseId] = enterprise;
          }
        } catch (e) {
          debugPrint('Error loading enterprise $enterpriseId: $e');
        }
      }

      // Trigger UI update after loading all enterprises
      enterpriseCacheVersion.value++;
    } catch (e) {
      debugPrint('Error loading enterprise data: $e');
    }
  }
}
