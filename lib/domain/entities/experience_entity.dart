import 'package:equatable/equatable.dart';

class ExperienceEntity extends Equatable {
  final String id;
  final String jobTitle;
  final String company;
  final String description;
  final DateTime startDate;
  final DateTime? endDate;
  final bool isCurrentJob;

  const ExperienceEntity({
    required this.id,
    required this.jobTitle,
    required this.company,
    required this.description,
    required this.startDate,
    this.endDate,
    this.isCurrentJob = false,
  });

  @override
  List<Object?> get props => [
    id,
    jobTitle,
    company,
    description,
    startDate,
    endDate,
    isCurrentJob,
  ];

  ExperienceEntity copyWith({
    String? id,
    String? jobTitle,
    String? company,
    String? description,
    DateTime? startDate,
    DateTime? endDate,
    bool? isCurrentJob,
  }) {
    return ExperienceEntity(
      id: id ?? this.id,
      jobTitle: jobTitle ?? this.jobTitle,
      company: company ?? this.company,
      description: description ?? this.description,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isCurrentJob: isCurrentJob ?? this.isCurrentJob,
    );
  }
}
