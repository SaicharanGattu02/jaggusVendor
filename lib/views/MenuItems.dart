import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:foodbank_marchantise_app/controllers/menu_items_controller.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../controllers/global-controller.dart';
import '../controllers/notification_order_controller.dart';
import '../utils/theme_colors.dart';
import '../widgets/shimmer/home_page_shimmer.dart';

class MenuItems extends StatefulWidget {
  const MenuItems({super.key});

  @override
  State<MenuItems> createState() => _MenuItemsState();
}

class _MenuItemsState extends State<MenuItems> {
  final MenuItemsController menuItemsController =
      Get.put(MenuItemsController());
  final settingController = Get.put(GlobalController());
  @override
  void initState() {
    menuItemsController.onInit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: ThemeColors.baseThemeColor,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: settingController.siteName == null
            ? Text("Menu Items".tr)
            : Text(
                '${settingController.siteName}',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 25),
              ),
      ),
      body: Obx(() {
        if (menuItemsController.loader.value) {
          return Center(
              child:
                  CircularProgressIndicator()); // Show loader while fetching menu
        }
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
            itemCount: menuItemsController.menuItems.length,
            itemBuilder: (context, index) {
              final item = menuItemsController.menuItems[index];
              return Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 2,
                margin: EdgeInsets.symmetric(vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: ListTile(
                    visualDensity: VisualDensity.compact,
                    title: Text(item.name ?? '',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          height: 1,
                            fontWeight: FontWeight.bold, fontSize: 18)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 6,),
                        HtmlWidget(item.description ?? ''),
                        Text(
                          'Price: ₹${item.unitPrice ?? '0.00'}',
                          style: TextStyle(fontSize: 14,
                            height: 2,
                          ),
                        ),
                      ],
                    ),
                    trailing: Obx(() {
                      bool isLoading =
                          menuItemsController.itemLoading[item.id] ?? false;
                      return isLoading
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ) // Show loader on switch
                          : Transform.scale(
                              scale: 0.8,
                              alignment: Alignment.centerRight,
                              child: CupertinoSwitch(
                                value: item.status == 5,
                                onChanged: (bool value) {
                                  menuItemsController.toggleStatus(index);
                                },
                              ),
                            );
                    }),
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
