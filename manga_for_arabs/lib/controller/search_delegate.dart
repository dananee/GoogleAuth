import 'package:arabic_manga_readers/controller/get_covers.dart';
import 'package:arabic_manga_readers/model/des_mode.dart';
import 'package:arabic_manga_readers/screen/detail_screen.dart';
import 'package:arabic_manga_readers/widgets/cached_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class SearchForManga extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return GetBuilder<GetFromFirestore>(
        init: GetFromFirestore(),
        builder: (controller) {
          final stream = controller.querySearch('manga_decription', query);

          return StreamBuilder<List<DescriptionsModel>>(
            stream: stream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var docs = snapshot.data!;
                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    var model = docs[index];
                    return ListTile(
                      title: Text(docs[index].title),
                      subtitle: Text(docs[index].state),
                      onTap: () {
                        Get.to(() => const Detail(), arguments: model);
                      },
                    );
                  },
                );
              } else if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              }

              return const Center(child: CircularProgressIndicator());
            },
          );
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return GetBuilder<GetFromFirestore>(
        init: GetFromFirestore(),
        builder: (controller) {
          final stream = controller.querySearch('manga_decription', query);

          return StreamBuilder<List<DescriptionsModel>>(
            stream: stream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var docs = snapshot.data!;
                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    var model = docs[index];
                    return ListTile(
                      title: Text(docs[index].title),
                      subtitle: Text(docs[index].state),
                      leading: SizedBox(
                          width: 50,
                          height: 50,
                          child: cachedImages(
                              image: docs[index].coverImage,
                              height: 50,
                              width: 50)),
                      onTap: () {
                        Get.to(() => const Detail(), arguments: model);
                      },
                    );
                  },
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          );
        });
  }
}
