# AdMob Integration Design

## Overview
This document outlines the design for AdMob integration in the Xpenso app to monetize the free version with banner and interstitial ads.

## Feature Requirements
- Banner ads displayed at the bottom of key screens (home, expense list, reports)
- Interstitial ads shown at strategic points (after adding expense, before exporting data)
- AdMob configuration that works with both Android and iOS
- Easy toggle to disable ads for Pro users
- Proper ad placement that doesn't interfere with UX

## Implementation Strategy

### AdMob Setup
1. Create AdMob account and register the app
2. Generate AdMob App ID for both Android and iOS
3. Create ad units for banner and interstitial ads
4. Configure ad targeting and privacy settings

### Flutter Plugin Integration
The app already includes the `google_mobile_ads` dependency in pubspec.yaml. We'll use this plugin to display ads.

Key classes to use:
- `MobileAds`: Initialize AdMob SDK
- `BannerAd`: Create and display banner ads
- `InterstitialAd`: Create and display interstitial ads
- `RewardedAd`: For future premium features (optional)

## Ad Placement Design

### Banner Ads
- Home Screen: Bottom of the screen
- Expense List Screen: Bottom of the screen
- Reports Screen: Bottom of the screen
- Budget Screen: Bottom of the screen

### Interstitial Ads
- After every 5 expense additions
- Before CSV/PDF export (free version only)
- When switching between major sections of the app (free version only)

## Service Layer Design

### AdService
The AdService will handle all ad-related operations:

```dart
class AdService {
  static final AdService _instance = AdService._();
  static AdService get instance => _instance;
  
  AdService._();
  
  // Initialize AdMob SDK
  Future<void> initialize() async {
    // MobileAds.instance.initialize();
  }
  
  // Load interstitial ad
  Future<InterstitialAd?> loadInterstitialAd() async {
    // Create and load interstitial ad
    // Return ad instance
  }
  
  // Show interstitial ad
  Future<void> showInterstitialAd(InterstitialAd ad) async {
    // Show ad if loaded
  }
  
  // Create banner ad
  BannerAd createBannerAd() {
    // Create banner ad instance
  }
  
  // Check if user is Pro (no ads)
  bool get isProUser {
    // Return true if user has Pro subscription
  }
}
```

## Ad Unit IDs

### Android
- Banner Ad Unit ID: `ca-app-pub-3940256099942544/6300978111` (test ID)
- Interstitial Ad Unit ID: `ca-app-pub-3940256099942544/1033173712` (test ID)

### iOS
- Banner Ad Unit ID: `ca-app-pub-3940256099942544/2934735716` (test ID)
- Interstitial Ad Unit ID: `ca-app-pub-3940256099942544/4411468910` (test ID)

Note: Replace with real AdMob ad unit IDs before production deployment.

## UI Implementation

### Banner Ad Widget
Create a reusable BannerAdWidget that can be placed at the bottom of screens:

```dart
class BannerAdWidget extends StatefulWidget {
  @override
  _BannerAdWidgetState createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  BannerAd? _bannerAd;
  bool _isBannerAdReady = false;
  
  @override
  void initState() {
    super.initState();
    // Load banner ad
  }
  
  @override
  Widget build(BuildContext context) {
    // Return banner ad widget or empty container if Pro user
  }
}
```

### Ad Display Logic
- Check user subscription status before displaying ads
- Use test ads during development
- Implement proper error handling for ad loading failures
- Respect user privacy with appropriate ad targeting

## Configuration Files

### AndroidManifest.xml Updates
Add the AdMob App ID to the Android manifest:

```xml
<meta-data
    android:name="com.google.android.gms.ads.APPLICATION_ID"
    android:value="ca-app-pub-xxxxxxxxxxxxxxxx~yyyyyyyyyy"/>
```

### Info.plist Updates (iOS)
Add the AdMob App ID to the iOS Info.plist:

```xml
<key>GADApplicationIdentifier</key>
<string>ca-app-pub-xxxxxxxxxxxxxxxx~yyyyyyyyyy</string>
```

## Privacy Considerations

### GDPR/CCPA Compliance
- Implement consent management for EU users
- Provide opt-out mechanisms
- Follow Google's EU User Consent Policy

### Child-directed Apps
- If targeting children, enable child-directed treatment
- Disable personalized ads for child-directed apps

## Error Handling
- Handle ad loading failures gracefully
- Log ad errors for debugging
- Fallback to empty container if ads fail to load
- Prevent app crashes due to ad-related issues

## Testing Strategy

### Development Testing
- Use test ad unit IDs during development
- Test ad display on different screen sizes
- Verify ad behavior in both online and offline modes

### Production Testing
- Test with real ad unit IDs before deployment
- Monitor ad performance and revenue
- A/B test different ad placements

## Implementation Considerations

### Performance
- Load ads asynchronously to prevent UI blocking
- Cache loaded ads for better performance
- Implement proper ad lifecycle management

### User Experience
- Don't show ads too frequently to avoid user frustration
- Place ads where they don't interfere with core functionality
- Provide clear value proposition for Pro subscription

### Revenue Optimization
- Test different ad formats and placements
- Monitor fill rates and eCPM
- Implement ad refresh policies according to AdMob guidelines

## Future Enhancements
- Rewarded ads for premium features
- Native ads for better integration with app design
- Ad frequency capping to improve user experience