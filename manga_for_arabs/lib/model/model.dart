// To parse this JSON data, do
//
//     final modelChapters = modelChaptersFromMap(jsonString);

import 'package:cloud_firestore/cloud_firestore.dart';

class ModelChapters {
  ModelChapters({
    required this.title,
    required this.chapters,
  });

  String title;
  List<Chapter> chapters;

  factory ModelChapters.fromMap(DocumentSnapshot json) => ModelChapters(
        title: json["title"],
        chapters:
            List<Chapter>.from(json["chapters"].map((x) => Chapter.fromMap(x))),
      );
}

class Chapter {
  Chapter({
    required this.chapterTitle,
    required this.images,
  });

  String chapterTitle;
  List<String> images;

  factory Chapter.fromMap(Map<String, dynamic> json) => Chapter(
        chapterTitle: json["chapter-title"],
        images: List<String>.from(json["images"].map((x) => x)),
      );
}
