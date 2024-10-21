import 'package:uniplanet/features/upload/domain/entities/job.dart';

class JobPostModel extends JobPost {
  JobPostModel({
    required super.title,
    required super.applyEmail,
    required super.applyLink,
    required super.companyName,
    required super.qualifications,
    required super.description,
    required super.jobType,
    required super.experienceLevel,
    required super.educationLevel,
    required super.salary,
    required super.jobIndustry,
    required super.companyImage,
    required super.companyDescription,
    required super.stateAddress,
    required super.city,
    required super.address,
    required super.zipCode,
  });

  factory JobPostModel.fromJson(Map<String, dynamic> json) {
    return JobPostModel(
      title: json['title'],
      applyEmail: json['applyEmail'],
      applyLink: json['applyLink'],
      companyName: json['companyName'],
      qualifications: json['qualifications'],
      description: json['description'],
      jobType: json['jobType'],
      experienceLevel: json['experienceLevel'],
      educationLevel: json['educationLevel'],
      salary: json['salary'],
      jobIndustry: json['jobIndustry'],
      companyImage: json['companyImage'],
      companyDescription: json['companyDescription'],
      stateAddress: json['stateAddress'],
      city: json['city'],
      address: json['address'],
      zipCode: json['zipCode'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'applyEmail': applyEmail,
      'applyLink': applyLink,
      'companyName': companyName,
      'qualifications': qualifications,
      'description': description,
      'jobType': jobType,
      'experienceLevel': experienceLevel,
      'educationLevel': educationLevel,
      'salary': salary,
      'jobIndustry': jobIndustry,
      'companyImage': companyImage,
      'companyDescription': companyDescription,
      'stateAddress': stateAddress,
      'city': city,
      'address': address,
      'zipCode': zipCode,
    };
  }
}
