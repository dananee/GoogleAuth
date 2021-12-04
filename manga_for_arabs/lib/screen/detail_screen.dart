import 'package:arabic_manga_readers/controller/base_hive.dart';
import 'package:arabic_manga_readers/controller/save_fav.dart';
import 'package:arabic_manga_readers/model/des_mode.dart';
import 'package:arabic_manga_readers/screen/list_chapters.dart';
import 'package:arabic_manga_readers/screen/tags_page.dart';
import 'package:arabic_manga_readers/widgets/cached_image.dart';
import 'package:arabic_manga_readers/widgets/rating_star.dart';
import 'package:arabic_manga_readers/widgets/subtitle.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

@immutable
class Detail extends StatefulWidget {
  const Detail({Key? key}) : super(key: key);

  @override
  State<Detail> createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  FirebaseFirestore desc = FirebaseFirestore.instance;

  final SaveFav _controller = Get.put(SaveFav());
  @override
  Widget build(BuildContext context) {
    //app bar

    ///detail of book image and it's pages
    Widget topLeft(DescriptionsModel model) => Padding(
          padding: EdgeInsets.all(16.0.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              cachedImages(
                  image: model.coverImage, height: 170.h, width: 200.w),
              SizedBox(
                height: 10.h,
              ),
              ValueListenableBuilder<Box<bool>>(
                  valueListenable: HiveDb.savedfav().listenable(),
                  builder: (context, box, _) {
                    return IconButton(
                        onPressed: () {
                          _controller.saveFav(model, model.title,
                              check: box.containsKey(model.title));
                        },
                        disabledColor: Colors.white,
                        color: Colors.white,
                        highlightColor: Colors.amber,
                        icon: box.containsKey(model.title)
                            ? Icon(
                                Icons.bookmark_added,
                                size: 35.r,
                                color: Colors.amber,
                              )
                            : Icon(
                                Icons.bookmark_add_outlined,
                                size: 35.r,
                              ));
                  }),
            ],
          ),
        );

    ///detail top right
    Widget topRight(DescriptionsModel model) {
      List<Widget> tags = [];
      for (var i in model.categories) {
        i == '3asq'
            ? tags.add(Container())
            : tags.add(Padding(
                padding: EdgeInsets.all(8.0.r),
                child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      onSurface: Colors.amber,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0.r)),
                      side: BorderSide(color: Colors.amber, width: 0.8.w),
                    ),
                    onPressed: () =>
                        Get.to(() => const TagsPage(), arguments: i),
                    child:
                        Text(i, style: const TextStyle(color: Colors.white))),
              ));
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          text(model.title,
              size: 25.0, isBold: true, padding: EdgeInsets.only(top: 16.0.h)),
          Visibility(
            visible: model.state == '' ? false : true,
            child: text1(
              model.author,
              '  : مؤلف',
              color: Colors.white,
              size: 14.sp,
              isBold: true,
              padding: EdgeInsets.only(
                top: 15.0.h,
              ),
            ),
          ),
          Visibility(
            visible: model.creator == '' ? false : true,
            child: text1(
              ' ${model.creator}',
              '  : الرسام',
              color: Colors.white,
              size: 14.r,
              isRtl: false,
              isBold: true,
              padding: EdgeInsets.only(
                top: 15.0.h,
              ),
            ),
          ),
          Visibility(
            visible: model.release == '' ? false : true,
            child: text1(
              model.release,
              '   : سنة الإصدار',
              color: Colors.white,
              size: 14.r,
              isBold: true,
              padding: EdgeInsets.only(
                top: 8.0.h,
              ),
            ),
          ),
          Visibility(
            visible: model.state == '' ? false : true,
            child: text1(
              '   الحالة  :  ',
              model.state,
              color: Colors.white,
              size: 16.r,
              isRtl: true,
              isBold: true,
              padding: EdgeInsets.only(top: 8.0.h, bottom: 16.0.h),
            ),
          ),
          RatingManga(
            rating: double.parse(model.rating),
            labelVisible: false,
          ),
          SizedBox(height: 32.0.h),
          MaterialButton(
            onPressed: () {
              Get.to(() => const ChapterList(), arguments: model.title);
            },
            minWidth: 160.0.w,
            color: Colors.amber[800],
            child: text('ابدأ القراءة',
                isBold: true, color: Colors.white, size: 20.r),
          ),
          SizedBox(height: 20.0.h),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: tags,
            ),
          )
        ],
      );
    }

    Widget topContent(DescriptionsModel model) => Container(
          color: Color(0xff1d212b),
          padding: EdgeInsets.only(bottom: 16.0.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Flexible(flex: 2, child: topLeft(model)),
              Flexible(flex: 3, child: topRight(model)),
            ],
          ),
        );

    ///scrolling text description
    Widget bottomContent(DescriptionsModel model) => Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16.0.r),
            child: Visibility(
              visible: model.story.length == 0 ? false : true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  subtitle(': قصة المانجا', context),
                  Text(
                    model.story.length == 0 ? "" : model.story[0],
                    textDirection: TextDirection.rtl,
                    style: Theme.of(context).textTheme.headline3,
                  ),
                ],
              ),
            ),
          ),
        );

    DescriptionsModel model = Get.arguments;
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: <Widget>[topContent(model), bottomContent(model)],
        ),
      ),
    );
  }

  ///create text widget
  text(String data,
          {Color color = Colors.white,
          num size = 14,
          EdgeInsetsGeometry padding = EdgeInsets.zero,
          bool isBold = false}) =>
      Padding(
        padding: padding,
        child: Text(
          data,
          style: TextStyle(
              color: color,
              fontSize: size.toDouble().sp,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal),
        ),
      );

  text1(String value, String ref,
          {Color color = Colors.white,
          num size = 14,
          isRtl = false,
          EdgeInsetsGeometry padding = EdgeInsets.zero,
          bool isBold = false}) =>
      Padding(
        padding: padding,
        child: RichText(
          textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
          text: TextSpan(
              style: TextStyle(
                  color: color,
                  fontSize: size.toDouble().sp,
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal),
              children: <TextSpan>[
                TextSpan(
                    text: value,
                    style: TextStyle(
                      color: isRtl ? Colors.amber : Colors.white,
                    )),
                TextSpan(
                    text: ref,
                    style: TextStyle(
                        color: isRtl ? Colors.white : Colors.amber,
                        fontWeight: FontWeight.w700,
                        fontSize: 16.0.sp)),
              ]),
        ),
      );
}
