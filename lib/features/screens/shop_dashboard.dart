import 'package:daprot_seller/config/routes/routes_manager.dart';
import 'package:daprot_seller/config/theme/colors_manager.dart';
import 'package:daprot_seller/domain/connectivity_helper.dart';
import 'package:daprot_seller/features/screens/orders_screen.dart';
import 'package:daprot_seller/features/screens/store_view.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sizer/sizer.dart';

class ShopDashboard extends StatefulWidget {
  const ShopDashboard({super.key});

  @override
  State<ShopDashboard> createState() => _ShopDashboardState();
}

class _ShopDashboardState extends State<ShopDashboard> {
  int _selectedIndex = 0;
  final List _tabs = [
    const ShopDashboard(),
    OrdersTab(),
    MyStore(),
  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildKPICard({
    required String title,
    required String value,
    double change = 0.0, // No change by default
    IconData? icon,
  }) {
    final color = change > 0 ? Colors.green : (change < 0 ? Colors.red : null);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            if (icon != null) Icon(icon, size: 2.h, color: color),
            if (icon != null) SizedBox(width: 2.h),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(
                        fontSize: 12.sp, fontWeight: FontWeight.bold)),
                Text(value, style: TextStyle(fontSize: 20.0)),
                if (change != 0.0)
                  Text(
                    '${change.toStringAsFixed(1)}%',
                    style: TextStyle(fontSize: 12.0, color: color),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSalesChart(List<SalesData> data) {
    final List<FlSpot> salesSpots = data
        .map((salesData) => FlSpot(
            salesData.day.hashCode.toDouble(), salesData.sales.toDouble()))
        .toList();

    return SizedBox(
      height: 30.h, // Adjust chart height as needed
      child: LineChart(
        LineChartData(
          backgroundColor: Theme.of(context)
              .scaffoldBackgroundColor, // Adjust background color

          maxY: data.fold<double>(
                  0,
                  (max, salesData) => max > salesData.sales
                      ? max
                      : salesData.sales.toDouble()) +
              20,
          lineBarsData: [
            LineChartBarData(
              spots: salesSpots,
              color: Colors.blue,
              barWidth: 1.sp, // Line thickness
            ),
          ],
        ),
      ),
    );
  }

  Scaffold dashboardView(BuildContext context) {
    var salesToday = 150;
    var salesChange = 8.7;
    var newOrders = 14;

    final List<SalesData> salesData = [
      SalesData(day: 'M', sales: 120),
      SalesData(day: 'T', sales: 135),
      SalesData(day: 'W', sales: 150),
      SalesData(day: 'T', sales: 140),
      SalesData(day: 'F', sales: 110),
      SalesData(day: 'S', sales: 105),
      SalesData(day: 'S', sales: 125),
    ];

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ConnectivityHelper.naviagte(context, Routes.addNewProduct);
        },
        backgroundColor: const Color.fromARGB(232, 3, 115, 244),
        splashColor: ColorsManager.accentColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.sp),
        ),
        child: const Icon(
          Icons.add_circle,
          color: ColorsManager.whiteColor,
          size: 50,
        ),
      ),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(232, 3, 115, 244),
        title: Text(
          "Dashboard",
          style: Theme.of(context)
              .textTheme
              .bodyLarge!
              .copyWith(color: ColorsManager.whiteColor),
        ),
      ),
      body: SingleChildScrollView(
        // Wrap content in SingleChildScrollView for scrollable view on smaller screens
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildKPICard(
                    title: 'Sales Today',
                    value: salesToday.toString(),
                    change: salesChange,
                  ),
                  _buildKPICard(
                    title: 'New Orders',
                    value: newOrders.toString(),
                    icon: Icons.shopping_cart,
                    change: salesChange,
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              _buildSalesChart(salesData),
              SizedBox(height: 10.h),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart_checkout), label: "Orders"),
          BottomNavigationBarItem(icon: Icon(Icons.store), label: "Store"),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      body:
          _selectedIndex == 0 ? dashboardView(context) : _tabs[_selectedIndex],
    );
  }
}

class SalesData {
  final String day;
  final int sales;

  SalesData({required this.day, required this.sales});
}
