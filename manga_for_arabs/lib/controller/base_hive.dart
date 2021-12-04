import 'package:arabic_manga_readers/model/favorite.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';

class HiveDb {
  static Box<Favorite> basedb() => Hive.box<Favorite>("favorites");
  static Box<bool> savedfav() => Hive.box<bool>("issaved");
  static Box<bool> settings() => Hive.box<bool>("settings");
  static Box<String> readMode() => Hive.box<String>("readMode");
}
