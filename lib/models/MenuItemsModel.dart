class MenuItemsModel {
  bool? status;
  List<MenuItems>? menuItems;

  MenuItemsModel({this.status, this.menuItems});

  MenuItemsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['menuItems'] != null) {
      menuItems = <MenuItems>[];
      json['menuItems'].forEach((v) {
        menuItems!.add(new MenuItems.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.menuItems != null) {
      data['menuItems'] = this.menuItems!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MenuItems {
  int? id;
  String? name;
  String? description;
  String? unitPrice;
  int? status;

  MenuItems(
      {this.id, this.name, this.description, this.unitPrice, this.status});

  MenuItems.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    unitPrice = json['unit_price'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['unit_price'] = this.unitPrice;
    data['status'] = this.status;
    return data;
  }
}
