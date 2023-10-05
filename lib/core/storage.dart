// Copyright 2021-2022, Markus Näther <naem@hs-furtwangen.de>

import 'package:shared_preferences/shared_preferences.dart';

/// @class
/// Storage
///
/// @brief
/// The local storage class for saving and holding values.
/// This storage is for simple key-value pair information, if you want to
/// store files of any kind refer to the FileStorage class.
class Storage {
  /// @brief
  /// Default constructor
  Storage._privateConstructor();

  /// @brief
  /// Singleton instance
  static final Storage instance = Storage._privateConstructor();

  /// @brief
  /// Sets the value for key to value.
  setStringValue(String key, String value) async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    myPrefs.setString(key, value);
  }

  /// @brief
  /// Returns the value of key, if there is no such key an empty string
  /// will be returned.
  Future<String> getStringValue(String key) async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    return myPrefs.getString(key) ?? "";
  }

  /// @brief
  /// Sets the integer value for key.
  setIntegerValue(String key, int value) async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    myPrefs.setInt(key, value);
  }

  /// @brief
  /// Returns the integer value for key, if there is no such key 0 will
  /// be returned.
  Future<int> getIntegerValue(String key) async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    return myPrefs.getInt(key) ?? 0;
  }

  /// @brief
  /// Sets the boolean value for key.
  setBooleanValue(String key, bool value) async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    myPrefs.setBool(key, value);
  }

  /// @brief
  /// Returns the boolean value for key, if there is no such key false
  /// will be returned.
  Future<bool> getBooleanValue(String key) async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    myPrefs.reload();
    return myPrefs.getBool(key) ?? false;
  }

  /// @brief
  /// Checks whether the key exists, false if the key does not exist.
  Future<bool> containsKey(String key) async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    return myPrefs.containsKey(key);
  }

  /// @brief
  /// Removes the value associated with key from storage.
  removeValue(String key) async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    return myPrefs.remove(key);
  }

  /// @brief
  /// Clear the whole storage.
  /// Keep in mind that this will also remove all information about e.g.
  /// the server connection.
  removeAll() async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    return myPrefs.clear();
  }
}
