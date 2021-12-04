import 'package:arabic_manga_readers/controller/ads_show.dart';
import 'package:arabic_manga_readers/controller/base_hive.dart';
import 'package:arabic_manga_readers/widgets/bottom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late BannerAd _bottomBannerAdSetting;
  bool __bottombannerloadSetting = false;
  void _createadbannerSetting() {
    _bottomBannerAdSetting = BannerAd(
      adUnitId: ShowAds.bannerAds,
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          setState(() {
            __bottombannerloadSetting = true;
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

  void didChangeDependencies() {
    super.didChangeDependencies();
    _createadbannerSetting();
    // createFbBannerAd();
  }

  @override
  void dispose() {
    // _bottomBannerAdSetting.dispose();
    super.dispose();
  }

  String? initialValue = 'عمودي';
  bool? notifinit = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          // bottomSheet: Visibility(
          //   visible: __bottombannerloadSetting,
          //   child: Container(
          //       height: _bottomBannerAdSetting.size.height.toDouble().h,
          //       width: _bottomBannerAdSetting.size.width.toDouble().w,
          //       child: AdWidget(ad: _bottomBannerAdSetting)),
          // ),
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(ScreenUtil().setHeight(100)),
            child: Visibility(
              visible: __bottombannerloadSetting,
              child: SizedBox(
                  height: _bottomBannerAdSetting.size.height.toDouble().h,
                  width: _bottomBannerAdSetting.size.width.toDouble().w,
                  child: AdWidget(ad: _bottomBannerAdSetting)),
            ),
          ),
          // bottomSheet: _bannerFbAd != null ? _bannerFbAd : Container(),
          bottomNavigationBar: const BottomNav(),
          body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 30.h,
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0.r),
                    child: Text('الإعدادات',
                        style: Theme.of(context).textTheme.headline1),
                  ),
                  SizedBox(
                    height: 40.h,
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0.r),
                    child: Container(
                        decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(10.0.r),
                            border: Border.all(
                                color: Theme.of(context).primaryColor,
                                width: 3.0.w)),
                        height: 240.0.h,
                        child: ListView(
                          padding: EdgeInsets.all(8.0.r),
                          children: [
                            ValueListenableBuilder<Box<bool>>(
                                valueListenable: HiveDb.settings().listenable(),
                                builder: (context, box, widget) {
                                  return ListTile(
                                    title: Text('الوضع الليلي',
                                        style: GoogleFonts.tajawal(
                                            fontSize: 16.0.sp,
                                            fontWeight: FontWeight.w500)),
                                    leading:
                                        const Icon(Icons.dark_mode_outlined),
                                    trailing: Switch(
                                      activeColor: Colors.amber[600],
                                      value: box.get('darkMode',
                                              defaultValue: false) ??
                                          false,
                                      onChanged: (val) {
                                        box.put('darkMode', val);
                                      },
                                    ),
                                  );
                                }),
                            ValueListenableBuilder<Box<String>>(
                                valueListenable: HiveDb.readMode().listenable(),
                                builder: (context, box, _) {
                                  return ListTile(
                                    title: Text('وضع القراءة',
                                        style: GoogleFonts.tajawal(
                                            fontSize: 16.0.sp,
                                            fontWeight: FontWeight.w500)),
                                    leading: const Icon(
                                      Icons.vertical_align_top,
                                    ),
                                    trailing: DropdownButton<String>(
                                      value: box.get('readMode',
                                          defaultValue: 'عمودي'),
                                      icon: Icon(Icons.arrow_drop_down),
                                      iconSize: 24,
                                      elevation: 16,
                                      style:
                                          const TextStyle(color: Colors.black),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          box.put('readMode', newValue!);
                                          // initialValue = newValue;
                                        });
                                      },
                                      items: <String>['افقي', 'عمودي']
                                          .map<DropdownMenuItem<String>>(
                                              (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline4),
                                        );
                                      }).toList(),
                                    ),
                                  );
                                }),
                            ListTile(
                              title: Text('اشعرات المانجا المفضلة',
                                  style: GoogleFonts.tajawal(
                                      fontSize: 16.0.sp,
                                      fontWeight: FontWeight.w500)),
                              leading: const Icon(
                                Icons.notifications_none_outlined,
                              ),
                              trailing: Switch(
                                value: notifinit!,
                                onChanged: (value) {
                                  setState(() {
                                    notifinit = value;
                                  });
                                },
                                activeColor: Colors.amber,
                              ),
                            ),
                            ListTile(
                              title: Text('اتصل بنا \n manlost1@outlook.com',
                                  style: GoogleFonts.tajawal(
                                      fontSize: 16.0.sp,
                                      fontWeight: FontWeight.w500)),
                              leading: const Icon(
                                Icons.info_outline,
                              ),
                            ),
                          ],
                        )),
                  )
                ]),
          )),
    );
  }
}
