import 'dart:io';

import 'package:arabic_manga_readers/controller/base_hive.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ImageRead extends StatefulWidget {
  const ImageRead({Key? key}) : super(key: key);

  @override
  State<ImageRead> createState() => _ImageReadState();
}

class _ImageReadState extends State<ImageRead> {
  @override
  initState() {
    super.initState();
    getFileImages();
    WidgetsBinding.instance!.addPostFrameCallback((_) => loadImages());
  }

  Future loadImages() async {
    await Future.wait(Get.arguments[0]
        .map((urlImage) => cacheImage(urlImage, context))
        .toList());
  }

  List<FileSystemEntity> pathImage = [];

  Future getFileImages() async {
    String title = Get.arguments[1];
    final dir = await getExternalStorageDirectory();

    final downlod = "${dir!.path}/download/$title";
    final dirPath =
        Directory(downlod).listSync(recursive: true, followLinks: false);
    //  + " - $index.jpg"
    setState(() {
      pathImage.addAll(dirPath);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder<Box<String>>(
          valueListenable: HiveDb.readMode().listenable(),
          builder: (context, box, _) {
            return PhotoViewGallery.builder(
              itemCount: pathImage.isEmpty
                  ? Get.arguments[0].length
                  : pathImage.length,
              builder: (context, index) {
                return PhotoViewGalleryPageOptions(
                  imageProvider: pathImage.length == 0
                      ? CachedNetworkImageProvider(Get.arguments[0][index])
                      : Image.file(File(pathImage[index].path)).image,
                  minScale: PhotoViewComputedScale.contained * 0.8,
                  maxScale: PhotoViewComputedScale.covered * 2,
                );
              },
              scrollPhysics: BouncingScrollPhysics(),
              reverse: false,
              scrollDirection: box.get('readMode') == 'عمودي'
                  ? Axis.vertical
                  : Axis.horizontal,
              backgroundDecoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20.r)),
                color: Theme.of(context).canvasColor,
              ),
              enableRotation: false,
              loadingBuilder: (context, event) => Center(
                child: Container(
                  width: 30.0.w,
                  height: 30.0.h,
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.orange,
                    value: event == null
                        ? 0
                        : event.cumulativeBytesLoaded /
                            event.expectedTotalBytes!,
                  ),
                ),
              ),
            );
          }),
    );
  }

  Future cacheImage(urlImage, BuildContext context) =>
      precacheImage(CachedNetworkImageProvider(urlImage), context);
}
