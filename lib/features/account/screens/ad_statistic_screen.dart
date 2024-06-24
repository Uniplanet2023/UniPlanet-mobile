import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniplanet/api/repository/index.dart';
import 'package:uniplanet/bloc/advertiser/advertiser_bloc.dart';
import 'package:uniplanet/constants/global_variables.dart';
import 'package:uniplanet/features/account/widgets/bar_chart.dart';
import 'package:uniplanet/features/account/widgets/stat_card.dart';
import 'package:uniplanet/features/account/widgets/summary_widget.dart';
import 'package:uniplanet/features/account/widgets/user_list.dart';
import 'package:uniplanet/models/ad_stat.dart';
import 'package:uniplanet/models/advertiser.dart';
import 'package:uniplanet/models/click_count.dart';
import 'package:uniplanet/models/user_interaction.dart';
import 'package:url_launcher/url_launcher.dart';

class AdStatisticsScreen extends StatefulWidget {
  const AdStatisticsScreen({super.key});

  @override
  State<AdStatisticsScreen> createState() => _AdStatisticsScreenState();
}

class _AdStatisticsScreenState extends State<AdStatisticsScreen> {
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onScroll);
  }

  void _onScroll() {
    if (_controller.position.atEdge &&
            context.read<AdvertiserBloc>().state
                is! GettingUserInteractionState &&
            context.read<AdvertiserBloc>().state is! EndUserInteractionState &&
            context.read<AdvertiserBloc>().state is GotUserInteractionState ||
        context.read<AdvertiserBloc>().state is GotMoreUserInteractionState) {
      context.read<AdvertiserBloc>().add(const GetMoreUserInteractionEvent());
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onScroll);
    _controller.dispose();
    super.dispose();
  }

  void _showRedirectDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Please Read Carefully'),
          content: RichText(
            text: const TextSpan(
              children: [
                TextSpan(
                  text:
                      '1. You are about to be redirected to an external website.\n\n2. You must be purchasing the in-app advertisement service from UniPlanet Shop with the ',
                ),
                TextSpan(
                  text: 'same Email Address.\n\n',
                  style: TextStyle(color: Colors.red),
                ),
                TextSpan(
                  text: '3. It takes about ',
                ),
                TextSpan(
                  text: '10 miniutes to 1 day.\n\n',
                  style: TextStyle(color: Colors.red),
                ),
                TextSpan(
                  text:
                      '4. Please let me know if you\'re facing any issue by contacting me at ',
                ),
                TextSpan(
                  text: 'uniplanet.info@gmail.com',
                  style: TextStyle(color: Colors.red),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
              },
            ),
            TextButton(
              child: const Text('Proceed'),
              onPressed: () async {
                Navigator.of(context).pop();
                Uri url = Uri(
                    scheme: 'https',
                    host: 'buy.stripe.com',
                    path: 'eVa5mug0X9gn8368ww',
                    query:
                        'prefilled_email=${AuthRepository.email}&client_reference_id=${AuthRepository.userId}');
                if (await canLaunchUrl(url)) {
                  await launchUrl(url);
                } else {
                  throw 'Could not launch $url';
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    AdStat adStat = context.watch<AdvertiserBloc>().state.adStat;
    List<UserInteraction> userInteraction =
        context.watch<AdvertiserBloc>().state.userInteraction;
    List<ClickData> weeklySummary = adStat.recent7Days;
    Advertiser advertiser = context.read<AdvertiserBloc>().state.advertiser;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.black,
                  GlobalVariables.secondaryColor,
                ],
              ),
            ),
          ),
          SingleChildScrollView(
            controller: _controller,
            child: Column(
              children: [
                AppBar(
                  title: const Text(
                    'Ad Statistics',
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  iconTheme: const IconThemeData(
                    color: Colors.white, // Change your color here
                  ),
                ),
                SummaryWidget(advertiser: advertiser),
                const Text('Ad Statistics',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 17)),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      StatCard(
                          title: "Today\n",
                          amount: adStat.today.toString(),
                          color: Colors.blue),
                      StatCard(
                          title: "This Week",
                          amount: adStat.thisWeek.toString(),
                          color: Colors.green),
                      StatCard(
                          title: "This Month",
                          amount: adStat.thisMonth.toString(),
                          color: Colors.orange),
                      StatCard(
                          title: "This Year",
                          amount: adStat.thisYear.toString(),
                          color: Colors.red),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                const Text('User Clicks in this week',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 17)),
                const SizedBox(height: 30),
                SizedBox(
                  height: 200,
                  child: MyBarGraph(
                    weeklySummary: weeklySummary,
                  ),
                ),
                const SizedBox(height: 50),
                const Text('Users who are interested in your ads',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 17)),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: UserList(
                      userInteractionList:
                          userInteraction), // No height restriction
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          _showRedirectDialog(context);
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add_card),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
