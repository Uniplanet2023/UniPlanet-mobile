import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniplanet/config/statemanager_provider.dart';
import 'package:uniplanet/core/router/names.dart';
import 'package:uniplanet/core/utils/constant/job.dart';
import 'package:uniplanet/features/account/presentation/blocs/account/account_bloc.dart';
import 'package:uniplanet/features/common/presentation/widgets/custom_button.dart';
import 'package:uniplanet/features/common/presentation/widgets/custom_textfield.dart';
import 'package:uniplanet/features/upload/domain/entities/job.dart';
import 'package:uniplanet/features/upload/presentation/blocs/job/job_bloc.dart';
import 'package:uniplanet/features/upload/presentation/screens/job_industrie_page.dart';
import 'package:uniplanet/features/upload/presentation/widgets/address_selection.dart';
import 'package:uniplanet/features/upload/presentation/widgets/advertisement_type_toggle.dart';
import 'package:uniplanet/features/upload/presentation/widgets/category_selection.dart';
import 'package:uniplanet/features/upload/presentation/widgets/state_address.dart';

class JobPostForm extends StatefulWidget {
  final Function(String newType) setType;

  const JobPostForm({
    super.key,
    required this.setType,
  });

  @override
  JobPostFormState createState() => JobPostFormState();
}

class JobPostFormState extends State<JobPostForm> {
  TextEditingController titleController = TextEditingController();
  TextEditingController companyController = TextEditingController();
  TextEditingController qualificationController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController emailController =
      TextEditingController(); // For apply by email
  TextEditingController linkController =
      TextEditingController(); // For apply by link
  String applyMethod = 'Email'; // Default apply method is Email
  String? selectedJobType;
  String? selectedExperience;
  String? selectedEducation;
  String? selectedSalary;
  String? selectedJobCondition;
  String? selectedJobIndustry; // For selected industry
  List<String> selectedBenefits = [];
  List<String> selectedLanguages = [];

  String? stateAddress;
  String? city;
  String? address;
  String? zipCode;

  void setAddress({
    required String state,
    required String city,
    required String address,
    required String zipCode,
  }) {
    setState(() {
      stateAddress = state;
      this.city = city;
      this.address = address;
      this.zipCode = zipCode;
    });
  }

  // Function to show an error message
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    ));
  }

  // Validation logic
  bool _validateForm() {
    if (titleController.text.isEmpty) {
      _showError('Title cannot be empty');
      return false;
    }
    if (selectedJobIndustry == null || selectedJobIndustry!.isEmpty) {
      _showError('Job Industry must be selected');
      return false;
    }
    if (address == null || address!.isEmpty) {
      _showError('Address cannot be empty');
      return false;
    }
    if (selectedJobType == null || selectedJobType!.isEmpty) {
      _showError('Job Type must be selected');
      return false;
    }
    if (selectedExperience == null || selectedExperience!.isEmpty) {
      _showError('Experience Level must be selected');
      return false;
    }
    if (selectedEducation == null || selectedEducation!.isEmpty) {
      _showError('Education Level must be selected');
      return false;
    }
    if (selectedSalary == null || selectedSalary!.isEmpty) {
      _showError('Salary Range must be selected');
      return false;
    }
    if (emailController.text.isEmpty && linkController.text.isEmpty) {
      _showError('Either Apply through Email or Link must be provided');
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<JobBloc, JobState>(
      listener: (context, state) {
        if (state is JobPostSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Job Posted Successfully'),
            ),
          );
          Navigator.pop(context);
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          AdvertisementTypeToggle(
            type: 'Job',
            onTypeChanged: (newType) {
              widget.setType(newType);
            },
          ),
          const SizedBox(height: 10),

          // Title
          CustomTextField(
            controller: titleController,
            hintText: 'Title: Looking for a Server',
            maxLength: 100,
          ),

          // Add the box for selecting job industry
          GestureDetector(
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SelectJobIndustriesPage(),
                ),
              );
              if (result != null) {
                setState(() {
                  selectedJobIndustry = result; // Update selected job industry
                });
              }
            },
            child: Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(5),
                color: Theme.of(context).colorScheme.surface,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    selectedJobIndustry ?? 'Select Job Industry',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const Icon(Icons.arrow_forward_ios, color: Colors.grey),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Address selection
          AddressSelection(
            address: address,
            city: city,
            stateAddress: stateAddress,
            zipCode: zipCode,
            onTap: () => {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => StateSelectionPage(
                    rootFrom: AppRoutes.addProductPage,
                    setAddress: setAddress,
                  ),
                ),
              )
            },
          ),
          const SizedBox(height: 20),

          // Job Type
          const Text('Job Type',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          CategorySelection(
            type: 'Job Type',
            selectedCategory: selectedJobType ?? '',
            onCategoryChanged: (category) {
              setState(() {
                selectedJobType = category;
              });
            },
          ),
          const SizedBox(height: 20),

          // Experience Level
          const Text('Experience Level',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          DropdownButton<String>(
            isExpanded: true,
            hint: const Text('Select Experience'),
            value: selectedExperience,
            onChanged: (value) {
              setState(() {
                selectedExperience = value;
              });
            },
            items: JobConstant.jobExperience.map((experience) {
              return DropdownMenuItem<String>(
                value: experience,
                child: Text(experience),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),

          // Education Level
          const Text('Education Level',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          DropdownButton<String>(
            isExpanded: true,
            hint: const Text('Select Education'),
            value: selectedEducation,
            onChanged: (value) {
              setState(() {
                selectedEducation = value;
              });
            },
            items: JobConstant.jobEducation.map((education) {
              return DropdownMenuItem<String>(
                value: education,
                child: Text(education),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),

          // Salary Range
          const Text('Salary Range',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          DropdownButton<String>(
            isExpanded: true,
            hint: const Text('Select Salary'),
            value: selectedSalary,
            onChanged: (value) {
              setState(() {
                selectedSalary = value;
              });
            },
            items: JobConstant.jobSalary.map((salary) {
              return DropdownMenuItem<String>(
                value: salary,
                child: Text(salary),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),

          // Company Description
          const Text('Company Description (Optional)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          CustomTextField(
            controller: companyController,
            hintText: 'What does your company do?',
            maxLines: 7,
            maxLength: 3000,
            keyboardType: TextInputType.multiline,
          ),
          // Qualifications
          const Text('Qualifications (Optional)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          CustomTextField(
            controller: qualificationController,
            hintText: 'List required qualifications (e.g., degree, skills)',
            maxLines: 7,
            maxLength: 3000,
            keyboardType: TextInputType.multiline,
          ),

          // Description
          const Text('Description (Optional)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          CustomTextField(
            controller: descriptionController,
            hintText: 'Add a detailed description here',
            maxLines: 7,
            maxLength: 3000,
            keyboardType: TextInputType.multiline,
          ),
          // Toggle for Apply Method
          const Text('Select Apply Method',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ChoiceChip(
                label: const Text('Email'),
                selected: applyMethod == 'Email',
                onSelected: (selected) {
                  setState(() {
                    applyMethod = 'Email';
                  });
                },
              ),
              const SizedBox(width: 10),
              ChoiceChip(
                label: const Text('Link'),
                selected: applyMethod == 'Link',
                onSelected: (selected) {
                  setState(() {
                    applyMethod = 'Link';
                  });
                },
              ),
            ],
          ),
          // Conditionally show Email or Link input based on the selection
          if (applyMethod == 'Email')
            CustomTextField(
              controller: emailController,
              hintText: 'Email to apply (example@example.com)',
              keyboardType: TextInputType.emailAddress,
              maxLength: 100,
            ),
          if (applyMethod == 'Link')
            CustomTextField(
              controller: linkController,
              hintText: 'Link to apply (https://example.com)',
              keyboardType: TextInputType.url,
              maxLength: 300,
            ),

          const SizedBox(height: 30),
          CustomButton(
            text: 'Post',
            onTap: () {
              // Perform validation before posting the job
              if (_validateForm()) {
                final jobPost = JobPost(
                  title: titleController.text,
                  companyName: getIt<AccountBloc>().state.account.user.name,
                  qualifications: qualificationController.text,
                  description: descriptionController.text,
                  jobType: selectedJobType ?? '',
                  experienceLevel: selectedExperience ?? '',
                  educationLevel: selectedEducation ?? '',
                  salary: selectedSalary ?? '',
                  jobIndustry: selectedJobIndustry ?? '',
                  companyDescription: companyController.text,
                  companyImage:
                      getIt<AccountBloc>().state.account.user.profileImage!,
                  stateAddress: stateAddress!,
                  city: city!,
                  address: address!,
                  zipCode: zipCode!,
                  applyEmail: emailController.text,
                  applyLink: linkController.text,
                );
                getIt<JobBloc>().add(PostJob(jobPost));
              }
            },
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }
}
