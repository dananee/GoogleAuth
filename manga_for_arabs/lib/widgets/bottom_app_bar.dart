import 'package:arabic_manga_readers/controller/search_delegate.dart';
import 'package:arabic_manga_readers/main.dart';
import 'package:arabic_manga_readers/screen/favorites_page.dart';
import 'package:arabic_manga_readers/screen/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomNav extends StatelessWidget {
  const BottomNav({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
            onPressed: () => Get.to(() => const MyHomePage()),
            icon: const Icon(Icons.home)),
        IconButton(
            onPressed: () => showSearch(
                  context: context,
                  delegate: SearchForManga(),
                ),
            icon: const Icon(Icons.search)),
        IconButton(
            onPressed: () => Get.to(() => FavoritePage()),
            icon: const Icon(Icons.bookmark)),
        IconButton(
            onPressed: () => Get.to(() => const SettingsPage()),
            icon: const Icon(Icons.settings)),
      ],
    ));
  }
}
