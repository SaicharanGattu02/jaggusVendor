
import 'dart:convert';

import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../models/RestaurantModel.dart';
import '../services/api-list.dart';
import '../services/server.dart';

class RestaurantController extends GetxController {
  final String restaurantID; // Add restaurantID as a parameter
  Server server = Server();
  Restaurant? restaurant;
  bool loader = true;
  bool isDeliverySwitchOn = false;
  bool isPickupSwitchOn = false;

  RestaurantController(this.restaurantID); // Constructor to initialize the ID

  @override
  void onInit() {
    super.onInit();
    loader = true;
    getRestaurantDetails();
    Future.delayed(Duration(milliseconds: 10), () {
      update();
    });
  }

  getRestaurantDetails() async {
    final String endpoint = "${APIList.restaurant}$restaurantID";
    print("Fetching from: $endpoint");

    try {
      final response = await server.getRequest(endPoint: endpoint);
      print("API Response: ${response.body}");

      if (response != null && response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        print("Parsed JSON: $jsonResponse");

        var data = RestaurantModel.fromJson(jsonResponse);
        if (data.data?.restaurantData?.restaurant != null) {
          restaurant = data.data!.restaurantData!.restaurant;
          if(data.data!.restaurantData!.restaurant?.deliveryStatus==5){
            isDeliverySwitchOn=true;
          }else{
            isDeliverySwitchOn=false;
          }

          if(data.data!.restaurantData!.restaurant?.pickupStatus==5){
            isPickupSwitchOn=true;
          }else{
            isPickupSwitchOn=false;
          }
          print("Restaurant ID: ${restaurant?.id}");
        } else {
          print("Error: No restaurant data found in response");
        }
      } else {
        print("API Error: ${response?.statusCode}");
      }
    } catch (e) {
      print("Error fetching restaurant details: $e");
    } finally {
      loader = false;
      update();
    }
  }

  Future<void> getDeliveryStatus() async {
    try {
      final response = await server.getRequest(endPoint: APIList.deliveryStatus);

      if (response != null && response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        if (jsonResponse['status'] == true) {
          isDeliverySwitchOn = !isDeliverySwitchOn; // 🔹 Toggle the switch state
          update(); // 🔹 Ensures UI updates
        }
      } else {
        print("Failed to fetch deliveryStatus");
      }
    } catch (error) {
      print("Error fetching deliveryStatus: $error");
    }
  }

  Future<void> getPickuptatus() async {
    try {
      final response = await server.getRequest(endPoint: APIList.pickupStatus);

      if (response != null && response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        if (jsonResponse['status'] == true) {
          isPickupSwitchOn = !isPickupSwitchOn; // 🔹 Toggle the switch state
          update(); // 🔹 Ensures UI updates
        }
      } else {
        print("Failed to fetch deliveryStatus");
      }
    } catch (error) {
      print("Error fetching deliveryStatus: $error");
    }
  }

}