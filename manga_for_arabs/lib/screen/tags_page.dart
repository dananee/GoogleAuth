import 'package:arabic_manga_readers/controller/ads_show.dart';
import 'package:arabic_manga_readers/controller/get_covers.dart';
import 'package:arabic_manga_readers/model/des_mode.dart';
import 'package:arabic_manga_readers/screen/detail_screen.dart';
import 'package:arabic_manga_readers/widgets/rating_star.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';

const int maxFailedLoad = 3;

class TagsPage extends StatefulWidget {
  const TagsPage({Key? key}) : super(key: key);

  @override
  State<TagsPage> createState() => _TagsPageState();
}

class _TagsPageState extends State<TagsPage> {
  InterstitialAd? _tagsInitAd;

  int _initialtagsLoadAd = 0;

  void _createInterstitialAdtags() {
    InterstitialAd.load(
      adUnitId: ShowAds.interstitialAds,
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd interad) {
          _tagsInitAd = interad;
          print('Ad loaded.');
        },
        onAdFailedToLoad: (LoadAdError error) {
          _initialtagsLoadAd++;
          _tagsInitAd = null;
          if (_initialtagsLoadAd < maxFailedLoad) {
            _createInterstitialAdtags();
          }
          // print('Ad failed to load: $error');
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _createInterstitialAdtags();
    // _loadInterstitialAd();
  }

  initState() {
    super.initState();
    _createInterstitialAdtags();
    // _loadInterstitialAd();
  }

  void showInterstitialAdtags() {
    if (_tagsInitAd != null) {
      _tagsInitAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (InterstitialAd interad) {
          interad.dispose();
          _createInterstitialAdtags();
        },
        onAdFailedToShowFullScreenContent:
            (InterstitialAd interad, AdError error) {
          interad.dispose();
          _createInterstitialAdtags();
        },
      );
      _tagsInitAd?.show();
    }
  }

  @override
  dispose() {
    _tagsInitAd?.dispose();
    super.dispose();
  }

  // _showInterstitialAd() {
  //   if (_isInterstitialAdLoaded == true)
  //     FacebookInterstitialAd.showInterstitialAd();
  //   else
  //     print("Interstial Ad not yet loaded!");
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.amber[600],
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () => Get.back(),
          ),
          title: Text(
            Get.arguments,
            style: Theme.of(context).textTheme.headline1,
          ),
        ),
        body: GetBuilder<GetFromFirestore>(
            init: GetFromFirestore(),
            builder: (controller) {
              return StreamBuilder<List<DescriptionsModel>>(
                  stream:
                      controller.tagsSearch('manga_decription', Get.arguments),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final data = snapshot.data!;
                      return ListView.builder(
                          itemCount: data.length,
                          itemBuilder: (_, index) {
                            return ListTile(
                              title: Text(data[index].title,
                                  style: Theme.of(context).textTheme.headline2),
                              subtitle: Text(data[index].author,
                                  style: Theme.of(context).textTheme.headline5),
                              trailing: RatingManga(
                                rating: double.parse(data[index].rating),
                                labelVisible: true,
                              ),
                              onTap: () {
                                showInterstitialAdtags();
                                // _showInterstitialAd();
                                // FacebookInterstitialAd.showInterstitialAd();
                                Get.to(() => const Detail(),
                                    arguments: data[index]);
                              },
                            );
                          });
                    } else if (snapshot.hasError) {
                      return Text('${snapshot.error}');
                    }
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  });
            }),
      ),
    );
  }
}
