import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pecunia/model/transactions/transaction.dart';
import 'package:pecunia/model/transactions/transactions_provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Statistics extends ConsumerStatefulWidget {
  const Statistics({Key? key}) : super(key: key);
  @override
  _StatisticsState createState() => _StatisticsState();
}

class _StatisticsState extends ConsumerState<Statistics> {
  @override
  Widget build(BuildContext context) {
    final transactions = ref.watch(transactionsProvider);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: const Text('Statistics'),
      ),
      body: Column(
        children: [
          Center(
              heightFactor: 1,
              child: SizedBox(
                  height: 300,
                  child: SfCartesianChart(
                      title: ChartTitle(text: 'Incomes and Expenses'),
                      legend: Legend(
                          isVisible: true,
                          position: LegendPosition.bottom,
                          overflowMode: LegendItemOverflowMode.wrap,
                          title: LegendTitle(
                              text: "Tap on the legend to hide/show the series",
                              textStyle: const TextStyle(fontSize: 9))),
                      primaryXAxis: CategoryAxis(
                        isInversed: true,
                      ),
                      series: <ChartSeries>[
                        LineSeries<TransactionsData, String>(
                            name: "Expenses",
                            markerSettings:
                                const MarkerSettings(isVisible: true),
                            onPointTap: (pointInteractionDetails) => showDialog(
                                context: context,
                                builder: (context) {
                                  int index =
                                      pointInteractionDetails.pointIndex!;
                                  return AlertDialog(
                                    title: Text(
                                        "Date: ${pointInteractionDetails.dataPoints![index].x}"),
                                    content: Text(
                                        "Amount: ${pointInteractionDetails.dataPoints![index].y}"),
                                  );
                                }),
                            color: Colors.red,
                            dataSource: getChartDataExpense(transactions),
                            xAxisName: "Date",
                            xValueMapper: (TransactionsData trans, _) =>
                                trans.x,
                            yValueMapper: (TransactionsData trans, _) =>
                                trans.y,
                            dataLabelSettings: const DataLabelSettings(
                                isVisible: true,
                                labelAlignment: ChartDataLabelAlignment.top)),
                        LineSeries<TransactionsData, String>(
                            name: "Incomes",
                            markerSettings:
                                const MarkerSettings(isVisible: true),
                            onPointTap: (pointInteractionDetails) => showDialog(
                                context: context,
                                builder: (context) {
                                  int index =
                                      pointInteractionDetails.pointIndex!;
                                  return AlertDialog(
                                    title: Text(
                                        "Date: ${pointInteractionDetails.dataPoints![index].x}"),
                                    content: Text(
                                        "Amount: ${pointInteractionDetails.dataPoints![index].y}"),
                                  );
                                }),
                            color: Colors.green,
                            dataSource: getChartDataIncome(transactions),
                            xAxisName: "Date",
                            xValueMapper: (TransactionsData trans, _) =>
                                trans.x,
                            yValueMapper: (TransactionsData trans, _) =>
                                trans.y,
                            dataLabelSettings: const DataLabelSettings(
                                isVisible: true,
                                labelAlignment: ChartDataLabelAlignment.top))
                      ]))),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class TransactionsData {
  TransactionsData(this.x, this.y);
  final String x;
  final double y;
}

List<TransactionsData> getChartDataExpense(
    AsyncValue<List<Transaction>> transactionsData) {
  if (transactionsData is AsyncData<List<Transaction>>) {
    final transactions = transactionsData.value;
    List<TransactionsData> chartData = [];
    for (var transaction in transactions) {
      if (transaction.type == 'expense') {
        chartData.add(TransactionsData(
            "${transaction.date!.day.toString()}-${transaction.date!.month.toString()}-${transaction.date!.year.toString()}",
            transaction.amount));
      }
    }
    return chartData;
  }
  return [];
}

List<TransactionsData> getChartDataIncome(
    AsyncValue<List<Transaction>> transactionsData) {
  if (transactionsData is AsyncData<List<Transaction>>) {
    final transactions = transactionsData.value;
    List<TransactionsData> chartData = [];
    for (var transaction in transactions) {
      if (transaction.type == 'income') {
        chartData.add(TransactionsData(
            "${transaction.date!.day.toString()}-${transaction.date!.month.toString()}-${transaction.date!.year.toString()}",
            transaction.amount));
      }
    }
    return chartData;
  }
  return [];
}
