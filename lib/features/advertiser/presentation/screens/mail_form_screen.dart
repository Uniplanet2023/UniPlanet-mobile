import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniplanet/config/statemanager_provider.dart';
import 'package:uniplanet/features/advertiser/domain/entities/advertisement.dart';
import 'package:uniplanet/features/advertiser/domain/entities/mail_request.dart';
import 'package:uniplanet/features/advertiser/presentation/blocs/mail/mail_bloc.dart';

class MailFormPage extends StatelessWidget {
  final Advertisement advertisement;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  MailFormPage({super.key, required this.advertisement});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact Support'),
      ),
      body: BlocListener<MailBloc, MailState>(
        listener: (context, state) {
          if (state is MailSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Mail sent successfully'),
              ),
            );
            Navigator.of(context).pop();
          } else if (state is MailFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Failed to send mail: ${state.message}'),
              ),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Title',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter the subject of your message',
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Description',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _descriptionController,
                maxLines: 5,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter the details of your concern',
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Handle send button press
                    getIt<MailBloc>().add(SendAdComplainMailEvent(
                      AdMailRequest(
                        title: _titleController.text,
                        description: _descriptionController.text,
                        advertisement: advertisement,
                      ),
                    ));
                  },
                  child: BlocBuilder<MailBloc, MailState>(
                    builder: (context, state) {
                      if (state is MailLoading) {
                        return const CircularProgressIndicator();
                      }
                      return const Text('Send');
                    },
                  ),
                ),
              ),
              const SizedBox(
                height: 50,
              )
            ],
          ),
        ),
      ),
    );
  }
}
