import '../../domain/entities/user_entity.dart';
import 'experience_model.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.uid,
    required super.name,
    required super.email,
    required super.phone,
    super.location,
    super.education,
    super.experience,
    super.experiences = const [],
    super.cvUrl,
    super.profilePictureUrl,
    required super.role,
    super.favorites = const [],
    super.entrepriseId,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      location: json['location'],
      education: json['education'],
      experience: json['experience'],
      experiences:
          (json['experiences'] as List<dynamic>?)
              ?.map((e) => ExperienceModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      cvUrl: json['cvUrl'],
      profilePictureUrl: json['profilePictureUrl'],
      role: json['role'] ?? '',
      favorites: List<String>.from(json['favorites'] ?? []),
      entrepriseId: json['entrepriseId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'phone': phone,
      'location': location,
      'education': education,
      'experience': experience,
      'experiences':
          experiences
              .map((e) => ExperienceModel.fromEntity(e).toJson())
              .toList(),
      'cvUrl': cvUrl,
      'profilePictureUrl': profilePictureUrl,
      'role': role,
      'favorites': favorites,
      'entrepriseId': entrepriseId,
    };
  }

  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      uid: entity.uid,
      name: entity.name,
      email: entity.email,
      phone: entity.phone,
      location: entity.location,
      education: entity.education,
      experience: entity.experience,
      experiences: entity.experiences,
      cvUrl: entity.cvUrl,
      profilePictureUrl: entity.profilePictureUrl,
      role: entity.role,
      favorites: entity.favorites,
      entrepriseId: entity.entrepriseId,
    );
  }

  UserEntity toEntity() {
    return UserEntity(
      uid: uid,
      name: name,
      email: email,
      phone: phone,
      location: location,
      education: education,
      experience: experience,
      experiences: experiences,
      cvUrl: cvUrl,
      profilePictureUrl: profilePictureUrl,
      role: role,
      favorites: favorites,
      entrepriseId: entrepriseId,
    );
  }
}
