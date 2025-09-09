import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'pro_service.dart';

class AdmobService {
  static final AdmobService _instance = AdmobService._();
  static AdmobService get instance => _instance;

  AdmobService._();

  // Test ad unit IDs (replace with real IDs in production)
  static const String bannerAdUnitId = 'ca-app-pub-3940256099942544/6300978111';
  static const String interstitialAdUnitId = 'ca-app-pub-3940256099942544/1033173712';

  InterstitialAd? _interstitialAd;
  bool _isInterstitialAdReady = false;
  bool _isProUser = false;

  // Initialize AdMob
  Future<void> initialize() async {
    await MobileAds.instance.initialize();
    _loadInterstitialAd();
    _checkProStatus();
  }

  // Load interstitial ad
  Future<void> _loadInterstitialAd() async {
    await InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad;
          _isInterstitialAdReady = true;
        },
        onAdFailedToLoad: (LoadAdError error) {
          _isInterstitialAdReady = false;
        },
      ),
    );
  }

  // Check if user is Pro (no ads)
  Future<void> _checkProStatus() async {
    _isProUser = await ProService.instance.isProUser();
  }

  // Show interstitial ad
  Future<void> showInterstitialAd() async {
    // Update Pro status before showing ad
    await _checkProStatus();
    
    if (_isProUser) {
      return;
    }
    
    if (_isInterstitialAdReady && _interstitialAd != null) {
      await _interstitialAd!.show();
      _isInterstitialAdReady = false;
      _loadInterstitialAd(); // Load next ad
    } else {
      _loadInterstitialAd(); // Try to load a new ad
    }
  }

  // Check if user is Pro (no ads)
  bool get isProUser => _isProUser;
}