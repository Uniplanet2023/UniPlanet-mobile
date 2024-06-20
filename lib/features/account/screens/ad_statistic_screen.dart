import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

class AdStatisticsScreen extends StatefulWidget {
  const AdStatisticsScreen({super.key});

  @override
  State<AdStatisticsScreen> createState() => _AdStatisticsScreenState();
}

class _AdStatisticsScreenState extends State<AdStatisticsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AdvertiserBloc>().add(const GetAdStatisticEvent());
    context.read<AdvertiserBloc>().add(const GetUserInteractionEvent());
  }

  @override
  Widget build(BuildContext context) {
    AdStat adStat = context.watch<AdvertiserBloc>().state.adStat;
    List<UserInteraction> userInteraction =
        context.watch<AdvertiserBloc>().state.userInteraction;
    List<ClickData> weeklySummary = adStat.recent7Days;
    Advertiser advertiser = context.read<AdvertiserBloc>().state.advertiser;
    return Scaffold(
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
                          title: "This Year\n",
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
    );
  }
}
