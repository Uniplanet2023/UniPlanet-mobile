import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniplanet/config/statemanager_provider.dart';
import 'package:uniplanet/features/account/presentation/blocs/account/account_bloc.dart';
import 'package:uniplanet/features/job/domain/entities/job_post.dart';
import 'package:uniplanet/features/job/presentation/blocs/job_post/job_post_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class JobListScreen extends StatefulWidget {
  const JobListScreen({super.key});

  @override
  State<JobListScreen> createState() => _JobListScreenState();
}

class _JobListScreenState extends State<JobListScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch job posts when the screen is loaded
    getIt<JobPostBloc>().add(const FetchJobPosts(1, 10));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Job Listings'),
      ),
      body: BlocBuilder<JobPostBloc, JobPostState>(
        builder: (context, state) {
          return ListView.builder(
            itemCount: state.jobPosts.length,
            itemBuilder: (context, index) {
              return JobCard(job: state.jobPosts[index]);
            },
          );
        },
      ),
    );
  }
}

class JobCard extends StatelessWidget {
  final JobPost job;

  const JobCard({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      color: Theme.of(context).colorScheme.secondaryFixedDim,
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Job Title, Company, and Job Type
            Row(
              children: [
                // Using CachedNetworkImage in CircleAvatar
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.transparent,
                  child: CachedNetworkImage(
                    imageUrl: job.companyImage,
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                    imageBuilder: (context, imageProvider) => CircleAvatar(
                      radius: 30,
                      backgroundImage: imageProvider,
                    ),
                  ),
                ),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(job.title,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      Text(job.company,
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w400)),
                      Text(
                          '${job.city}, ${job.stateAddress} (${job.jobType})', // Job Type Added
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Theme.of(context).colorScheme.tertiary)),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.bookmark_border),
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Job Industry, Salary and Email
            Row(
              children: [
                Text(
                  job.jobIndustry,
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.tertiary),
                ),
                const Spacer(),
                Text(
                  '${job.salary}/yr',
                  style: TextStyle(color: Colors.green[600]),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Footer for Easy Apply Button or Other Details
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Show the job details in a modal bottom sheet
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                      builder: (context) => DraggableScrollableSheet(
                        expand: false,
                        initialChildSize:
                            0.75, // Adjust the height to not cover full screen
                        minChildSize: 0.4,
                        maxChildSize:
                            0.90, // Max child size to allow full expansion
                        builder: (context, controller) {
                          return JobDetailBottomSheet(
                            job: job,
                            scrollController: controller,
                          );
                        },
                      ),
                    );
                  },
                  child: const Text('Job Details'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Job Detail Bottom Sheet
class JobDetailBottomSheet extends StatelessWidget {
  final JobPost job;
  final ScrollController scrollController;

  const JobDetailBottomSheet(
      {super.key, required this.job, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        controller: scrollController,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Company Logo and Title
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: Colors.transparent,
                child: CachedNetworkImage(
                  imageUrl: job.companyImage, // Company image
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                  imageBuilder: (context, imageProvider) => CircleAvatar(
                    radius: 24,
                    backgroundImage: imageProvider,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(job.title,
                        style: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold)),
                    Text(job.company,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w400)),
                    Text(
                        '${job.address}, ${job.city}, ${job.stateAddress}, ${job.zipCode}',
                        style:
                            TextStyle(fontSize: 16, color: Colors.grey[600])),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text('Salary: ${job.salary}',
              style: TextStyle(color: Colors.green[600])),
          const SizedBox(height: 10),
          // Job Type and Experience
          Wrap(
            spacing: 8,
            children: [
              Chip(label: Text(job.jobType)), // Job Type Added
              Chip(label: Text(job.experienceLevel)),
              Chip(label: Text(job.educationLevel)),
              Chip(label: Text(job.jobIndustry)),
            ],
          ),
          const SizedBox(height: 20),
          // Company Description
          const SelectableText('Company Description:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SelectableText(job.companyDescription),
          const SizedBox(height: 20),
          // Job Description
          const SelectableText('Job Description:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SelectableText(job.description),
          const SizedBox(height: 20),
          // Qualifications
          const SelectableText('Qualifications:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SelectableText(job.qualifications),
          const SizedBox(height: 20),
          // Education Level and Industry
          const SizedBox(height: 20),
          // Email and Location
          job.applyEmail != ''
              ? SelectableText('Contact: ${job.applyEmail}')
              : const SizedBox(),
          const SizedBox(height: 20),
          // Apply and Save buttons
          job.companyId == getIt<AccountBloc>().state.account.user.id
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // ElevatedButton(
                    //   onPressed: () {},
                    //   child: const Text('Edit Job'),
                    // ),
                    ElevatedButton(
                      onPressed: () {
                        // Remove the job post
                        getIt<JobPostBloc>().add(RemoveJobPost(job.id));
                        Navigator.pop(context);
                      },
                      child: const Text('Remove Job',
                          style: TextStyle(color: Colors.red)),
                    ),
                  ],
                )
              : job.applyLink != ""
                  ? ElevatedButton(
                      onPressed: () async {
                        if (await canLaunchUrl(Uri.parse(job.applyLink))) {
                          await launchUrl(Uri.parse(job.applyLink));
                        } else {
                          throw 'Could not launch ${Uri.parse(job.applyLink)}';
                        }
                      },
                      child: const Text('Apply Now'),
                    )
                  : const SizedBox(),
        ],
      ),
    );
  }
}
