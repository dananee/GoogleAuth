import 'dart:io';
// import 'package:arabic_manga_readers/controller/ads_show.dart';
import 'package:arabic_manga_readers/controller/ads_show.dart';
import 'package:arabic_manga_readers/controller/get_covers.dart';
import 'package:arabic_manga_readers/main.dart';
import 'package:arabic_manga_readers/model/model.dart';
import 'package:arabic_manga_readers/screen/view_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pdf/widgets.dart' as pw;

class ChapterList extends StatefulWidget {
  const ChapterList({Key? key}) : super(key: key);

  @override
  State<ChapterList> createState() => _ChapterListState();
}

class _ChapterListState extends State<ChapterList> {
  final GetFromFirestore controller = Get.put(GetFromFirestore());
  late BannerAd _bottomBannerAdList;
  bool __bottombannerloadList = false;
  void _createadbannerList() {
    _bottomBannerAdList = BannerAd(
      adUnitId: ShowAds.bannerAds,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          setState(() {
            __bottombannerloadList = true;
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

  InterstitialAd? _chapterInitAd;

  int _initialChapterLoadAd = 0;
  void _createInterstitialAdChapter() {
    InterstitialAd.load(
      adUnitId: ShowAds.interstitialAds,
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd interad) {
          _chapterInitAd = interad;
          print('Ad loaded.');
        },
        onAdFailedToLoad: (LoadAdError error) {
          _initialChapterLoadAd++;
          _chapterInitAd = null;
          if (_initialChapterLoadAd < maxFailedLoad) {
            _createInterstitialAdChapter();
          }
          print('Ad failed to load: $error');
        },
      ),
      request: const AdRequest(),
    );
  }

  // bool _isInterstitialAdLoaded = false;
  // void _loadInterstitialAd() {
  //   FacebookInterstitialAd.loadInterstitialAd(
  //     // placementId: "YOUR_PLACEMENT_ID",
  //     placementId: ShowAds.interstitialAds,
  //     listener: (result, value) {
  //       print(">> FAN > Interstitial Ad: $result --> $value");
  //       if (result == InterstitialAdResult.LOADED)
  //         _isInterstitialAdLoaded = true;

  //       /// Once an Interstitial Ad has been dismissed and becomes invalidated,
  //       /// load a fresh Ad by calling this function.
  //       if (result == InterstitialAdResult.DISMISSED &&
  //           value["invalidated"] == true) {
  //         _isInterstitialAdLoaded = false;
  //         _loadInterstitialAd();
  //       }
  //     },
  //   );
  // }

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
    _createInterstitialAdChapter();
    _createadbannerList();
    // createFbBannerAd();
    // _loadInterstitialAd();
  }

  void showInterstitialAdChapter() {
    if (_chapterInitAd != null) {
      _chapterInitAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (InterstitialAd interad) {
          interad.dispose();
          _createInterstitialAdChapter();
        },
        onAdFailedToShowFullScreenContent:
            (InterstitialAd interad, AdError error) {
          interad.dispose();
          _createInterstitialAdChapter();
        },
      );
      _chapterInitAd?.show();
    }
  }

  @override
  dispose() {
    _chapterInitAd?.dispose();
    _bottomBannerAdList.dispose();
    super.dispose();
  }

  // _showInterstitialAd() {
  //   if (_isInterstitialAdLoaded == true)
  //     FacebookInterstitialAd.showInterstitialAd();
  //   else
  //     print("Interstial Ad not yet loaded!");
  // }

  String? paths = "";
  final pdf = pw.Document();
  // ignore: prefer_final_fields
  List<File> _mulitpleFiles = [];

  // Download images
  Future downloadImages(List<String> images, String title) async {
    List<File> files = [];
    final status = await Permission.storage.request();
    if (status.isGranted) {
      for (var url = 0; url < images.length; url++) {
        try {
          var imageId = await ImageDownloader.downloadImage(
            images[url],
            destination: AndroidDestinationType.custom(directory: 'download')
              ..inExternalFilesDir()
              ..subDirectory("$title" + "/$title" + " - $url.jpg"),
          );

          var path = await ImageDownloader.findPath(imageId!);

          files.add(File(path!));
        } catch (error) {
          print(error);
        }

        setState(() {
          _mulitpleFiles.addAll(files);
        });
      }
    } else {
      print('Permission Denied');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          // bottomSheet: Visibility(
          //   visible: __bottombannerloadList,
          //   child: SizedBox(
          //       height: _bottomBannerAdList.size.height.toDouble().h,
          //       width: _bottomBannerAdList.size.width.toDouble().w,
          //       child: AdWidget(ad: _bottomBannerAdList)),
          // ),
          //
          bottomNavigationBar: PreferredSize(
            preferredSize: Size.fromHeight(ScreenUtil().setHeight(100)),
            child: Visibility(
              visible: __bottombannerloadList,
              child: SizedBox(
                  height: _bottomBannerAdList.size.height.toDouble().h,
                  width: _bottomBannerAdList.size.width.toDouble().w,
                  child: AdWidget(ad: _bottomBannerAdList)),
            ),
          ),
          body: GetBuilder<GetFromFirestore>(
              init: GetFromFirestore(),
              builder: (controller) {
                return StreamBuilder<List<ModelChapters>>(
                    stream: controller.getalllist('manga_list', Get.arguments),
                    builder: (_, snapshot) {
                      if (snapshot.hasData) {
                        var data = snapshot.data!;
                        if (data[0].chapters.isEmpty) {
                          return const Center(
                            child: Text('No Data'),
                          );
                        }
                        return ListView.builder(
                          itemCount: data[0].chapters.length,
                          itemBuilder: (_, index) {
                            var chapters = snapshot.data![0].chapters;
                            var images = chapters[index].images;

                            return Padding(
                              padding: EdgeInsets.all(8.0.r),
                              child: ListTile(
                                  tileColor: Theme.of(context).cardColor,
                                  title: Text(chapters[index].chapterTitle),
                                  trailing: IconButton(
                                      onPressed: () async {
                                        showInterstitialAdChapter();
                                        // _showInterstitialAd();
                                        downloadImages(images,
                                            chapters[index].chapterTitle);
                                      },
                                      icon: const Icon(Icons.download)),
                                  onTap: () async {
                                    showInterstitialAdChapter();
                                    // _showInterstitialAd();
                                    Get.to(() => const ImageRead(), arguments: [
                                      images,
                                      chapters[index].chapterTitle
                                    ]);
                                  }),
                            );
                          },
                        );
                      }
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    });
              })),
    );
  }
}
