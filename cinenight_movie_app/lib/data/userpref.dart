import 'package:shared_preferences/shared_preferences.dart';

class Userpref {
  static Future<void> saveName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("user_name", name);
  }

  static Future<String?> getName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("user_name");
  }

  static Future<void> saveId(int userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt("user_id", userId);
  }

  static Future<int?> getid() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt("user_id");
  }
}
