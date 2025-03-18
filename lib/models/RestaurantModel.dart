class RestaurantModel {
  Data? data;

  RestaurantModel({this.data});

  factory RestaurantModel.fromJson(Map<String, dynamic> json) {
    return RestaurantModel(
      data: json['data'] != null ? Data.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data?.toJson(),
    };
  }
}

class Data {
  int? status;
  RestaurantData? restaurantData;

  Data({this.status, this.restaurantData});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      status: json['status'],
      restaurantData: json['data'] != null && json['data']['restaurant'] != null
          ? RestaurantData.fromJson(json['data'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'restaurant_data': restaurantData?.toJson(),
    };
  }
}

class RestaurantData {
  String? siteTitle;
  Restaurant? restaurant;
  List<dynamic>? timeSlots;
  List<MenuItems>? menuItems;

  RestaurantData({
    this.siteTitle,
    this.restaurant,
    this.timeSlots,
    this.menuItems,
  });

  factory RestaurantData.fromJson(Map<String, dynamic> json) {
    return RestaurantData(
      siteTitle: json['siteTitle'],
      restaurant: json['restaurant'] != null
          ? Restaurant.fromJson(json['restaurant'])
          : null,
      timeSlots: json['timeSlots'] ?? [],
      menuItems: (json['menuItems'] as List?)
          ?.map((item) => MenuItems.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'siteTitle': siteTitle,
      'restaurant': restaurant?.toJson(),
      'timeSlots': timeSlots,
      'menuItems': menuItems?.map((e) => e.toJson()).toList(),
    };
  }
}

class Restaurant {
  int? id;
  String? name;
  int? userId;
  String? description;
  String? deliveryCharge;
  String? freeDeliveryRadius;
  String? chargePerKilo;
  String? lat;
  String? long;
  String? openingTime;
  String? closingTime;
  String? address;
  int? tableStatus;
  int? deliveryStatus;
  int? pickupStatus;
  String? status;
  String? currentStatus;
  String? createdAt;
  String? updatedAt;
  String? image;
  String? logo;
  List<Cuisines>? cuisines;

  Restaurant({
    this.id,
    this.name,
    this.userId,
    this.description,
    this.deliveryCharge,
    this.freeDeliveryRadius,
    this.chargePerKilo,
    this.lat,
    this.long,
    this.openingTime,
    this.closingTime,
    this.address,
    this.tableStatus,
    this.deliveryStatus,
    this.pickupStatus,
    this.status,
    this.currentStatus,
    this.createdAt,
    this.updatedAt,
    this.image,
    this.logo,
    this.cuisines,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json['id'],
      name: json['name'],
      userId: json['user_id'],
      description: json['description'],
      deliveryCharge: json['delivery_charge'],
      freeDeliveryRadius: json['free_delivery_radius'],
      chargePerKilo: json['charge_per_kilo'],
      lat: json['lat'],
      long: json['long'],
      openingTime: json['opening_time'],
      closingTime: json['closing_time'],
      address: json['address'],
      tableStatus: json['table_status'],
      deliveryStatus: json['delivery_status'],
      pickupStatus: json['pickup_status'],
      status: json['status'],
      currentStatus: json['current_status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      image: json['image'],
      logo: json['logo'],
      cuisines: (json['cuisines'] as List?)
          ?.map((item) => Cuisines.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'user_id': userId,
      'description': description,
      'delivery_charge': deliveryCharge,
      'free_delivery_radius': freeDeliveryRadius,
      'charge_per_kilo': chargePerKilo,
      'lat': lat,
      'long': long,
      'opening_time': openingTime,
      'closing_time': closingTime,
      'address': address,
      'table_status': tableStatus,
      'delivery_status': deliveryStatus,
      'pickup_status': pickupStatus,
      'status': status,
      'current_status': currentStatus,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'image': image,
      'logo': logo,
      'cuisines': cuisines?.map((e) => e.toJson()).toList(),
    };
  }
}

class Cuisines {
  int? id;
  String? name;
  String? slug;
  String? image;
  String? description;

  Cuisines({this.id, this.name, this.slug, this.image, this.description});

  factory Cuisines.fromJson(Map<String, dynamic> json) {
    return Cuisines(
      id: json['id'],
      name: json['name'],
      slug: json['slug'],
      image: json['image'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'image': image,
      'description': description,
    };
  }
}

class MenuItems {
  int? id;
  String? name;
  String? slug;
  int? menuNumber;
  String? unitPrice;
  String? discountPrice;
  String? currencyCode;
  String? image;
  String? description;
  List<dynamic>? variations;
  List<dynamic>? options;

  MenuItems({
    this.id,
    this.name,
    this.slug,
    this.menuNumber,
    this.unitPrice,
    this.discountPrice,
    this.currencyCode,
    this.image,
    this.description,
    this.variations,
    this.options,
  });

  factory MenuItems.fromJson(Map<String, dynamic> json) {
    return MenuItems(
      id: json['id'],
      name: json['name'],
      slug: json['slug'],
      menuNumber: json['menu_number'],
      unitPrice: json['unit_price'],
      discountPrice: json['discount_price'],
      currencyCode: json['currency_code'],
      image: json['image'],
      description: json['description'],
      variations: json['variations'] ?? [],
      options: json['options'] ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'menu_number': menuNumber,
      'unit_price': unitPrice,
      'discount_price': discountPrice,
      'currency_code': currencyCode,
      'image': image,
      'description': description,
      'variations': variations,
      'options': options,
    };
  }
}

