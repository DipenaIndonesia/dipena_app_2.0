class LocationModel {
  final String location_country;
  final String location_city;

  LocationModel( this.location_country, this.location_city);

}

// import 'dart:convert';



// class Profile {
//   int location_id;
//   int location_user_id;
//   String location_country;
//   String location_city;

//   Profile({this.location_id = 0, this.location_user_id, this.location_country, this.location_city});

//   factory Profile.fromJson(Map<String, dynamic> map) {
//     return Profile(
//         location_id: map["location_id"], location_user_id: map["location_user_id"], location_country: map["location_country"], location_city: map["location_city"]);
//   }

//   Map<String, dynamic> toJson() {
//     return {"location_id": location_id, "location_user_id": location_user_id, "location_country": location_country, "location_city": location_city};
//   }

//   @override
//   String toString() {
//     return 'Profile{location_id: $location_id, location_user_id: $location_user_id, location_country: $location_country, location_city: $location_city}';
//   }

// }

// List<Profile> profileFromJson(String jsonData) {
//   final data = json.decode(jsonData);
//   return List<Profile>.from(data.map((item) => Profile.fromJson(item)));
// }

// String profileToJson(Profile data) {
//   final jsonData = data.toJson();
//   return json.encode(jsonData);
// }