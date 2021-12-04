import 'package:arabic_manga_readers/constants/themes_app.dart';
import 'package:arabic_manga_readers/controller/ads_show.dart';
import 'package:arabic_manga_readers/controller/base_hive.dart';
import 'package:arabic_manga_readers/controller/get_covers.dart';
import 'package:arabic_manga_readers/controller/local_notif.dart';
import 'package:arabic_manga_readers/model/des_mode.dart';
import 'package:arabic_manga_readers/model/favorite.dart';
import 'package:arabic_manga_readers/screen/detail_screen.dart';
import 'package:arabic_manga_readers/screen/tags_page.dart';
import 'package:arabic_manga_readers/widgets/bottom_app_bar.dart';
import 'package:arabic_manga_readers/widgets/cached_image.dart';
import 'package:arabic_manga_readers/widgets/rating_star.dart';
import 'package:arabic_manga_readers/widgets/search_bar.dart';
import 'package:arabic_manga_readers/widgets/subtitle.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  LocalNotif.showNotification(
      message.notification!.title!, message.notification!.body!);

  print("Handling a background message: ${message.messageId}");
}

// const String SETTINGS = 'settings';
const int maxFailedLoad = 3;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  // FacebookAudienceNetwork.init();
  final appDirectory = await getApplicationDocumentsDirectory();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  // database storage
  await Hive.initFlutter(appDirectory.path);
  await Hive.openBox<bool>('settings');
  await Hive.openBox<String>('readMode');
  await Hive.openBox<bool>('issaved');
  Hive.registerAdapter(FavoriteAdapter());
  await Hive.openBox<Favorite>("favorites");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<bool>>(
        valueListenable: HiveDb.settings().listenable(),
        builder: (context, box, _) {
          final mode = box.get('darkMode', defaultValue: false);
          return ScreenUtilInit(
              designSize: const Size(360, 690),
              builder: () {
                return GetMaterialApp(
                  debugShowCheckedModeBanner: false,
                  title: 'Arabic Manga Readers',
                  themeMode: mode! ? ThemeMode.dark : ThemeMode.light,
                  theme: AppThemes.lightTheme,
                  darkTheme: AppThemes.darkTheme,
                  home: const MyHomePage(),
                );
              });
        });
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  int initmaxFailedLoad = 0;

  late BannerAd _bottomBannerAd;
  late BannerAd _containerBannerAd;

  InterstitialAd? _interstitialAd;

  bool _bottombannerload = false;
  bool _containerbannerload = false;
  // FacebookBannerAd? _bannerFbAd;

  // void createFbBannerAd() {
  //   _bannerFbAd = FacebookBannerAd(
  //     placementId: ShowAds.bannerAds,
  //     bannerSize: BannerSize.STANDARD,
  //     listener: (result, value) {
  //       switch (result) {
  //         case BannerAdResult.ERROR:
  //           debugPrint("Error: $value");
  //           setState(() {
  //             _containerbannerload = false;
  //           });
  //           break;
  //         case BannerAdResult.LOADED:
  //           debugPrint("Loaded: $value");
  //           setState(() {
  //             _containerbannerload = true;
  //           });
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

  void createadbanner() {
    // final addstate = Provider.of<ShowAds>(context);

    _bottomBannerAd = BannerAd(
      adUnitId: ShowAds.bannerAds,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          setState(() {
            _bottombannerload = true;
          });
          // print('Ad loaded.');
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          ad.dispose();
          // ignore: avoid_print
          // print('Ad failed to load: $error');
        },
        onAdOpened: (Ad ad) => debugPrint('Ad opened.'),
        onAdClosed: (Ad ad) => debugPrint('Ad closed.'),
        onAdImpression: (Ad ad) => debugPrint('Ad impression.'),
      ),
    )..load();
  }

  void createadcontainer() {
    _containerBannerAd = BannerAd(
      adUnitId: ShowAds.bannerAds,
      size: AdSize.mediumRectangle,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          // print('Ad loaded.');
          setState(() {
            _containerbannerload = true;
          });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          ad.dispose();
          debugPrint('Ad failed to load: $error');
        },
        onAdOpened: (Ad ad) => debugPrint('Ad opened.'),
        onAdClosed: (Ad ad) => debugPrint('Ad closed.'),
        onAdImpression: (Ad ad) => debugPrint('Ad impression.'),
      ),
    );

    _containerBannerAd.load();
  }

  void createInterstitialAd() {
    InterstitialAd.load(
      adUnitId: ShowAds.interstitialAds,
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd interad) {
          _interstitialAd = interad;
          debugPrint('Ad loaded.');
        },
        onAdFailedToLoad: (LoadAdError error) {
          initmaxFailedLoad++;
          _interstitialAd = null;
          if (initmaxFailedLoad < maxFailedLoad) {
            createInterstitialAd();
          }
          debugPrint('Ad failed to load: $error');
        },
      ),
      request: const AdRequest(),
    );
  }

  late final _message;
  Future<void> _firebaseNotification() async {
    _message = await FirebaseMessaging.instance;

    NotificationSettings settings = await _message.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('Authorized');

      FirebaseMessaging.onMessage.listen((message) async {
        debugPrint('Notification Message => ');
        LocalNotif.showNotification(
          message.notification!.title ?? 'title',
          message.notification!.body ?? 'body',
          // payload: message.notification!.payload
        );

        debugPrint(message.notification!.title);
        debugPrint(message.notification!.body);
      });
    }
  }

  @override
  void didChangeDependencies() {
    createadbanner();
    createadcontainer();
    createInterstitialAd();
    super.didChangeDependencies();
  }

  void showInterstitialAd() {
    if (_interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (InterstitialAd interad) {
          interad.dispose();
          createInterstitialAd();
        },
        onAdFailedToShowFullScreenContent:
            (InterstitialAd interad, AdError error) {
          interad.dispose();
          createInterstitialAd();
        },
      );
      _interstitialAd?.show();
    }
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

  @override
  void initState() {
    LocalNotif.init();
    _firebaseNotification();
    // _loadInterstitialAd();
    super.initState();
  }

  @override
  void dispose() {
    _bottomBannerAd.dispose();
    _containerBannerAd.dispose();
    _interstitialAd?.dispose();
    super.dispose();
  }

  // _showInterstitialAd() {
  //   if (_isInterstitialAdLoaded == true)
  //     FacebookInterstitialAd.showInterstitialAd();
  //   else
  //     print("Interstial Ad not yet loaded!");
  // }

  // ignore: prefer_final_fields
  // int _inlineIndex = 3;

  List<String> allTags = [
    "أكشن",
    "خارق للطبيعة",
    "شونين",
    "كوميديا",
    "مدرسة",
    "دراما",
    "تبادل أجناس",
    "سينين",
    "إيتشي",
    "رومانسية",
    "تاريخ",
    "خيال",
    "مغامرة",
    "علم نفس",
    "غموض",
    "مأساة",
    "ون شوت",
    "رياضة",
    "شياطين",
    "شريحة من الحياة",
    "فنون قتالية",
    "رعب",
    "عسكرية",
    "قوى خارقة",
    "خيال علمي",
    "شوجو",
    "ويب-تون",
    "حريم",
    "ون شوت"
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: const BottomNav(),
        // bottomSheet:
        // _bannerFbAd != null
        //     ? Container(
        //         height: 50,
        //         child: _bannerFbAd,
        //       )
        //     : Container(),
        body: GetBuilder<GetFromFirestore>(
            init: GetFromFirestore(),
            builder: (controller) {
              return StreamBuilder<List<DescriptionsModel>>(
                stream: controller.descriptions(),
                builder: (context, snapshot) {
                  // print('***** DATA =>  ${snapshot.data}  <=  *****');
                  if (snapshot.hasData) {
                    var data = snapshot.data;
                    return SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SearchBar(),
                          Visibility(
                            visible: _containerbannerload,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                height: _bottomBannerAd.size.height.toDouble(),
                                width: _bottomBannerAd.size.width.toDouble(),
                                child: AdWidget(ad: _bottomBannerAd),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          // Visibility(
                          //   visible: _bottombannerload,
                          //   child: Padding(
                          //       padding: const EdgeInsets.all(8.0),
                          //       child: Container(
                          //         alignment: Alignment(0.5, 1),
                          //         child: FacebookBannerAd(
                          //           placementId:  "202599087395596_202599097395593",

                          //           bannerSize: BannerSize.STANDARD,
                          //           listener: (result, value) {
                          //             switch (result) {
                          //               case BannerAdResult.ERROR:
                          //                 print("Error: $value");
                          //                 break;
                          //               case BannerAdResult.LOADED:
                          //                 print("Loaded: $value");
                          //                 break;
                          //               case BannerAdResult.CLICKED:
                          //                 print("Clicked: $value");
                          //                 break;
                          //               case BannerAdResult.LOGGING_IMPRESSION:
                          //                 print("Logging Impression: $value");
                          //                 break;
                          //             }
                          //           },
                          //         ),
                          //       )),
                          // ),
                          Padding(
                            padding: EdgeInsets.all(8.0.r),
                            child: subtitle(': الاكثر مشاهدة', context),
                          ),
                          SizedBox(
                            height: 150.0.h,
                            child: ListView.builder(
                              physics: const RangeMaintainingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              itemCount: 20,
                              itemBuilder: (_, index) {
                                return Card(
                                    margin: EdgeInsets.all(8.0.r),
                                    child: GestureDetector(
                                        onTap: () {
                                          // _showInterstitialAd();
                                          showInterstitialAd();
                                          Get.to(() => const Detail(),
                                              arguments: data![index]);
                                        },
                                        child: cachedImages(
                                            image: data![index].coverImage,
                                            height: 170.h,
                                            width: 100.w)));
                              },
                            ),
                          ),
                          SizedBox(height: 10.0.h),
                          Padding(
                            padding: EdgeInsets.all(8.0.r),
                            child: subtitle(': التصنيفات', context),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0.r),
                            child: SizedBox(
                                height: 30.0.h,
                                child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: allTags.length,
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: EdgeInsets.only(right: 5.w),
                                        child: OutlinedButton(
                                            style: OutlinedButton.styleFrom(
                                              onSurface: Colors.amber,
                                              backgroundColor:
                                                  Theme.of(context).cardColor,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          30.0.r)),
                                              side: BorderSide(
                                                  color: Colors.amber,
                                                  width: 0.8.w),
                                            ),
                                            onPressed: () => Get.to(
                                                () => const TagsPage(),
                                                arguments: allTags[index]),
                                            child: Text(allTags[index],
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline3)),
                                      );
                                    })),
                          ),
                          SizedBox(
                            height: 30.0.sp,
                          ),
                          subtitle(': قائمة المانجا', context),
                          SizedBox(
                            height: 8.0.h,
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * .8,
                            child: ListView.builder(
                                physics: const AlwaysScrollableScrollPhysics(),
                                padding: EdgeInsets.all(10.0.r),
                                itemCount: snapshot.data!.length,
                                itemBuilder: (_, index) {
                                  // if (_containerbannerload == true &&
                                  //     index == _inlineIndex) {
                                  //   return Padding(
                                  //     padding: EdgeInsets.only(bottom: 14.0.h),
                                  //     child: SizedBox(
                                  //         height: _containerBannerAd.size.height
                                  //             .toDouble()
                                  //             .h,
                                  //         width: _containerBannerAd.size.width
                                  //             .toDouble()
                                  //             .w,
                                  //         child:
                                  //             AdWidget(ad: _containerBannerAd)),
                                  //   );
                                  // } else {
                                  return GestureDetector(
                                    onTap: () {
                                      Get.to(() => const Detail(),
                                          arguments: data![index]);
                                      // _showInterstitialAd();
                                      showInterstitialAd();
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(bottom: 19.h),
                                      height: 120.h,
                                      width: MediaQuery.of(context).size.width -
                                          50,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).primaryColor,
                                        borderRadius:
                                            BorderRadius.circular(10.r),
                                      ),
                                      child: Row(
                                        children: <Widget>[
                                          SizedBox(
                                            height: 120.h,
                                            width: 90.w,
                                            child: cachedImages(
                                                image: data![index].coverImage,
                                                height: 170,
                                                width: 200),
                                          ),
                                          SizedBox(
                                            width: 21.h,
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Flexible(
                                                child: Text(
                                                    data[index].title.length >
                                                            21
                                                        ? data[index]
                                                            .title
                                                            .replaceRange(
                                                                18,
                                                                data[index]
                                                                    .title
                                                                    .length,
                                                                '...')
                                                        : data[index].title,
                                                    maxLines: 1,
                                                    softWrap: false,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    textAlign:
                                                        TextAlign.justify,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline4),
                                              ),
                                              SizedBox(
                                                height: 5.h,
                                              ),
                                              Text(data[index].author,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headline5),
                                              SizedBox(
                                                height: 5.h,
                                              ),
                                              RatingManga(
                                                rating: double.parse(
                                                    data[index].rating),
                                                labelVisible: false,
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                  // }
                                }),
                          )
                        ],
                      ),
                    );
                  } else if (snapshot.hasError) {
                    // print(
                    //     "SanpShot Error : => ${snapshot.error.toString()} ***");
                    return const Center(child: Text('هناك خطأ ما !!'));
                  }

                  return ListView.builder(
                    padding: EdgeInsets.all(10.r),
                    itemCount: 20,
                    itemBuilder: (_, index) {
                      return Padding(
                          padding: EdgeInsets.all(8.0.r),
                          child: Shimmer.fromColors(
                            baseColor: Colors.grey[400]!,
                            highlightColor: Colors.grey[300]!,
                            child: Container(
                              height: 150.h,
                              width: 400.w,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              child: FittedBox(
                                alignment: Alignment.centerLeft,
                                child: Shimmer.fromColors(
                                  baseColor: Colors.grey[400]!,
                                  highlightColor: Colors.grey[300]!,
                                  child: Container(
                                    height: 150.h,
                                    width: 125.w,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10.r),
                                        bottomLeft: Radius.circular(10.r),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ));
                    },
                  );
                },
              );
            }),
      ),
    );
  }
}
