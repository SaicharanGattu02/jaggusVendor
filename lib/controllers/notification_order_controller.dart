import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:foodbank_marchantise_app/models/restaurant_order.dart';
import 'package:foodbank_marchantise_app/services/api-list.dart';
import 'package:foodbank_marchantise_app/services/server.dart';
import 'package:foodbank_marchantise_app/utils/theme_colors.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';

class OrderListController extends GetxController {
  Server server = Server();
  List<Order> orderList = <Order>[];
  List<Order> filteredOrderList = <Order>[]; // Filtered list
  int? len;
  bool loader = true;
  var orderId;
  bool isSwitchOn = false;

  @override
  void onInit() {
    loader = true;
    Future.delayed(Duration(milliseconds: 10), () {
      update();
    });
    getAllOrders();

    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }

  getAllOrders() async {
    server.getRequest(endPoint: APIList.notificationOrder).then((response) {
      if (response != null && response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        var orderListData = RestaurantOrder.fromJson(jsonResponse);
        orderList = <Order>[];
        orderList.addAll(orderListData.data!);
        isSwitchOn=orderListData.activeStatus??false;
        filteredOrderList = List.from(orderList); // Initially, show all
        loader = false;
        Future.delayed(Duration(milliseconds: 10), () {
          update();
        });
      } else {
        loader = false;
        Future.delayed(Duration(milliseconds: 10), () {
          update();
        });
      }
    });
  }

  Future<void> getStoreStatus() async {
    try {
      final response = await server.getRequest(endPoint: APIList.storeStatus);

      if (response != null && response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        if (jsonResponse['status'] == true) {
          isSwitchOn = !isSwitchOn; // 🔹 Toggle the switch state
          update(); // 🔹 Ensures UI updates
        }
      } else {
        print("Failed to fetch store status");
      }
    } catch (error) {
      print("Error fetching store status: $error");
    }
  }


  void filterOrders(int orderType, {String searchQuery = ''}) {
    filteredOrderList = orderList.where((order) {
      bool matchesOrderType = orderType == 0 || order.orderType == orderType;
      bool matchesSearchQuery = searchQuery.isEmpty || order.orderCode?.toLowerCase().contains(searchQuery.toLowerCase()) == true;
      return matchesOrderType && matchesSearchQuery;
    }).toList();

    update(); // Refresh UI
  }


  changeStatus(status, id) async {
    loader = true;
    print(id);
    print(">>>>>>>>>>>>>>>>Status tapped");
    var jsonMap = {
      'status': int.parse(status),
    };
    String jsonStr = jsonEncode(jsonMap);
    server
        .putRequest(
            endPoint: APIList.notificationOrderUpdateById! + id, body: jsonStr)
        .then((response) {
      final jsonResponse = json.decode(response.body);
      print(jsonResponse);
      if (response != null && response.statusCode == 200) {
        onInit();
        Future.delayed(Duration(milliseconds: 10), () {
          update();
        });
        status == "14"
            ? Fluttertoast.showToast(
                msg: "Order Accepted",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: ThemeColors.baseThemeColor,
                textColor: Colors.white,
                fontSize: 16.0)
            : status == "15"
                ? Fluttertoast.showToast(
                    msg: "Order Process",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 1,
                    backgroundColor: ThemeColors.baseThemeColor,
                    textColor: Colors.white,
                    fontSize: 16.0)
                : status == "20"
                ? Fluttertoast.showToast(
                    msg: "Order Completed",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 1,
                    backgroundColor: ThemeColors.baseThemeColor,
                    textColor: Colors.white,
                    fontSize: 16.0)
                : Fluttertoast.showToast(
                    msg: "Order Rejected",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 1,
                    backgroundColor: ThemeColors.baseThemeColor,
                    textColor: Colors.white,
                    fontSize: 16.0);
      } else {
        Get.rawSnackbar(message: 'Please');
        loader = false;
        Future.delayed(Duration(milliseconds: 10), () {
          update();
        });
      }
    });
  }
}
