import 'package:daprot_seller/config/routes/routes_manager.dart';
import 'package:daprot_seller/config/theme/colors_manager.dart';
import 'package:daprot_seller/domain/connectivity_helper.dart';
import 'package:daprot_seller/features/screens/orders_screen.dart';
import 'package:daprot_seller/features/screens/store_view.dart';
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

  Scaffold dashboardView(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.backgroundColor,
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
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: const Color.fromARGB(232, 3, 115, 244),
            title: Text(
              "Dashboard",
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(color: ColorsManager.whiteColor),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.all(8.sp),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      left: 6.sp,
                    ),
                    child: Material(
                      elevation: 2.sp,
                      child: Container(
                        height: 25.h,
                        width: 90.w,
                        decoration: BoxDecoration(
                            color: ColorsManager.whiteColor,
                            borderRadius: BorderRadius.circular(4.sp)),
                        child: Column(
                          children: [
                            Text(
                              "2",
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            Text(
                              "Running Orders",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                      color: ColorsManager.lightGreyColor,
                                      fontSize: 12.sp),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Card(),
                ],
              ),
            ),
          )
        ],
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
