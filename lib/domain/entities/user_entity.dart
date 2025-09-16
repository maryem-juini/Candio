import 'package:equatable/equatable.dart';
import 'experience_entity.dart';

class UserEntity extends Equatable {
  final String uid;
  final String name;
  final String email;
  final String phone;
  final String? location;
  final String? education;
  final String? experience;
  final List<ExperienceEntity> experiences;
  final String? cvUrl;
  final String? profilePictureUrl;
  final String role;
  final List<String> favorites;
  final String? entrepriseId;

  const UserEntity({
    required this.uid,
    required this.name,
    required this.email,
    required this.phone,
    this.location,
    this.education,
    this.experience,
    this.experiences = const [],
    this.cvUrl,
    this.profilePictureUrl,
    required this.role,
    this.favorites = const [],
    this.entrepriseId,
  });

  @override
  List<Object?> get props => [
    uid,
    name,
    email,
    phone,
    location,
    education,
    experience,
    experiences,
    cvUrl,
    profilePictureUrl,
    role,
    favorites,
    entrepriseId,
  ];

  UserEntity copyWith({
    String? uid,
    String? name,
    String? email,
    String? phone,
    String? location,
    String? education,
    String? experience,
    List<ExperienceEntity>? experiences,
    String? cvUrl,
    String? profilePictureUrl,
    String? role,
    List<String>? favorites,
    String? entrepriseId,
  }) {
    return UserEntity(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      location: location ?? this.location,
      education: education ?? this.education,
      experience: experience ?? this.experience,
      experiences: experiences ?? this.experiences,
      cvUrl: cvUrl ?? this.cvUrl,
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
      role: role ?? this.role,
      favorites: favorites ?? this.favorites,
      entrepriseId: entrepriseId ?? this.entrepriseId,
    );
  }
}
