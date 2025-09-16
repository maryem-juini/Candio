import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../models/entreprise_model.dart';
import '../models/job_offer_model.dart';
import '../models/application_model.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/entities/entreprise_entity.dart';
import '../../domain/entities/job_offer_entity.dart';
import '../../domain/entities/application_entity.dart';

class DataSeedingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Seeds the database with sample data for testing
  Future<void> seedDatabase() async {
    try {
      debugPrint('Starting database seeding...');

      // Create sample enterprises
      final enterprises = await _createSampleEnterprises();

      // Create sample users (candidates and HR)
      final users = await _createSampleUsers(enterprises);

      // Create sample job offers
      final jobOffers = await _createSampleJobOffers(enterprises);

      // Create sample applications
      await _createSampleApplications(users, jobOffers);

      debugPrint('Database seeding completed successfully!');
    } catch (e) {
      debugPrint('Error seeding database: $e');
    }
  }

  Future<List<EntrepriseEntity>> _createSampleEnterprises() async {
    final enterprises = [
      EntrepriseEntity(
        id: '',
        name: 'TechCorp Solutions',
        description:
            'Leading technology company specializing in mobile app development and digital solutions.',
        sector: 'Technology',
        location: 'Tunis, Tunisia',
        website: 'www.techcorp.com',
        logoUrl: null,
        createdAt: DateTime.now(),
      ),
      EntrepriseEntity(
        id: '',
        name: 'Digital Innovations',
        description:
            'Innovative digital agency focused on web development and digital marketing.',
        sector: 'Digital Marketing',
        location: 'Sfax, Tunisia',
        website: 'www.digitalinnovations.tn',
        logoUrl: null,
        createdAt: DateTime.now(),
      ),
      EntrepriseEntity(
        id: '',
        name: 'GreenTech Industries',
        description: 'Sustainable technology solutions for a greener future.',
        sector: 'Environmental Technology',
        location: 'Hammamet, Tunisia',
        website: 'www.greentech.tn',
        logoUrl: null,
        createdAt: DateTime.now(),
      ),
    ];

    final createdEnterprises = <EntrepriseEntity>[];

    for (final entreprise in enterprises) {
      final docRef = await _firestore
          .collection('entreprises')
          .add(EntrepriseModel.fromEntity(entreprise).toJson());
      createdEnterprises.add(entreprise.copyWith(id: docRef.id));
    }

    return createdEnterprises;
  }

  Future<List<UserEntity>> _createSampleUsers(
    List<EntrepriseEntity> enterprises,
  ) async {
    final users = [
      // HR Users
      UserEntity(
        uid: '',
        name: 'John Doe',
        email: 'john.doe@techcorp.com',
        phone: '+216 123 456 789',
        role: 'hr',
        entrepriseId: enterprises[0].id,
        location: 'Tunis, Tunisia',
        education: 'Master in HR Management',
        experience: '5 years in HR',
        profilePictureUrl: null,
        cvUrl: null,
        favorites: [],
      ),
      UserEntity(
        uid: '',
        name: 'Sarah Johnson',
        email: 'sarah.johnson@digitalinnovations.com',
        phone: '+216 987 654 321',
        role: 'hr',
        entrepriseId: enterprises[1].id,
        location: 'Sfax, Tunisia',
        education: 'Bachelor in Business Administration',
        experience: '3 years in HR',
        profilePictureUrl: null,
        cvUrl: null,
        favorites: [],
      ),

      // Candidate Users
      UserEntity(
        uid: '',
        name: 'Ahmed Ben Ali',
        email: 'ahmed.benali@gmail.com',
        phone: '+216 111 222 333',
        role: 'candidate',
        entrepriseId: null,
        location: 'Tunis, Tunisia',
        education: 'Master in Computer Science',
        experience: '2 years in Flutter development',
        profilePictureUrl: null,
        cvUrl: null,
        favorites: [],
      ),
      UserEntity(
        uid: '',
        name: 'Fatima Mansouri',
        email: 'fatima.mansouri@gmail.com',
        phone: '+216 444 555 666',
        role: 'candidate',
        entrepriseId: null,
        location: 'Sousse, Tunisia',
        education: 'Bachelor in Software Engineering',
        experience: '1 year in web development',
        profilePictureUrl: null,
        cvUrl: null,
        favorites: [],
      ),
      UserEntity(
        uid: '',
        name: 'Mohamed Karray',
        email: 'mohamed.karray@gmail.com',
        phone: '+216 777 888 999',
        role: 'candidate',
        entrepriseId: null,
        location: 'Monastir, Tunisia',
        education: 'Master in Information Systems',
        experience: '3 years in full-stack development',
        profilePictureUrl: null,
        cvUrl: null,
        favorites: [],
      ),
    ];

    final createdUsers = <UserEntity>[];

    for (final user in users) {
      final docRef = await _firestore
          .collection('users')
          .add(UserModel.fromEntity(user).toJson());
      createdUsers.add(user.copyWith(uid: docRef.id));
    }

    return createdUsers;
  }

  Future<List<JobOfferEntity>> _createSampleJobOffers(
    List<EntrepriseEntity> enterprises,
  ) async {
    final jobOffers = [
      JobOfferEntity(
        id: '',
        title: 'Senior Flutter Developer',
        company: enterprises[0].name,
        location: 'Tunis, Tunisia',
        contractType: 'Full-time',
        description:
            'We are looking for an experienced Flutter developer to join our mobile development team. You will be responsible for developing high-quality mobile applications using Flutter framework.',
        requirements: [
          '3+ years of experience in mobile development',
          'Strong knowledge of Flutter and Dart',
          'Experience with state management (Provider, Bloc, GetX)',
          'Knowledge of REST APIs and JSON',
          'Experience with Git version control',
          'Good understanding of mobile UI/UX principles',
        ],
        salaryRange: '4000-6000 TND',
        deadline: DateTime.now().add(const Duration(days: 30)),
        entrepriseId: enterprises[0].id,
        createdAt: DateTime.now(),
        isActive: true,
      ),
      JobOfferEntity(
        id: '',
        title: 'UI/UX Designer',
        company: enterprises[0].name,
        location: 'Tunis, Tunisia',
        contractType: 'Full-time',
        description:
            'Join our design team to create beautiful and intuitive user interfaces for our mobile and web applications.',
        requirements: [
          '2+ years of experience in UI/UX design',
          'Proficiency in Figma, Adobe XD, or Sketch',
          'Strong portfolio showcasing mobile and web designs',
          'Understanding of user-centered design principles',
          'Experience with design systems',
          'Knowledge of prototyping tools',
        ],
        salaryRange: '3000-4500 TND',
        deadline: DateTime.now().add(const Duration(days: 25)),
        entrepriseId: enterprises[0].id,
        createdAt: DateTime.now(),
        isActive: true,
      ),
      JobOfferEntity(
        id: '',
        title: 'Web Developer',
        company: enterprises[1].name,
        location: 'Sfax, Tunisia',
        contractType: 'Full-time',
        description:
            'We are seeking a talented web developer to build modern, responsive websites and web applications.',
        requirements: [
          '2+ years of experience in web development',
          'Proficiency in HTML, CSS, JavaScript',
          'Experience with React.js or Vue.js',
          'Knowledge of Node.js and Express',
          'Experience with databases (MongoDB, PostgreSQL)',
          'Understanding of responsive design',
        ],
        salaryRange: '2500-4000 TND',
        deadline: DateTime.now().add(const Duration(days: 20)),
        entrepriseId: enterprises[1].id,
        createdAt: DateTime.now(),
        isActive: true,
      ),
      JobOfferEntity(
        id: '',
        title: 'Digital Marketing Specialist',
        company: enterprises[1].name,
        location: 'Sfax, Tunisia',
        contractType: 'Part-time',
        description:
            'Help us grow our digital presence through effective marketing strategies and campaigns.',
        requirements: [
          '1+ years of experience in digital marketing',
          'Knowledge of social media platforms',
          'Experience with Google Ads and Facebook Ads',
          'Understanding of SEO principles',
          'Analytical skills and data interpretation',
          'Creative thinking and content creation',
        ],
        salaryRange: '1500-2500 TND',
        deadline: DateTime.now().add(const Duration(days: 15)),
        entrepriseId: enterprises[1].id,
        createdAt: DateTime.now(),
        isActive: true,
      ),
      JobOfferEntity(
        id: '',
        title: 'Environmental Data Analyst',
        company: enterprises[2].name,
        location: 'Hammamet, Tunisia',
        contractType: 'Full-time',
        description:
            'Join our environmental technology team to analyze data and develop sustainable solutions.',
        requirements: [
          'Master\'s degree in Environmental Science or related field',
          'Experience with data analysis tools (Python, R)',
          'Knowledge of environmental regulations',
          'Experience with GIS software',
          'Strong analytical and problem-solving skills',
          'Passion for environmental sustainability',
        ],
        salaryRange: '3500-5000 TND',
        deadline: DateTime.now().add(const Duration(days: 35)),
        entrepriseId: enterprises[2].id,
        createdAt: DateTime.now(),
        isActive: true,
      ),
    ];

    final createdJobOffers = <JobOfferEntity>[];

    for (final jobOffer in jobOffers) {
      final docRef = await _firestore
          .collection('offers')
          .add(JobOfferModel.fromEntity(jobOffer).toJson());
      createdJobOffers.add(jobOffer.copyWith(id: docRef.id));
    }

    return createdJobOffers;
  }

  Future<void> _createSampleApplications(
    List<UserEntity> users,
    List<JobOfferEntity> jobOffers,
  ) async {
    final candidates = users.where((user) => user.role == 'candidate').toList();

    final applications = [
      ApplicationEntity(
        id: '',
        jobOfferId: jobOffers[0].id, // Senior Flutter Developer
        candidateId: candidates[0].uid, // Ahmed Ben Ali
        candidateName: candidates[0].name,
        candidateEmail: candidates[0].email,
        candidatePhone: candidates[0].phone,
        candidateCvUrl: null,
        candidateProfilePictureUrl: null,
        status: ApplicationStatus.pending,
        appliedAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
      ApplicationEntity(
        id: '',
        jobOfferId: jobOffers[0].id, // Senior Flutter Developer
        candidateId: candidates[2].uid, // Mohamed Karray
        candidateName: candidates[2].name,
        candidateEmail: candidates[2].email,
        candidatePhone: candidates[2].phone,
        candidateCvUrl: null,
        candidateProfilePictureUrl: null,
        status: ApplicationStatus.accepted,
        appliedAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
      ApplicationEntity(
        id: '',
        jobOfferId: jobOffers[1].id, // UI/UX Designer
        candidateId: candidates[1].uid, // Fatima Mansouri
        candidateName: candidates[1].name,
        candidateEmail: candidates[1].email,
        candidatePhone: candidates[1].phone,
        candidateCvUrl: null,
        candidateProfilePictureUrl: null,
        status: ApplicationStatus.pending,
        appliedAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      ApplicationEntity(
        id: '',
        jobOfferId: jobOffers[2].id, // Web Developer
        candidateId: candidates[0].uid, // Ahmed Ben Ali
        candidateName: candidates[0].name,
        candidateEmail: candidates[0].email,
        candidatePhone: candidates[0].phone,
        candidateCvUrl: null,
        candidateProfilePictureUrl: null,
        status: ApplicationStatus.rejected,
        appliedAt: DateTime.now().subtract(const Duration(days: 3)),
      ),
      ApplicationEntity(
        id: '',
        jobOfferId: jobOffers[3].id, // Digital Marketing Specialist
        candidateId: candidates[1].uid, // Fatima Mansouri
        candidateName: candidates[1].name,
        candidateEmail: candidates[1].email,
        candidatePhone: candidates[1].phone,
        candidateCvUrl: null,
        candidateProfilePictureUrl: null,
        status: ApplicationStatus.pending,
        appliedAt: DateTime.now().subtract(const Duration(days: 4)),
      ),
    ];

    for (final application in applications) {
      await _firestore
          .collection('applications')
          .add(ApplicationModel.fromEntity(application).toJson());
    }
  }

  /// Clears all sample data from the database
  Future<void> clearSampleData() async {
    try {
      debugPrint('Clearing sample data...');

      // Clear applications
      final applicationsSnapshot =
          await _firestore.collection('applications').get();
      for (final doc in applicationsSnapshot.docs) {
        await doc.reference.delete();
      }

      // Clear job offers
      final jobOffersSnapshot = await _firestore.collection('offers').get();
      for (final doc in jobOffersSnapshot.docs) {
        await doc.reference.delete();
      }

      // Clear users
      final usersSnapshot = await _firestore.collection('users').get();
      for (final doc in usersSnapshot.docs) {
        await doc.reference.delete();
      }

      // Clear enterprises
      final enterprisesSnapshot =
          await _firestore.collection('entreprises').get();
      for (final doc in enterprisesSnapshot.docs) {
        await doc.reference.delete();
      }

      debugPrint('Sample data cleared successfully!');
    } catch (e) {
      debugPrint('Error clearing sample data: $e');
    }
  }
}
