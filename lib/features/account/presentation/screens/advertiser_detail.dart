import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:uniplanet/config/statemanager_provider.dart';
import 'package:uniplanet/features/account/presentation/blocs/admin/admin_bloc.dart';
import 'package:uniplanet/core/utils/constant/global_variables.dart';
import 'package:uniplanet/models/advertiser.dart';

class AdvertiserDetail extends StatelessWidget {
  final Advertiser advertiser;

  const AdvertiserDetail({super.key, required this.advertiser});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Advertiser Details'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: CachedNetworkImageProvider(
                      advertiser.account.user.profileImage!),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  advertiser.account.user.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Divider(color: Colors.grey[400]),
              const SizedBox(height: 16),
              _buildInfoRow("Email", advertiser.account.user.email),
              _buildInfoRow("School", advertiser.account.user.school),
              Divider(color: Colors.grey[400]),
              _buildInfoRow(
                "Blocked",
                advertiser.account.isBlocked.toString(),
                isBlocButton: true,
                context: context,
                type: "block",
              ),
              _buildInfoRow(
                "Post Blocked",
                advertiser.account.isBlockedPost.toString(),
                isBlocButton: true,
                context: context,
                type: "post",
              ),
              _buildInfoRow(
                "Chat Blocked",
                advertiser.account.isBlockedChat.toString(),
                isBlocButton: true,
                context: context,
                type: "chat",
              ),
              Divider(color: Colors.grey[400]),
              _buildInfoRow(
                "Total Credit",
                "\$${advertiser.credit + advertiser.freeCredit - advertiser.freeCreditUsed - advertiser.creditUsed}",
              ),
              _buildInfoRow(
                "Free Credit Left",
                "\$${advertiser.freeCredit - advertiser.freeCreditUsed}",
              ),
              _buildInfoRow("Free Credit", "\$${advertiser.freeCredit}",
                  isEditCreditButton: true, context: context, type: "free"),
              _buildInfoRow(
                  "Free Credit Used", "\$${advertiser.freeCreditUsed}"),
              _buildInfoRow("Credit", "\$${advertiser.credit}",
                  isEditCreditButton: true, context: context, type: "paid"),
              _buildInfoRow("Credit Used", "\$${advertiser.creditUsed}"),
              _buildInfoRow("CPC", "\$${advertiser.costPerClick}"),
              Divider(color: Colors.grey[400]),
              _buildInfoRow("Maximum Post", advertiser.maximumPost.toString()),
              _buildInfoRow(
                  "Number of Posts", advertiser.numberOfPost.toString()),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value,
      {bool isBlocButton = false,
      bool isEditCreditButton = false,
      BuildContext? context,
      String? type}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          SizedBox(
            width: 100, // fixed width for label
            child: Text(
              label,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(
              width: 16), // space between label and value (adjust as needed
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          if (isBlocButton)
            Row(
              children: [
                OutlinedButton(
                  onPressed: () {
                    if (type == "post") {
                      if (context!.mounted) {
                        getIt<AdminBloc>().add(BlockControlEvent(
                            accountId: advertiser.account.user.id,
                            isPostBlock: true));
                      }
                    } else if (type == "chat") {
                      if (context!.mounted) {
                        getIt<AdminBloc>().add(BlockControlEvent(
                            accountId: advertiser.account.user.id,
                            isChatBlock: true));
                      }
                    } else if (type == "block") {
                      if (context!.mounted) {
                        getIt<AdminBloc>().add(BlockControlEvent(
                            accountId: advertiser.account.user.id,
                            isBlock: true));
                      }
                    }
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                    padding: const EdgeInsets.all(0),
                  ),
                  child: const Text('Block'),
                ),
                const SizedBox(width: 8),
                OutlinedButton(
                  onPressed: () {
                    // Add your unblock functionality here
                    if (type == "post") {
                      if (context!.mounted) {
                        getIt<AdminBloc>().add(BlockControlEvent(
                            accountId: advertiser.account.user.id,
                            isPostBlock: false));
                      }
                    } else if (type == "chat") {
                      if (context!.mounted) {
                        getIt<AdminBloc>().add(BlockControlEvent(
                            accountId: advertiser.account.user.id,
                            isChatBlock: false));
                      }
                    } else if (type == "block") {
                      if (context!.mounted) {
                        getIt<AdminBloc>().add(BlockControlEvent(
                            accountId: advertiser.account.user.id,
                            isBlock: false));
                      }
                    }
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.green,
                    side: const BorderSide(color: Colors.green),
                    padding: const EdgeInsets.all(0),
                  ),
                  child: const Text('Unblock'),
                ),
              ],
            ),
          if (isEditCreditButton && context != null && type != null)
            OutlinedButton(
              onPressed: () {
                _showEditCreditDialog(context, type);
              },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.all(8),
                side: const BorderSide(color: GlobalVariables.secondaryColor),
              ),
              child: const Text('Edit Credit'),
            ),
        ],
      ),
    );
  }

  void _showEditCreditDialog(BuildContext context, String type) {
    final TextEditingController creditController = TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Credit'),
          content: Form(
            key: formKey,
            child: TextFormField(
              controller: creditController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                hintText: 'How much credit do you want to increase?',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a value';
                }
                final n = double.tryParse(value);
                if (n == null) {
                  return 'Please enter a valid number';
                }
                return null;
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (formKey.currentState?.validate() == true) {
                  final double newCredit = double.parse(creditController.text);
                  if (type == "free") {
                    getIt<AdminBloc>().add(IncreaseCreditEvent(
                        accountId: advertiser.account.user.id,
                        credit: 0,
                        freeCredit: newCredit));
                  } else if (type == "paid") {
                    getIt<AdminBloc>().add(IncreaseCreditEvent(
                        accountId: advertiser.account.user.id,
                        credit: newCredit,
                        freeCredit: 0));
                  }
                  // Process the newCredit value as needed
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
