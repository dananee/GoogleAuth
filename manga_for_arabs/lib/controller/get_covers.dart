import 'package:arabic_manga_readers/model/des_mode.dart';
import 'package:arabic_manga_readers/model/model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class GetFromFirestore extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<List<ModelChapters>> getalllist(
      String collection, String query) async* {
    final doc = firestore
        .collection(collection)
        .where('title', isEqualTo: query)
        .snapshots();

    yield* doc.map((event) =>
        event.docs.map((model) => ModelChapters.fromMap(model)).toList());
  }

  Stream<List<DescriptionsModel>> querySearch(
      String collection, String query) async* {
    final doc = firestore
        .collection(collection)
        .where('title',
            isGreaterThanOrEqualTo: query.isNotEmpty
                ? query[0].toUpperCase() + query.substring(1)
                : "")
        .snapshots();

    yield* doc.map((event) =>
        event.docs.map((model) => DescriptionsModel.fromMap(model)).toList());
  }

  Stream<List<DescriptionsModel>> tagsSearch(
      String collection, String tag) async* {
    final doc = firestore
        .collection(collection)
        .where('categories', arrayContains: tag)
        .snapshots();

    yield* doc.map((event) =>
        event.docs.map((model) => DescriptionsModel.fromMap(model)).toList());
  }

  Stream<List<DescriptionsModel>> descriptions() async* {
    final snapshots = firestore.collection('manga_decription').snapshots();

    yield* snapshots.map((event) =>
        event.docs.map((model) => DescriptionsModel.fromMap(model)).toList());
  }
}
