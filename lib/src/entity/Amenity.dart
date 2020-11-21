import 'package:flutter/material.dart';

class Amenity {
  /*
  "id": 16,
  "name": "Debit cards",
  "icon": "5f316451b59b6_1597072465.png",
  "created_at": "2020-08-10 15:14:25",
  "updated_at": "2020-08-10 15:14:25",
  "translations": [
    {
      "id": 11,
      "amenities_id": 16,
      "locale": "en",
      "name": "Debit cards"
      }
    ]
   */

  int id = 0;
  String name = '';
  bool isSelected = false;

  Amenity(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    name = json['name'] ?? '';
  }

  factory Amenity.fromJSON({
    @required Map<String, dynamic> json,
  }) {
    return Amenity(json);
  }
}
