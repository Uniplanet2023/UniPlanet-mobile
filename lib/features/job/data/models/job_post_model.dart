// data/models/job_post_model.dart

import 'package:uniplanet/features/job/domain/entities/job_post.dart';

class JobPostModel extends JobPost {
  JobPostModel({
    required super.id,
    required super.title,
    required super.applyEmail,
    required super.applyLink,
    required super.company,
    required super.companyImage,
    required super.companyDescription,
    required super.qualifications,
    required super.description,
    required super.jobType,
    required super.experienceLevel,
    required super.educationLevel,
    required super.salary,
    required super.jobIndustry,
    required super.stateAddress,
    required super.city,
    required super.address,
    required super.zipCode,
    required super.companyId,
  });

  /// Factory constructor to create a `JobPostModel` from JSON (API response).
  factory JobPostModel.fromJson(Map<String, dynamic> json) {
    return JobPostModel(
      id: json['_id'],
      title: json['title'],
      applyEmail: json['applyEmail'],
      applyLink: json['applyLink'],
      companyId: json['company']['_id'] ?? '',
      company: json['company']['name'] ?? '',
      companyImage: json['company']['profileImage'] ?? '',
      companyDescription: json['companyDescription'] ?? '',
      qualifications: json['qualifications'] ?? '',
      description: json['description'] ?? '',
      jobType: json['jobType'],
      experienceLevel: json['experienceLevel'],
      educationLevel: json['educationLevel'],
      salary: json['salary'],
      jobIndustry: json['jobIndustry'],
      stateAddress: json['stateAddress'],
      city: json['city'],
      address: json['address'],
      zipCode: json['zipCode'],
    );
  }

  /// Method to convert `JobPostModel` to a JSON object.
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'applyEmail': applyEmail,
      'applyLink': applyLink,
      'companyId': companyId,
      'company': company,
      'companyImage': companyImage,
      'companyDescription': companyDescription,
      'qualifications': qualifications,
      'description': description,
      'jobType': jobType,
      'experienceLevel': experienceLevel,
      'educationLevel': educationLevel,
      'salary': salary,
      'jobIndustry': jobIndustry,
      'stateAddress': stateAddress,
      'city': city,
      'address': address,
      'zipCode': zipCode,
    };
  }

  /// Converts `JobPostModel` to the domain `JobPost` entity
  JobPost toEntity() {
    return JobPost(
      id: id,
      title: title,
      applyEmail: applyEmail,
      applyLink: applyLink,
      companyId: companyId,
      company: company,
      companyImage: companyImage,
      companyDescription: companyDescription,
      qualifications: qualifications,
      description: description,
      jobType: jobType,
      experienceLevel: experienceLevel,
      educationLevel: educationLevel,
      salary: salary,
      jobIndustry: jobIndustry,
      stateAddress: stateAddress,
      city: city,
      address: address,
      zipCode: zipCode,
    );
  }

  /// Converts a domain `JobPost` entity to a `JobPostModel`
  factory JobPostModel.fromEntity(JobPost entity) {
    return JobPostModel(
      id: entity.id,
      title: entity.title,
      applyEmail: entity.applyEmail,
      applyLink: entity.applyLink,
      companyId: entity.companyId,
      company: entity.company,
      companyImage: entity.companyImage,
      companyDescription: entity.companyDescription,
      qualifications: entity.qualifications,
      description: entity.description,
      jobType: entity.jobType,
      experienceLevel: entity.experienceLevel,
      educationLevel: entity.educationLevel,
      salary: entity.salary,
      jobIndustry: entity.jobIndustry,
      stateAddress: entity.stateAddress,
      city: entity.city,
      address: entity.address,
      zipCode: entity.zipCode,
    );
  }
}
