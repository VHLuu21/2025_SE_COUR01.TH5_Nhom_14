
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/theme/app_text_size.dart';

class TextSizeNotifier extends ChangeNotifier{
  static const String _prefKey = "app_text_size";
  AppTextSize _size;
  final SharedPreferences _prefs;

  TextSizeNotifier(this._size,this._prefs);
  AppTextSize get size => _size;

  Future<void> setSize(AppTextSize newSize) async{
    if(_size == newSize) return;
    _size = newSize;
    await _prefs.setString(_prefKey, newSize.asString);
    notifyListeners();
  }
  //optional helper để cập nhật từ string
  static AppTextSize loadFromPrefs(SharedPreferences prefs){
    final s = prefs.getString(_prefKey) ?? "normal";
    return appTextSizeFromString(s);
  }
}