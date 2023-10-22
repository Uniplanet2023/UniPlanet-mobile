import 'package:uniplanet_mobile/common/widgets/loader.dart';

// import 'package:uniplanet_mobile/features/admin/widgets/category_products_chart.dart';
// import 'package:flutter_charts/flutter_charts.dart' as charts;
import 'package:flutter/material.dart';
import 'package:uniplanet_mobile/models/sale.dart';
import 'package:uniplanet_mobile/repository/user_repo.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({Key? key}) : super(key: key);

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  int? totalSales;
  List<Sales>? earnings;

  @override
  void initState() {
    super.initState();
    getEarnings();
  }

  getEarnings() async {
    var earningData = await UserRepository().getEarnings(context);
    totalSales = earningData['totalEarnings'];
    earnings = earningData['sales'];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return earnings == null || totalSales == null
        ? const Loader()
        : Column(
            children: [
              Text(
                '\$$totalSales',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // SizedBox(
              //   height: 250,
              //   child: CategoryProductsChart(seriesList: [
              //     charts.Series(
              //       id: 'Sales',
              //       data: earnings!,
              //       domainFn: (Sales sales, _) => sales.label,
              //       measureFn: (Sales sales, _) => sales.earning,
              //     ),
              //   ]),
              // )
            ],
          );
  }
}
