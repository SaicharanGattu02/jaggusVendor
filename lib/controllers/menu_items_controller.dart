import 'dart:convert';
import 'package:get/get.dart';
import '../models/MenuItemsModel.dart';
import '../services/api-list.dart';
import '../services/server.dart';

class MenuItemsController extends GetxController {
  Server server = Server();
  var loader = true.obs;
  var menuItems = <MenuItems>[].obs;
  var itemLoading = <int, bool>{}.obs; // Track loading state for each item

  @override
  void onInit() {
    super.onInit();
    getRestaurantMenuItems();
  }

  void getRestaurantMenuItems() async {
    try {
      loader.value = true;
      final response = await server.getRequest(endPoint: APIList.menuItems);
      if (response != null && response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        var data = MenuItemsModel.fromJson(jsonResponse);
        menuItems.assignAll(data.menuItems ?? []);
      }
    } catch (e) {
      print("Error fetching menu items: $e");
    } finally {
      loader.value = false;
    }
  }

  Future<void> submitItemStatus(int index) async {
    int itemId = menuItems[index].id ?? 0;
    if (itemId == 0) return;
    try {
      itemLoading[itemId] = true;
      itemLoading.refresh(); // Update UI to show loader
      final response = await server.postRequestWithToken(endPoint: "${APIList.menuItemsStatus}/$itemId");
      if (response != null && response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        menuItems[index].status = (menuItems[index].status == 5) ? 10 : 5; // Toggle status after API success
        menuItems.refresh();
      }
    } catch (e) {
      print("Error updating item status: $e");
    } finally {
      itemLoading[itemId] = false;
      itemLoading.refresh(); // Hide loader
    }
  }

  void toggleStatus(int index) {
    submitItemStatus(index);
  }
}