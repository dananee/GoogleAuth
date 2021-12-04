import 'package:hive/hive.dart';

part 'favorite.g.dart';

@HiveType(typeId: 0)
class Favorite extends HiveObject {
  Favorite({
    required this.title,
    required this.image,
    required this.description,
    required this.tags,
    required this.state,
    required this.rating,
    required this.creator,
    required this.author,
    required this.release,
  });

  @HiveField(0)
  String title;

  @HiveField(1)
  String image;

  @HiveField(2)
  List<String> description;

  @HiveField(3)
  List<String> tags;

  @HiveField(4)
  String author;

  @HiveField(5)
  String state;

  @HiveField(6)
  String rating;

  @HiveField(7)
  String creator;

  @HiveField(8)
  String release;
}
