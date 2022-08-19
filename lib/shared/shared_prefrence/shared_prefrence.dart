import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static late SharedPreferences sharedPreferences;
  static init() async {
    print('SharedPrefs');
    sharedPreferences = await SharedPreferences.getInstance();
  }

  static Future<bool> saveData({required dynamic value, required String key}) async{

    if (value is String) return await sharedPreferences.setString(key, value);
    if (value is bool) return await sharedPreferences.setBool(key, value);
    if (value is double) {
      return await  sharedPreferences.setDouble(key, value);
    } else {
      return await sharedPreferences.setInt(key, value);
    }
  }

  static dynamic getData({required String key})  {

    return sharedPreferences.get(key);
  }

  static Future<bool> removeData({required String key})
  async{
    print('Remove done');
    return await sharedPreferences.remove(key);
  }
}
