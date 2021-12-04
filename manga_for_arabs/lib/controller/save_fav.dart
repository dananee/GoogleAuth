import 'package:arabic_manga_readers/controller/base_hive.dart';
import 'package:arabic_manga_readers/model/des_mode.dart';
import 'package:arabic_manga_readers/model/favorite.dart';
import 'package:get/get.dart';

class SaveFav extends GetxController {
  var isSaved = false;

  void saveFav(DescriptionsModel model, String id, {bool check = false}) {
    isSaved = !isSaved;
    final favbox = HiveDb.basedb();
    var favorite = Favorite(
      title: model.title,
      image: model.coverImage,
      description: model.story,
      tags: model.categories,
      rating: model.rating,
      author: model.author,
      creator: model.creator,
      state: model.state,
      release: model.release,
    );

    if (check) {
      favbox.delete(model.title);
      HiveDb.savedfav().delete(model.title);
    } else {
      HiveDb.savedfav().put(
        id,
        isSaved,
      );

      favbox.put(id, favorite);
    }

    update();
  }
}
