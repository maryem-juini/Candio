import 'package:equatable/equatable.dart';

enum ApplicationStatus { pending, accepted, rejected }

class ApplicationEntity extends Equatable {
  final String id;
  final String jobOfferId;
  final String candidateId;
  final String candidateName;
  final String candidateEmail;
  final String candidatePhone;
  final String? candidateCvUrl;
  final String? candidateProfilePictureUrl;
  final ApplicationStatus status;
  final DateTime appliedAt;
  final DateTime? updatedAt;

  const ApplicationEntity({
    required this.id,
    required this.jobOfferId,
    required this.candidateId,
    required this.candidateName,
    required this.candidateEmail,
    required this.candidatePhone,
    this.candidateCvUrl,
    this.candidateProfilePictureUrl,
    this.status = ApplicationStatus.pending,
    required this.appliedAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    jobOfferId,
    candidateId,
    candidateName,
    candidateEmail,
    candidatePhone,
    candidateCvUrl,
    candidateProfilePictureUrl,
    status,
    appliedAt,
    updatedAt,
  ];

  ApplicationEntity copyWith({
    String? id,
    String? jobOfferId,
    String? candidateId,
    String? candidateName,
    String? candidateEmail,
    String? candidatePhone,
    String? candidateCvUrl,
    String? candidateProfilePictureUrl,
    ApplicationStatus? status,
    DateTime? appliedAt,
    DateTime? updatedAt,
  }) {
    return ApplicationEntity(
      id: id ?? this.id,
      jobOfferId: jobOfferId ?? this.jobOfferId,
      candidateId: candidateId ?? this.candidateId,
      candidateName: candidateName ?? this.candidateName,
      candidateEmail: candidateEmail ?? this.candidateEmail,
      candidatePhone: candidatePhone ?? this.candidatePhone,
      candidateCvUrl: candidateCvUrl ?? this.candidateCvUrl,
      candidateProfilePictureUrl:
          candidateProfilePictureUrl ?? this.candidateProfilePictureUrl,
      status: status ?? this.status,
      appliedAt: appliedAt ?? this.appliedAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
