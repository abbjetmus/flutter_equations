import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SyncfuctionFlutterChartsPage extends StatefulWidget {
  const SyncfuctionFlutterChartsPage({Key? key}) : super(key: key);

  @override
  State<SyncfuctionFlutterChartsPage> createState() =>
      _SyncfuctionFlutterChartsPageState();
}

class _SyncfuctionFlutterChartsPageState
    extends State<SyncfuctionFlutterChartsPage> {
  late TooltipBehavior _tooltipBehavior;

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final List<SalesData> chartData = [
      SalesData('Jan', 35),
      SalesData('Feb', 28),
      SalesData('Mar', 32),
      SalesData('Apr', 32),
      SalesData('May', 40),
    ];

    return Scaffold(
      body: Center(
          child: Container(
        child: SfCartesianChart(
          primaryXAxis: CategoryAxis(),
          title: ChartTitle(text: 'Half yearly sales analysis'),
          legend: Legend(isVisible: true),
          tooltipBehavior: _tooltipBehavior,
          series: <ChartSeries>[
            LineSeries<SalesData, String>(
                dataSource: chartData,
                xValueMapper: (SalesData sales, _) {
                  return sales.month;
                },
                yValueMapper: (SalesData sales, _) => sales.sales,
                dataLabelSettings: const DataLabelSettings(isVisible: true))
          ],
        ),
      )),
    );
  }
}

class SalesData {
  SalesData(this.month, this.sales);
  final String month;
  final double sales;
}
