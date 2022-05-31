
// import 'package:gob_cordoba/models/user.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class LocalStorageService {

// SharedPreferences? _sharedPreferences;

// Future<void> saveUserInfo( Usuario value ) async {
//     final Usuario user = Usuario.fromJson(value);

//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     bool result = await prefs.setString('user', jsonEncode(user));
//     print(result);
//   }


//   Future<User> getUserInfo() async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();

//     Map<String, dynamic> userMap = {};
//     final String? userStr = prefs.getString('user');
//     if (userStr != null) {
//       userMap = jsonDecode(userStr) as Map<String, dynamic>;
//     }

//     final User user = User.fromJson(userMap);
//     print(user);
//     return user;
//   }


// FuturegetSharedPreferences () async
// {
//    // prefs = await SharedPreferences.getInstance();
// }


// }


// import 'package:gob_cordoba/models/user.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//  class LocalStorageService {
//    SharedPreferences? _sharedPreferences;
//     Future<LocalStorageService> init() async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     return this;
//   }


//   Usuario? get user{
// SharedPreferences prefs = await SharedPreferences.getInstance();
// prefs.setString('content', content);


//   }


//  }
