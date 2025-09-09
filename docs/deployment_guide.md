# Xpenso Deployment Guide

## Overview
This guide explains how to build and deploy the Xpenso Android app, including APK generation, Google Play Store deployment, and Firebase configuration.

## Prerequisites
- Flutter SDK (3.8 or higher)
- Android Studio
- Android SDK
- Firebase project
- Google Play Developer account

## APK Generation

### Build Configuration
1. Update version information in `pubspec.yaml`:
   ```yaml
   version: 1.0.0+1  # Format: major.minor.patch+build_number
   ```

2. Configure signing for release builds in `android/key.properties`:
   ```properties
   storePassword=your_store_password
   keyPassword=your_key_password
   keyAlias=your_key_alias
   storeFile=your_keystore_file_path
   ```

3. Update `android/app/build.gradle` with signing configuration:
   ```gradle
   signingConfigs {
       release {
           keyAlias keystoreProperties['keyAlias']
           keyPassword keystoreProperties['keyPassword']
           storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
           storePassword keystoreProperties['storePassword']
       }
   }
   buildTypes {
       release {
           signingConfig signingConfigs.release
       }
   }
   ```

### Building the APK
1. Clean the project:
   ```bash
   flutter clean
   ```

2. Get dependencies:
   ```bash
   flutter pub get
   ```

3. Build release APK:
   ```bash
   flutter build apk --release
   ```

4. Build app bundle (recommended for Play Store):
   ```bash
   flutter build appbundle --release
   ```

## Firebase Configuration

### Project Setup
1. Create Firebase project at https://console.firebase.google.com/
2. Register Android app with package name `com.example.xpenso`
3. Download `google-services.json` and place in `android/app/`

### Security Rules
Deploy Firestore security rules:
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth.uid == userId;
    }
    
    match /expenses/{expenseId} {
      allow read, write: if request.auth.uid == resource.data.userId;
    }
    
    match /budgets/{budgetId} {
      allow read, write: if request.auth.uid == resource.data.userId;
    }
    
    match /categories/{categoryId} {
      allow read: if resource.data.isCustom == false || request.auth.uid == resource.data.userId;
      allow write: if resource.data.isCustom == true && request.auth.uid == resource.data.userId;
    }
    
    match /subscriptions/{subscriptionId} {
      allow read, write: if request.auth.uid == resource.data.userId;
    }
    
    match /shared_accounts/{accountId} {
      allow read, write: if request.auth.uid in resource.data.memberIds;
    }
    
    match /reminders/{reminderId} {
      allow read, write: if request.auth.uid == resource.data.userId;
    }
    
    match /backups/{backupId} {
      allow read, write: if request.auth.uid == resource.data.userId;
    }
  }
}
```

### Cloud Functions Deployment
1. Navigate to functions directory:
   ```bash
   cd functions
   ```

2. Install dependencies:
   ```bash
   npm install
   ```

3. Deploy functions:
   ```bash
   firebase deploy --only functions
   ```

## Google Play Store Deployment

### Account Setup
1. Create Google Play Developer account (25 USD registration fee)
2. Complete developer profile
3. Set up payment information

### App Listing Preparation
1. App name: Xpenso - Expense Tracker & Budgeting
2. Short description: Track expenses, set budgets, and manage your finances
3. Full description: Include features, benefits, and screenshots
4. Screenshots: 
   - Home screen
   - Expense tracking
   - Budget creation
   - Reports and analytics
   - AI chatbot
5. Graphics:
   - High-resolution app icon
   - Feature graphic (1024x500)
   - Promo video (optional)

### Content Rating
1. Complete content rating questionnaire
2. Specify app categories:
   - Finance
   - Productivity
   - Lifestyle

### Privacy Policy
1. Create privacy policy document
2. Include in app listing
3. Host on website or Firebase Hosting

## Internal Testing
1. Create internal testing group
2. Upload APK or app bundle
3. Add testers to group
4. Verify core functionality:
   - User registration and login
   - Expense creation and management
   - Budget creation and tracking
   - Report generation
   - AdMob integration

## Production Release
1. Review app for policy compliance
2. Prepare release notes
3. Set rollout percentage (start with 10%)
4. Monitor crash reports and user feedback
5. Gradually increase rollout percentage

## Admin Panel Deployment

### Firebase Hosting Setup
1. Initialize Firebase Hosting:
   ```bash
   firebase init hosting
   ```

2. Configure hosting settings:
   - Public directory: build/web
   - Configure as single-page app: yes

3. Build web admin panel:
   ```bash
   flutter build web --release
   ```

4. Deploy to Firebase Hosting:
   ```bash
   firebase deploy --only hosting
   ```

## Version Management

### Versioning Strategy
- Follow semantic versioning (major.minor.patch)
- Increment build number for each release
- Maintain changelog for each version

### Release Notes Template
```
Version X.X.X (Build XXXX)
New Features:
- Feature description

Improvements:
- Improvement description

Bug Fixes:
- Bug fix description
```

## CI/CD Pipeline

### GitHub Actions Workflow
Create `.github/workflows/deploy.yml`:
```yaml
name: Deploy to Play Store

on:
  push:
    tags:
      - 'v*'

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: actions/setup-java@v1
        with:
          java-version: '11.x'
      - uses: subosito/flutter-action@v1
        with:
          flutter-version: '3.8.x'
      
      - name: Get dependencies
        run: flutter pub get
      
      - name: Build APK
        run: flutter build apk --release
      
      - name: Deploy to Play Store
        uses: r0adkll/upload-google-play@v1
        with:
          serviceAccountJsonPlainText: ${{ secrets.SERVICE_ACCOUNT_JSON }}
          packageName: com.example.xpenso
          releaseFiles: build/app/outputs/flutter-apk/app-release.apk
          track: production
```

## Monitoring and Analytics

### Firebase Analytics
- Track user engagement metrics
- Monitor feature adoption
- Analyze user retention
- Identify popular categories

### Crashlytics Integration
- Automatic crash reporting
- Stack trace analysis
- Issue prioritization
- Stability monitoring

## Support and Maintenance

### User Feedback System
- In-app feedback collection
- Email support channel
- FAQ documentation
- User community forum

### Regular Updates
- Security patches
- Feature enhancements
- Performance improvements
- Bug fixes

### Backup and Recovery
- Regular database backups
- Configuration version control
- Rollback procedures
- Disaster recovery plan

## Troubleshooting

### Common Build Issues
1. **Signing configuration errors**:
   - Verify key.properties file
   - Check keystore file path
   - Confirm passwords and aliases

2. **Firebase integration issues**:
   - Verify google-services.json placement
   - Check Firebase project configuration
   - Validate security rules

3. **Dependency conflicts**:
   - Run flutter pub upgrade
   - Check pubspec.yaml versions
   - Clear package cache

### Deployment Issues
1. **Play Store rejection**:
   - Review policy compliance
   - Check app content and metadata
   - Verify privacy policy inclusion

2. **Function deployment failures**:
   - Check function syntax
   - Verify dependencies
   - Review logs in Firebase Console

## Future Considerations

### Platform Expansion
- iOS app development
- Web app deployment
- Desktop app versions

### Feature Enhancements
- Advanced financial planning tools
- Banking API integrations
- Investment tracking features

### Performance Optimization
- App size reduction
- Startup time improvements
- Memory usage optimization