# Authentication Design

## Overview
This document outlines the design for authentication in the Xpenso app, supporting email/password, Google Sign-In, and phone authentication.

## Feature Requirements
- Email/password authentication (register, login, password reset)
- Google Sign-In integration
- Phone number authentication with SMS verification
- User profile management
- Secure session handling
- Account linking capabilities

## Implementation Strategy

### Firebase Authentication Setup
1. Enable Email/Password sign-in method in Firebase Console
2. Enable Google sign-in method in Firebase Console
3. Enable Phone sign-in method in Firebase Console
4. Configure SHA-1 and SHA-256 certificates for Android
5. Configure URL schemes and reverse client IDs for iOS

### Flutter Plugin Integration
The app already includes the `firebase_auth` dependency in pubspec.yaml. We'll use this plugin to implement authentication.

Key classes to use:
- `FirebaseAuth`: Main authentication interface
- `User`: Represents a user account
- `AuthCredential`: Authentication credentials
- `EmailAuthProvider`: For email/password authentication
- `GoogleAuthProvider`: For Google sign-in
- `PhoneAuthProvider`: For phone number authentication

## Authentication Flow

### Initial App Launch
1. Check for existing authenticated session
2. If authenticated, navigate to home screen
3. If not authenticated, navigate to login screen

### Login Screen Options
- Email/password login form
- "Sign in with Google" button
- "Sign in with Phone" button
- "Forgot Password" link
- "Create Account" link

### Registration Flow
1. Email/password registration form
2. Validate email format and password strength
3. Create user account with Firebase Authentication
4. Create user profile in Firestore
5. Navigate to home screen

### Google Sign-In Flow
1. User taps "Sign in with Google" button
2. Show account selection dialog
3. Authenticate with selected Google account
4. Create user profile in Firestore if new user
5. Navigate to home screen

### Phone Authentication Flow
1. User taps "Sign in with Phone" button
2. Enter phone number in international format
3. Send SMS verification code
4. Enter received verification code
5. Authenticate and create user profile if new user
6. Navigate to home screen

## Service Layer Design

### AuthService
The AuthService will handle all authentication-related operations:

```dart
class AuthService {
  static final AuthService _instance = AuthService._();
  static AuthService get instance => _instance;
  
  AuthService._();
  
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Stream of user authentication state
  Stream<User?> get user {
    return _auth.authStateChanges();
  }
  
  // Register with email and password
  Future<UserCredential> registerWithEmailAndPassword(
    String email, String password) async {
    // Create user with email and password
    // Create user profile in Firestore
  }
  
  // Login with email and password
  Future<UserCredential> loginWithEmailAndPassword(
    String email, String password) async {
    // Sign in with email and password
  }
  
  // Sign in with Google
  Future<UserCredential> signInWithGoogle() async {
    // Implement Google sign-in flow
    // Create user profile if new user
  }
  
  // Sign in with phone number
  Future<void> signInWithPhoneNumber(String phoneNumber) async {
    // Implement phone authentication flow
    // Create user profile if new user
  }
  
  // Verify phone number code
  Future<UserCredential> verifyPhoneNumberCode(String verificationId, String smsCode) async {
    // Verify SMS code and complete authentication
  }
  
  // Password reset
  Future<void> resetPassword(String email) async {
    // Send password reset email
  }
  
  // Sign out
  Future<void> signOut() async {
    // Sign out from Firebase Authentication
  }
  
  // Delete account
  Future<void> deleteAccount() async {
    // Delete user account and associated data
  }
}
```

## User Profile Management

### Profile Creation
When a user authenticates for the first time:
1. Create user document in Firestore `/users/{userId}`
2. Populate with data from authentication provider
3. Set default preferences and settings

### Profile Updates
Users can update their profile information:
- Display name
- Profile photo
- Primary currency
- Theme preference

## UI Implementation

### Authentication Screens
1. **Login Screen**
   - Email/password fields
   - Google Sign-In button
   - Phone Sign-In button
   - Forgot password link
   - Register link

2. **Registration Screen**
   - Name field
   - Email field
   - Password field
   - Confirm password field
   - Register button

3. **Phone Verification Screen**
   - Phone number input
   - SMS code input
   - Resend code button
   - Verify button

4. **Forgot Password Screen**
   - Email input field
   - Send reset link button

### Authentication State Management
- Use StreamBuilder to listen for authentication state changes
- Navigate between auth screens and main app based on state
- Show loading indicators during authentication processes

## Security Considerations

### Password Requirements
- Minimum 8 characters
- Mix of letters, numbers, and special characters
- No common password patterns

### Session Management
- Automatic session timeout after inactivity
- Secure token storage
- Proper sign-out cleanup

### Data Protection
- Only store non-sensitive user data in Firestore
- Encrypt sensitive local data
- Implement proper Firestore security rules

## Error Handling
- Handle authentication errors (invalid credentials, network issues)
- Display user-friendly error messages
- Implement retry mechanisms for network failures
- Handle account linking conflicts

## Testing Strategy

### Unit Tests
- Test authentication service methods
- Validate password strength requirements
- Test user profile creation and updates

### Integration Tests
- Test complete authentication flows
- Verify session persistence
- Test sign-out and account deletion

### Security Tests
- Verify unauthorized access is prevented
- Test password reset functionality
- Validate input sanitization

## Implementation Considerations

### Account Linking
- Allow users to link multiple authentication providers
- Handle conflicts when same email is used with different providers
- Maintain single user profile across all providers

### User Experience
- Provide clear feedback during authentication processes
- Remember user's preferred authentication method
- Implement proper loading states
- Handle offline authentication gracefully

### Analytics
- Track authentication success/failure rates
- Monitor user registration sources
- Log security events for admin panel

## Future Enhancements
- Biometric authentication (fingerprint, face recognition)
- Multi-factor authentication
- Social login providers (Facebook, Apple)
- Account recovery mechanisms