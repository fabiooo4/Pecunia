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
  final TooltipBehavior _tooltipBehavior = TooltipBehavior(
    enable: true,
    tooltipPosition: TooltipPosition.auto,
    canShowMarker: true,
    format: "point.y €",
    textStyle: const TextStyle(
        color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
  );

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
      if (isSelected.length !=
          accountList.when(
            data: (accountListdata) => accountListdata.length,
            loading: () => 0,
            error: (error, stackTrace) => 0,
          )) {
        isSelected = List.generate(
          accountList.when(
            data: (accountListdata) => accountListdata.length,
            loading: () => 0,
            error: (error, stackTrace) => 0,
          ),
          (index) => index == 0,
        );
      } else if (isSelected.isEmpty) {
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
                      height: MediaQuery.of(context).size.height * 0.3,
                      child: TabBarView(
                        children: [
                          Center(
                            heightFactor: 1,
                            child: SfCircularChart(
                              tooltipBehavior: _tooltipBehavior,
                              onTooltipRender: (tooltipArgs) {
                                Future.delayed(
                                  const Duration(milliseconds: 3000),
                                  () {
                                    _tooltipBehavior.hide();
                                  },
                                );
                              },
                              palette: const [
                                Color(0xFF377A39),
                                Color(0xFF204721),
                                Color(0xFF37B23B),
                                Color(0xFF127A16),
                                Color(0xFF072E08),
                              ],
                              legend: Legend(
                                isVisible: false,
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
                                  radius: '50%',
                                  animationDuration: 400,
                                  legendIconType: LegendIconType.circle,
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
                                  dataLabelSettings: DataLabelSettings(
                                    isVisible: true,
                                    labelPosition:
                                        ChartDataLabelPosition.outside,
                                    labelAlignment:
                                        ChartDataLabelAlignment.auto,
                                    labelIntersectAction:
                                        LabelIntersectAction.shift,
                                    connectorLineSettings:
                                        const ConnectorLineSettings(
                                      type: ConnectorType.curve,
                                      width: 1,
                                    ),
                                    builder: (data, point, series, pointIndex,
                                        seriesIndex) {
                                      return TextButton.icon(
                                        onPressed: null,
                                        icon: Text(
                                          data.icon!,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            color: Colors.black,
                                          ),
                                        ),
                                        label: Text(
                                          data.x,
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 12,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  selectionBehavior: SelectionBehavior(
                                    enable: false,
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
                              tooltipBehavior: _tooltipBehavior,
                              onTooltipRender: (tooltipArgs) {
                                Future.delayed(
                                  const Duration(milliseconds: 3000),
                                  () {
                                    _tooltipBehavior.hide();
                                  },
                                );
                              },
                              palette: const [
                                Color(0xFF377A39),
                                Color(0xFF204721),
                                Color(0xFF1EC723),
                                Color(0xFF127A16),
                                Color(0xFF072E08),
                              ],
                              legend: Legend(
                                isVisible: false,
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
                                  radius: '50%',
                                  animationDuration: 400,
                                  legendIconType: LegendIconType.circle,
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
                                  dataLabelSettings: DataLabelSettings(
                                    isVisible: true,
                                    labelPosition:
                                        ChartDataLabelPosition.outside,
                                    labelAlignment:
                                        ChartDataLabelAlignment.auto,
                                    labelIntersectAction:
                                        LabelIntersectAction.shift,
                                    connectorLineSettings:
                                        const ConnectorLineSettings(
                                      type: ConnectorType.curve,
                                      width: 1,
                                    ),
                                    builder: (data, point, series, pointIndex,
                                        seriesIndex) {
                                      return TextButton.icon(
                                        onPressed: null,
                                        icon: Text(
                                          data.icon!,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            color: Colors.black,
                                          ),
                                        ),
                                        label: Text(
                                          data.x,
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 12,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  selectionBehavior: SelectionBehavior(
                                    enable: false,
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
                          text: "Tap on the legend to hide/show the series",
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
                            legendIconType: LegendIconType.circle,
                            name: "Expenses",
                            markerSettings:
                                const MarkerSettings(isVisible: true),
                            color: Colors.red,
                            dataSource: getChartDataForAccountExpenses(
                                transactions,
                                accountList.when(
                                  data: (accountListdata) {
                                    if (isSelected
                                            .indexWhere((element) => element) !=
                                        -1) {
                                      return accountListdata[tappedChipindex]
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
                                labelAlignment: ChartDataLabelAlignment.top)),
                        LineSeries<TransactionsData, String>(
                            legendIconType: LegendIconType.circle,
                            name: "Incomes",
                            markerSettings:
                                const MarkerSettings(isVisible: true),
                            color: Colors.lightGreen,
                            dataSource: getChartDataForAccountIncomes(
                                transactions,
                                accountList.when(
                                  data: (accountListdata) {
                                    if (isSelected
                                            .indexWhere((element) => element) !=
                                        -1) {
                                      return accountListdata[tappedChipindex]
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
                                labelAlignment: ChartDataLabelAlignment.top))
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
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
                            data: (accountListdata) => accountListdata[index],
                            loading: () => null,
                            error: (error, stackTrace) => null,
                          );
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
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
        ],
      ),
    );
  }
}

class TransactionsData {
  TransactionsData(this.x, this.y, [this.icon]);
  final String x;
  late double y;
  final String? icon;
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
    List<TransactionsData> newChartData = [];
    for (var transaction in transactions) {
      if (accountName == '') {
        if (transaction.type == 'expense') {
          final categoryName = categories
              .firstWhere((element) => element.id == transaction.category,
                  orElse: () =>
                      Category(id: '0', name: 'No category', icon: '❔'))
              .name;
          final categoryIcon = categories
                  .firstWhere((element) => element.id == transaction.category,
                      orElse: () =>
                          Category(id: '0', name: 'No category', icon: '❔'))
                  .icon ??
              '';

          chartData.add(
              TransactionsData(categoryName, transaction.amount, categoryIcon));
        }
      } else {
        if (transaction.type == 'expense' &&
            transaction.account == accountName) {
          final categoryName = categories
              .firstWhere((element) => element.id == transaction.category,
                  orElse: () =>
                      Category(id: '0', name: 'No category', icon: '❔'))
              .name;
          final categoryIcon = categories
                  .firstWhere((element) => element.id == transaction.category,
                      orElse: () =>
                          Category(id: '0', name: 'No category', icon: '❔'))
                  .icon ??
              '';

          chartData.add(
              TransactionsData(categoryName, transaction.amount, categoryIcon));
        }
      }
    }
    for (var data in chartData) {
      // sum all the amounts of the same category and add it to the newChartData
      if (newChartData.indexWhere((element) => element.x == data.x) == -1) {
        newChartData.add(data);
      } else {
        newChartData[newChartData.indexWhere((element) => element.x == data.x)]
            .y += data.y;
      }
    }

    return newChartData;
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
    List<TransactionsData> newChartData = [];
    for (var transaction in transactions) {
      if (accountName == '') {
        if (transaction.type == 'income') {
          final categoryName = categories
              .firstWhere((element) => element.id == transaction.category,
                  orElse: () =>
                      Category(id: '0', name: 'No category', icon: '❔'))
              .name;
          final categoryIcon = categories
                  .firstWhere((element) => element.id == transaction.category,
                      orElse: () =>
                          Category(id: '0', name: 'No category', icon: '❔'))
                  .icon ??
              '❔';

          chartData.add(
              TransactionsData(categoryName, transaction.amount, categoryIcon));
        }
      } else {
        if (transaction.type == 'income' &&
            transaction.account == accountName) {
          final categoryName = categories
              .firstWhere((element) => element.id == transaction.category,
                  orElse: () =>
                      Category(id: '0', name: 'No category', icon: '❔'))
              .name;
          final categoryIcon = categories
                  .firstWhere((element) => element.id == transaction.category,
                      orElse: () =>
                          Category(id: '0', name: 'No category', icon: '❔'))
                  .icon ??
              '❔';

          chartData.add(
              TransactionsData(categoryName, transaction.amount, categoryIcon));
        }
      }
    }
    for (var data in chartData) {
      // sum all the amounts of the same category and add it to the newChartData
      if (newChartData.indexWhere((element) => element.x == data.x) == -1) {
        newChartData.add(data);
      } else {
        newChartData[newChartData.indexWhere((element) => element.x == data.x)]
            .y += data.y;
      }
    }
    return newChartData;
  }
  return [];
}
