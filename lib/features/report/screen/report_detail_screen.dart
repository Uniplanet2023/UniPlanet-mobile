import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniplanet/bloc/report/report_bloc.dart';
import 'package:uniplanet/models/user.dart';

class ReportDetailPage extends StatefulWidget {
  final String reportType;
  final User client;
  final String productId;
  const ReportDetailPage(
      {super.key,
      required this.reportType,
      required this.client,
      required this.productId});

  @override
  ReportDetailPageState createState() => ReportDetailPageState();
}

class ReportDetailPageState extends State<ReportDetailPage> {
  final TextEditingController _controller = TextEditingController();
  int _currentLength = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.reportType,
            maxLines: 2,
            style: const TextStyle(color: Colors.black, fontSize: 18)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _controller,
              maxLength: 300,
              maxLines: 5,
              onChanged: (text) {
                setState(() {
                  _currentLength = text.length;
                });
              },
              decoration: const InputDecoration(
                hintText: 'Tell us more (Character Limit 300 characters)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8.0),
            Text('$_currentLength/300',
                style: const TextStyle(color: Colors.grey)),
            const Spacer(),
            ElevatedButton(
              onPressed: _currentLength > 0
                  ? () {
                      context.read<ReportBloc>().add(ReportUserEvent(
                            description: _controller.text,
                            reportedUserId: widget.client.id,
                            reportType: widget.reportType,
                            productId: widget.productId,
                          ));
                      Navigator.of(context).pop();
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: Colors.blue,
              ),
              child: const Text('Send to the Team'),
            ),
          ],
        ),
      ),
    );
  }
}
