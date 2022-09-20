import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// returns the admob banner ad widget if it is ready
class AdmobBannerAdWidget extends StatefulWidget {
  const AdmobBannerAdWidget({super.key});

  @override
  State<AdmobBannerAdWidget>  createState() => _AdmobBannerAdWidgetState();
}

class _AdmobBannerAdWidgetState extends State<AdmobBannerAdWidget> {
  /// check if the ads is loading or not
  bool loadingAnchoredBanner = false;

  ///banner ad variable
  BannerAd? anchoredBanner;

  /// adrequest object
  static const AdRequest request = AdRequest();

  @override
  void initState() {
    super.initState();
  }

  /// create banner ad
  Future<void> createAnchoredBanner(BuildContext context) async {
    final size = await AdSize.getAnchoredAdaptiveBannerAdSize(
      Orientation.portrait,
      MediaQuery.of(context).size.width.truncate(),
    );

    if (size == null) {
      debugPrint('Unable to get height of anchored banner.');
      return;
    }

    final banner = BannerAd(
      size: size,
      request: request,
      adUnitId: 'ca-app-pub-9200665008350535/3051188375',
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          debugPrint('$BannerAd loaded.');
          setState(() {
            anchoredBanner = ad as BannerAd?;
          });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          debugPrint('$BannerAd failedToLoad: $error');
          ad.dispose();
        },
        onAdOpened: (Ad ad) => debugPrint('$BannerAd onAdOpened.'),
        onAdClosed: (Ad ad) => debugPrint('$BannerAd onAdClosed.'),
      ),
    );
    return banner.load();
  }

  @override
  void dispose() {
    anchoredBanner?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext context) {
        if (!loadingAnchoredBanner) {
          createAnchoredBanner(context);
          loadingAnchoredBanner = true;
        }
        return Container(
          child: (anchoredBanner != null)
              ? Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  color: Colors.white,
                  width: anchoredBanner?.size.width.toDouble(),
                  height: anchoredBanner?.size.height.toDouble(),
                  child: AdWidget(ad: anchoredBanner!),
                )
              : Container(),
        );
      },
    );
  }
}
