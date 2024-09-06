import 'package:flutter/material.dart';
import 'package:uniplanet/core/router/names.dart';

class SetBudgetScreen extends StatefulWidget {
  final Function({required double totalPayment}) uploadAd;

  const SetBudgetScreen({super.key, required this.uploadAd});

  @override
  SetBudgetScreenState createState() => SetBudgetScreenState();
}

class SetBudgetScreenState extends State<SetBudgetScreen> {
  int _selectedBudgetIndex = 1; // Default selected index
  late String _impressionsRange;

  @override
  void initState() {
    super.initState();
    _impressionsRange = _getImpressionsRange(_selectedBudgetIndex);
  }

  String _getImpressionsRange(int index) {
    switch (index) {
      case 0:
        return '1,800 - 2,700';
      case 1:
        return '3,000 - 4,500';
      case 2:
        return '6,000 - 9,000';
      default:
        return '0 - 0';
    }
  }

  double _getBudgetAmount(int index) {
    switch (index) {
      case 0:
        return 93.0;
      case 1:
        return 155.0;
      case 2:
        return 310.0;
      default:
        return 0.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Set budget'),
        actions: [
          TextButton(
            onPressed: () {
              // Handle the next action and call the uploadAd function
              final budget = _getBudgetAmount(_selectedBudgetIndex);

              Navigator.pushNamed(
                context,
                AppRoutes.reviewPaymentPage,
                arguments: {
                  'budget': budget,
                  'impressionsRange': _impressionsRange,
                  'uploadAd': widget.uploadAd,
                },
              );
            },
            child: const Text(
              'Next',
              style: TextStyle(color: Colors.purple, fontSize: 16),
            ),
          ),
        ],
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Step 2 of 3',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 16),
            const Text(
              'Estimated monthly impressions',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 8),
            Text(
              _impressionsRange,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Recommended monthly budget',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'You will be charged on a monthly basis. Edit your ad or cancel future charges anytime.',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 24),
            _buildBudgetOption(0, '\$3', 'per day', '\$93 monthly'),
            _buildBudgetOption(1, '\$5', 'per day', '\$155 monthly',
                isRecommended: true),
            _buildBudgetOption(2, '\$10', 'per day', '\$310 monthly'),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildBudgetOption(
      int index, String amount, String perDay, String monthly,
      {bool isRecommended = false}) {
    bool isSelected = _selectedBudgetIndex == index;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        border: Border.all(
          color: isSelected ? Theme.of(context).primaryColor : Colors.grey,
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(8.0),
        color: isSelected
            ? Theme.of(context).primaryColor.withOpacity(0.1)
            : Colors.transparent,
      ),
      child: ListTile(
        title: Row(
          children: [
            Text(
              '$amount ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color:
                    isSelected ? Theme.of(context).primaryColor : Colors.black,
              ),
            ),
            Text(
              perDay,
              style: TextStyle(
                fontSize: 18,
                color:
                    isSelected ? Theme.of(context).primaryColor : Colors.black,
              ),
            ),
          ],
        ),
        subtitle: Text(
          monthly,
          style: const TextStyle(fontSize: 16, color: Colors.grey),
        ),
        trailing: isRecommended
            ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Recommended',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              )
            : null,
        onTap: () {
          setState(() {
            _selectedBudgetIndex = index;
            _impressionsRange = _getImpressionsRange(index);
          });
        },
      ),
    );
  }
}
