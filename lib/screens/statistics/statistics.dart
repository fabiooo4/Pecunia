import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pecunia/model/accounts/accounts_provider.dart';
import 'package:pecunia/model/categories/categories_provider.dart';
import 'package:pecunia/model/categories/category.dart';
import 'package:pecunia/model/transactions/transaction.dart';
import 'package:pecunia/model/transactions/transactions_provider.dart';
import 'package:pecunia/widgets/filters.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Statistics extends ConsumerStatefulWidget {
  const Statistics({Key? key}) : super(key: key);

  @override
  _StatisticsState createState() => _StatisticsState();
}

class _StatisticsState extends ConsumerState<Statistics> {
  int tappedChipindex = 0;
  List<bool> isSelected = [];

  void _onChipTapped(int index) {
    setState(() {
      tappedChipindex = index;
      // if chip is selected, toggle it, else set to true only the selected chip
      isSelected = List.generate(
        isSelected.length,
        (index) => index == tappedChipindex ? !isSelected[index] : false,
      );
      print(isSelected);
      print(tappedChipindex);
    });
  }

  @override
  Widget build(BuildContext context) {
    final transactions = ref.watch(transactionsProvider);
    final accountList = ref.watch(accountsProvider);
    final categories = ref.watch(categoriesProvider);

    if (accountList.when(
      data: (accountListdata) => accountListdata.isNotEmpty,
      loading: () => false,
      error: (error, stackTrace) => false,
    )) {
      if (isSelected.isEmpty) {
        isSelected = List.generate(
          accountList.when(
            data: (accountListdata) => accountListdata.length,
            loading: () => 0,
            error: (error, stackTrace) => 0,
          ),
          (index) => index == 0,
        );
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              const Text(
                "Choose an account",
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                    color: Colors.black),
              ),
              if (accountList.when(
                data: (accountListdata) => accountListdata.isNotEmpty,
                loading: () => false,
                error: (error, stackTrace) => false,
              )) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: SizedBox(
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            accountList.when(
                              data: (accountListdata) => accountListdata.length,
                              loading: () => 0,
                              error: (error, stackTrace) => 0,
                            ),
                            (index) {
                              final account = accountList.when(
                                data: (accountListdata) =>
                                    accountListdata[index],
                                loading: () => null,
                                error: (error, stackTrace) => null,
                              );
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                child: AnimatedScale(
                                  scale: isSelected[index] ? 1.1 : 1,
                                  duration: const Duration(milliseconds: 200),
                                  child: Filter(
                                    name: account!.name,
                                    active: isSelected[index],
                                    onTap: () => _onChipTapped(index),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
              DefaultTabController(
                length: 2,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const TabBar(
                      indicatorColor: Colors.lightGreen,
                      tabs: [
                        Tab(
                          text: "Expenses",
                        ),
                        Tab(
                          text: "Incomes",
                        ),
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.31,
                      child: TabBarView(
                        children: [
                          Center(
                            heightFactor: 1,
                            child: SfCircularChart(
                              legend: Legend(
                                isVisible: true,
                                position: LegendPosition.bottom,
                                overflowMode: LegendItemOverflowMode.wrap,
                                title: LegendTitle(
                                  text:
                                      "Tap on the legend to hide/show the series",
                                  textStyle: const TextStyle(
                                    fontSize: 9,
                                    overflow: TextOverflow.visible,
                                  ),
                                ),
                              ),
                              series: <CircularSeries>[
                                DoughnutSeries<TransactionsData, String>(
                                  animationDuration: 400,
                                  dataSource: getExpensesByCategory(
                                    transactions,
                                    categories,
                                    accountList.when(
                                      data: (accountListdata) {
                                        if (isSelected.indexWhere(
                                                (element) => element) !=
                                            -1) {
                                          return accountListdata[
                                                  tappedChipindex]
                                              .id;
                                        } else {
                                          return '';
                                        }
                                      },
                                      loading: () => '',
                                      error: (error, stackTrace) => '',
                                    ),
                                  ),
                                  xValueMapper: (TransactionsData data, _) =>
                                      data.x,
                                  yValueMapper: (TransactionsData data, _) =>
                                      data.y,
                                  innerRadius: '0%',
                                  dataLabelSettings: const DataLabelSettings(
                                    isVisible: true,
                                    labelPosition:
                                        ChartDataLabelPosition.outside,
                                    labelAlignment:
                                        ChartDataLabelAlignment.auto,
                                    labelIntersectAction:
                                        LabelIntersectAction.hide,
                                    connectorLineSettings:
                                        ConnectorLineSettings(
                                      type: ConnectorType.curve,
                                      width: 1,
                                    ),
                                  ),
                                  selectionBehavior: SelectionBehavior(
                                    enable: true,
                                    selectedOpacity: 1,
                                    unselectedOpacity: 0.8,
                                    selectedBorderColor: Colors.white,
                                    selectedBorderWidth: 5,
                                  ),
                                )
                              ],
                            ),
                          ),
                          Center(
                            heightFactor: 1,
                            child: SfCircularChart(
                              legend: Legend(
                                isVisible: true,
                                position: LegendPosition.bottom,
                                overflowMode: LegendItemOverflowMode.wrap,
                                title: LegendTitle(
                                  text:
                                      "Tap on the legend to hide/show the series",
                                  textStyle: const TextStyle(
                                    fontSize: 9,
                                    overflow: TextOverflow.visible,
                                  ),
                                ),
                              ),
                              series: <CircularSeries>[
                                DoughnutSeries<TransactionsData, String>(
                                  animationDuration: 400,
                                  dataSource: getIncomesByCategory(
                                    transactions,
                                    categories,
                                    accountList.when(
                                      data: (accountListdata) {
                                        if (isSelected.indexWhere(
                                                (element) => element) !=
                                            -1) {
                                          return accountListdata[
                                                  tappedChipindex]
                                              .id;
                                        } else {
                                          return '';
                                        }
                                      },
                                      loading: () => '',
                                      error: (error, stackTrace) => '',
                                    ),
                                  ),
                                  xValueMapper: (TransactionsData data, _) =>
                                      data.x,
                                  yValueMapper: (TransactionsData data, _) =>
                                      data.y,
                                  innerRadius: '0%',
                                  dataLabelSettings: const DataLabelSettings(
                                    isVisible: true,
                                    labelPosition:
                                        ChartDataLabelPosition.outside,
                                    labelAlignment:
                                        ChartDataLabelAlignment.auto,
                                    labelIntersectAction:
                                        LabelIntersectAction.hide,
                                    connectorLineSettings:
                                        ConnectorLineSettings(
                                      type: ConnectorType.curve,
                                      width: 1,
                                    ),
                                  ),
                                  selectionBehavior: SelectionBehavior(
                                    enable: true,
                                    selectedOpacity: 1,
                                    unselectedOpacity: 0.8,
                                    selectedBorderColor: Colors.white,
                                    selectedBorderWidth: 5,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                "Movements of ${accountList.when(
                  data: (accountListdata) {
                    if (isSelected.indexWhere((element) => element) == -1) {
                      return "everything";
                    } else {
                      return accountListdata[tappedChipindex].name;
                    }
                  },
                  loading: () => '',
                  error: (error, stackTrace) => '',
                )}",
                style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.lightGreen),
              ),
              Center(
                  heightFactor: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: SizedBox(
                        height: 300,
                        child: SfCartesianChart(
                            tooltipBehavior: TooltipBehavior(
                                enable: true,
                                canShowMarker: true,
                                format: "point.x : point.y €",
                                textStyle: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12)),
                            legend: Legend(
                              isVisible: true,
                              position: LegendPosition.bottom,
                              overflowMode: LegendItemOverflowMode.wrap,
                              title: LegendTitle(
                                text:
                                    "Tap on the legend to hide/show the series",
                                textStyle: const TextStyle(
                                  fontSize: 9,
                                  overflow: TextOverflow.visible,
                                ),
                              ),
                            ),
                            primaryXAxis: CategoryAxis(
                              isInversed: true,
                            ),
                            series: <ChartSeries>[
                              LineSeries<TransactionsData, String>(
                                  name: "Expenses",
                                  markerSettings:
                                      const MarkerSettings(isVisible: true),
                                  color: Colors.red,
                                  dataSource: getChartDataForAccountExpenses(
                                      transactions,
                                      accountList.when(
                                        data: (accountListdata) {
                                          if (isSelected.indexWhere(
                                                  (element) => element) !=
                                              -1) {
                                            return accountListdata[
                                                    tappedChipindex]
                                                .id;
                                          } else {
                                            return '';
                                          }
                                        },
                                        loading: () => '',
                                        error: (error, stackTrace) => '',
                                      )),
                                  xAxisName: "Date",
                                  xValueMapper: (TransactionsData trans, _) =>
                                      trans.x,
                                  yValueMapper: (TransactionsData trans, _) =>
                                      trans.y,
                                  dataLabelSettings: const DataLabelSettings(
                                      isVisible: true,
                                      labelAlignment:
                                          ChartDataLabelAlignment.top)),
                              LineSeries<TransactionsData, String>(
                                  name: "Incomes",
                                  markerSettings:
                                      const MarkerSettings(isVisible: true),
                                  color: Colors.green,
                                  dataSource: getChartDataForAccountIncomes(
                                      transactions,
                                      accountList.when(
                                        data: (accountListdata) {
                                          if (isSelected.indexWhere(
                                                  (element) => element) !=
                                              -1) {
                                            return accountListdata[
                                                    tappedChipindex]
                                                .id;
                                          } else {
                                            return '';
                                          }
                                        },
                                        loading: () => '',
                                        error: (error, stackTrace) => '',
                                      )),
                                  xAxisName: "Date",
                                  xValueMapper: (TransactionsData trans, _) =>
                                      trans.x,
                                  yValueMapper: (TransactionsData trans, _) =>
                                      trans.y,
                                  dataLabelSettings: const DataLabelSettings(
                                      isVisible: true,
                                      labelAlignment:
                                          ChartDataLabelAlignment.top))
                            ])),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

class TransactionsData {
  TransactionsData(this.x, this.y);
  final String x;
  late final double y;
}

List<TransactionsData> getChartDataForAccountIncomes(
    AsyncValue<List<Transaction>> transactionsData, String accountName) {
  if (transactionsData is AsyncData<List<Transaction>>) {
    final transactions = transactionsData.value;
    List<TransactionsData> chartData = [];
    for (var transaction in transactions) {
      if (accountName == '') {
        if (transaction.type == 'income') {
          chartData.add(TransactionsData(
              "${transaction.date!.day.toString()}-${transaction.date!.month.toString()}-${transaction.date!.year.toString()}",
              transaction.amount));
        }
      } else {
        if (transaction.type == 'income' &&
            transaction.account == accountName) {
          chartData.add(TransactionsData(
              "${transaction.date!.day.toString()}-${transaction.date!.month.toString()}-${transaction.date!.year.toString()}",
              transaction.amount));
        }
      }
    }
    return chartData;
  }
  return [];
}

List<TransactionsData> getChartDataForAccountExpenses(
    AsyncValue<List<Transaction>> transactionsData, String accountName) {
  if (transactionsData is AsyncData<List<Transaction>>) {
    final transactions = transactionsData.value;
    List<TransactionsData> chartData = [];
    for (var transaction in transactions) {
      if (accountName == '') {
        if (transaction.type == 'expense') {
          chartData.add(TransactionsData(
              "${transaction.date!.day.toString()}-${transaction.date!.month.toString()}-${transaction.date!.year.toString()}",
              transaction.amount));
        }
      } else {
        if (transaction.type == 'expense' &&
            transaction.account == accountName) {
          chartData.add(TransactionsData(
              "${transaction.date!.day.toString()}-${transaction.date!.month.toString()}-${transaction.date!.year.toString()}",
              transaction.amount));
        }
      }
    }
    return chartData;
  }
  return [];
}

List<TransactionsData> getExpensesByCategory(
    AsyncValue<List<Transaction>> transactionsData,
    AsyncValue<List<Category>> categoriesData,
    String accountName) {
  if (transactionsData is AsyncData<List<Transaction>> &&
      categoriesData is AsyncData<List<Category>>) {
    final transactions = transactionsData.value;
    final categories = categoriesData.value;
    List<TransactionsData> chartData = [];
    for (var transaction in transactions) {
      if (accountName == '') {
        if (transaction.type == 'expense') {
          final categoryName = categories
              .firstWhere(
                (element) => element.id == transaction.category,
              )
              .name;

          chartData.add(TransactionsData(categoryName, transaction.amount));
        }
      } else {
        if (transaction.type == 'expense' &&
            transaction.account == accountName) {
          final categoryName = categories
              .firstWhere(
                (element) => element.id == transaction.category,
              )
              .name;

          chartData.add(TransactionsData(categoryName, transaction.amount));
        }
      }
    }
    return chartData;
  }
  return [];
}

List<TransactionsData> getIncomesByCategory(
    AsyncValue<List<Transaction>> transactionsData,
    AsyncValue<List<Category>> categoriesData,
    String accountName) {
  if (transactionsData is AsyncData<List<Transaction>> &&
      categoriesData is AsyncData<List<Category>>) {
    final transactions = transactionsData.value;
    final categories = categoriesData.value;
    List<TransactionsData> chartData = [];
    for (var transaction in transactions) {
      if (accountName == '') {
        if (transaction.type == 'income') {
          final categoryName = categories
              .firstWhere(
                (element) => element.id == transaction.category,
              )
              .name;

          chartData.add(TransactionsData(categoryName, transaction.amount));
        }
      } else {
        if (transaction.type == 'income' &&
            transaction.account == accountName) {
          final categoryName = categories
              .firstWhere(
                (element) => element.id == transaction.category,
              )
              .name;

          chartData.add(TransactionsData(categoryName, transaction.amount));
        }
      }
    }
    return chartData;
  }
  return [];
}
