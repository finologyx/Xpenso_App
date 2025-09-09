# App Security Design

## Overview
This document outlines the design for app security features in Xpenso, including passcode protection and biometric authentication (face unlock/fingerprint).

## Feature Requirements
- Passcode lock for app access
- Biometric authentication (fingerprint, face unlock)
- Security settings in app configuration
- Automatic lock after period of inactivity
- Secure storage of authentication data
- Fallback mechanisms for different authentication methods

## Implementation Strategy

### Flutter Plugin Integration
Use the following plugins for security features:

1. `local_auth` - For biometric authentication
2. `flutter_secure_storage` - For secure data storage
3. `shared_preferences` - For non-sensitive settings

### Authentication Flow
1. User enables security in settings
2. Set up passcode or biometric authentication
3. App locks automatically after inactivity period
4. User must authenticate to access app
5. Authentication persists during active session

## Security Features

### Passcode Protection
- 4 or 6 digit numeric passcode
- Passcode creation and confirmation
- Passcode change functionality
- Passcode reset (with account password verification)

### Biometric Authentication
- Fingerprint scanner support
- Face unlock support (Face ID on iOS, Face Unlock on Android)
- Device-specific biometric capabilities detection
- Fallback to passcode when biometric fails

### Inactivity Lock
- Configurable timeout period (1 minute, 5 minutes, 10 minutes)
- Background timer implementation
- Immediate lock when app goes to background (optional setting)

## UI Implementation

### Security Settings Screen
- Toggle for enabling/disabling security
- Option to choose authentication method (passcode, biometric, both)
- Inactivity timeout selector
- Passcode setup/change flow

### Authentication Screen
- Clean, minimal interface
- Passcode entry grid (similar to phone dial pad)
- Biometric authentication prompt
- Forgot passcode recovery option

### Setup Flow
1. Security Settings Screen
2. Choose authentication method
3. Passcode Setup Screen (if selected)
4. Biometric Setup Screen (if selected)
5. Confirmation and testing

## Data Storage

### Secure Storage
Use `flutter_secure_storage` for sensitive data:
- Passcode hash
- Biometric preference settings
- Encryption keys

### Local Storage
Use `shared_preferences` for non-sensitive settings:
- Security enabled flag
- Timeout duration
- Last active timestamp

## Security Implementation

### Passcode Storage
- Never store passcode in plain text
- Use secure hashing algorithm (SHA-256)
- Salt passcode hashes for additional security
- Store only in secure storage

### Authentication Validation
```dart
class SecurityService {
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  final SharedPreferences _prefs = SharedPreferences.getInstance();
  
  // Validate passcode
  Future<bool> validatePasscode(String input) async {
    // Hash input and compare with stored hash
  }
  
  // Store passcode
  Future<void> storePasscode(String passcode) async {
    // Hash passcode and store securely
  }
  
  // Check if biometric is available
  Future<bool> isBiometricAvailable() async {
    // Check device biometric capabilities
  }
  
  // Authenticate with biometric
  Future<bool> authenticateWithBiometric() async {
    // Show biometric authentication prompt
  }
  
  // Check if app should be locked
  Future<bool> shouldLockApp() async {
    // Check last active time vs timeout setting
  }
}
```

## User Experience

### Setup Process
- Clear instructions for each step
- Visual feedback during setup
- Confirmation of successful setup
- Test authentication immediately

### Authentication Process
- Smooth transition to authentication screen
- Clear error messages for failed attempts
- Progressive delay after multiple failed attempts
- Easy access to recovery options

### Recovery Options
- Forgot passcode flow
- Re-authentication with account password
- Security question (optional additional layer)
- Admin-assisted recovery for extreme cases

## Error Handling

### Failed Authentication Attempts
- Track failed attempts
- Implement exponential backoff
- Lock app temporarily after multiple failures
- Log security events for admin panel

### Biometric Errors
- Handle hardware unavailable
- Handle permission denied
- Handle biometric not enrolled
- Provide clear fallback instructions

## Privacy Considerations

### Data Protection
- No sensitive data stored in plain text
- Passcode never leaves the device
- Biometric data handled by system (not accessible to app)
- Secure communication with Firebase

### Permissions
- Request biometric permission at setup
- Explain why permissions are needed
- Handle permission denial gracefully

## Testing Strategy

### Unit Tests
- Test passcode hashing and validation
- Test biometric availability detection
- Test inactivity timeout logic

### Integration Tests
- Test complete authentication flows
- Verify secure storage implementation
- Test recovery mechanisms

### Security Tests
- Verify passcode is not stored in plain text
- Test multiple failed attempt handling
- Validate encryption implementation

## Implementation Considerations

### Platform Differences
- iOS: Face ID, Touch ID
- Android: Fingerprint, Face Unlock
- Handle platform-specific APIs

### Performance
- Minimize authentication delay
- Efficient secure storage access
- Background timer optimization

### Accessibility
- Support for users without biometric capabilities
- Clear visual and audio feedback
- Alternative authentication methods

## Future Enhancements
- Two-factor authentication
- Pattern lock alternative
- PIN lock with alphanumeric support
- Remote wipe functionality
- Security logs and monitoring