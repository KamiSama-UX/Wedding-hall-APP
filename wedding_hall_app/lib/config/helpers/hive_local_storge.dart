import 'package:hive/hive.dart';

import 'hive_constants.dart';

class HiveLocalStorge {
  static Set<String> boxesNames = {
    HiveConstants.mainBox,
  };

  static Future setupMainBoxHive() async {
    for (String boxName in boxesNames) {
      await Hive.openBox(boxName);
    }
  }

  static Future<void> put({
    required String boxName,
    required String key,
    required dynamic value,
  }) async {
    final box = Hive.box(boxName);
    await box.put(key, value);
  }

  static Future<dynamic> get({
    required String boxName,
    required String key,
  }) async {
    final box = Hive.box(boxName);
    return await box.get(key);
  }

  static Future<void> delete({
    required String boxName ,
    required String key,
  }) async {
    final box = Hive.box(boxName);
    return await box.delete(key);
  }

  static Future<int> clear({
    required String boxName,
  }) async {
    final box = Hive.box(boxName);
    return await box.clear();
  }
}
