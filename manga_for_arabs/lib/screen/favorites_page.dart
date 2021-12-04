import 'package:arabic_manga_readers/controller/ads_show.dart';
import 'package:arabic_manga_readers/controller/base_hive.dart';
import 'package:arabic_manga_readers/model/favorite.dart';
import 'package:arabic_manga_readers/screen/list_chapters.dart';
import 'package:arabic_manga_readers/widgets/bottom_app_bar.dart';
import 'package:arabic_manga_readers/widgets/cached_image.dart';
import 'package:arabic_manga_readers/widgets/subtitle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
// Data base
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class FavoritePage extends StatefulWidget {
  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  late BannerAd _bottomBannerAdFav;
  bool __bottombannerloadFav = false;
  void _createadbannerFav() {
    //   // final addstate = Provider.of<ShowAds>(context);

    _bottomBannerAdFav = BannerAd(
      adUnitId: ShowAds.bannerAds,
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          setState(() {
            __bottombannerloadFav = true;
          });
          print('Ad loaded.');
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          ad.dispose();
          print('Ad failed to load: $error');
        },
        onAdOpened: (Ad ad) => print('Ad opened.'),
        onAdClosed: (Ad ad) => print('Ad closed.'),
        onAdImpression: (Ad ad) => print('Ad impression.'),
      ),
    )..load();
  }

  // FacebookBannerAd? _bannerFbAd;

  // void createFbBannerAd() {
  //   _bannerFbAd = FacebookBannerAd(
  //     placementId: ShowAds.bannerAds,
  //     bannerSize: BannerSize.STANDARD,
  //     listener: (result, value) {
  //       switch (result) {
  //         case BannerAdResult.ERROR:
  //           debugPrint("Error: $value");

  //           break;
  //         case BannerAdResult.LOADED:
  //           debugPrint("Loaded: $value");

  //           break;
  //         case BannerAdResult.CLICKED:
  //           debugPrint("Clicked: $value");
  //           break;
  //         case BannerAdResult.LOGGING_IMPRESSION:
  //           debugPrint("Logging Impression: $value");
  //           break;
  //       }
  //     },
  //   );
  // }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _createadbannerFav();
    // createFbBannerAd();
  }

  @override
  void dispose() {
    _bottomBannerAdFav.dispose();
    HiveDb.basedb().close();
    super.dispose();
  }

  Future<void> _callFavorite() async {
    await Hive.openBox<Favorite>("favorites");
    setState(() {});
  }

  @override
  void initState() {
    _callFavorite();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(ScreenUtil().setHeight(100)),
        child: Visibility(
          visible: __bottombannerloadFav,
          child: SizedBox(
              height: _bottomBannerAdFav.size.height.toDouble().h,
              width: _bottomBannerAdFav.size.width.toDouble().w,
              child: AdWidget(ad: _bottomBannerAdFav)),
        ),
      ),
      // bottomSheet: _bannerFbAd != null ? _bannerFbAd : Container(),
      bottomNavigationBar: const BottomNav(),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SizedBox(height: 20.0.h),
            Padding(
              padding: EdgeInsets.all(16.0.r),
              child: subtitle(': المانجا مفضلة ', context),
            ),
            SizedBox(height: 30.0.h),
            Expanded(
              child: ValueListenableBuilder<Box<Favorite>>(
                  valueListenable: HiveDb.basedb().listenable(),
                  builder: (context, box, _) {
                    final listfav = box.values.toList();
                    if (listfav.isNotEmpty) {
                      return ListView.builder(
                          itemCount: listfav.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(listfav[index].title),
                              subtitle: Text(listfav[index].author),
                              leading: cachedImages(
                                  image: listfav[index].image,
                                  height: 100.0.h,
                                  width: 65.0.w),
                              onTap: () {
                                Get.to(() => ChapterList(),
                                    arguments: listfav[index].title);
                              },
                              trailing: IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  box.deleteAt(index);
                                },
                              ),
                            );
                          });
                    }

                    return Center(
                      child: Text('لم تتم إضافة أي محتوى حتى الآن',
                          style: TextStyle(
                              color: Colors.grey[400], fontSize: 16.0.sp)),
                    );
                  }),
            ),
          ]),
    ));
  }
}
