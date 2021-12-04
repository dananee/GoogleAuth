import 'package:cloud_firestore/cloud_firestore.dart';

class DescriptionsModel {
  DescriptionsModel({
    required this.title,
    required this.rating,
    required this.author,
    required this.creator,
    required this.categories,
    required this.release,
    required this.state,
    required this.coverImage,
    required this.story,
  });

  String title;
  String rating;
  String author;
  String creator;
  List<String> categories;
  String release;
  String state;
  String coverImage;
  List<String> story;

  factory DescriptionsModel.fromMap(DocumentSnapshot json) => DescriptionsModel(
        title: json["title"] as String,
        rating: json["rating"]as String,
        author: json["author"]as String,
        creator: json["creator"]as String,
        categories: List<String>.from(json["categories"].map((x) => x)),
        release: json["release"]as String,
        state: json["state"]as String,
        coverImage: json["cover-image"]as String, 
        story: List<String>.from(json["story"].map((x) => x)),
      );
}
