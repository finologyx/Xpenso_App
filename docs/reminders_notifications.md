# Expense Reminders and Push Notifications Design

## Overview
This document outlines the design for expense reminders and push notifications in Xpenso, allowing users to set up alerts for recurring expenses and other financial events.

## Feature Requirements
- Create reminders for expenses
- Schedule push notifications
- Configure reminder frequency and timing
- Manage active reminders
- Cancel or modify reminders
- Pro feature (not available in free version)

## Implementation Strategy

### Reminder Types
1. **Recurring Expense Reminders** - Notify before recurring expenses are due
2. **Budget Threshold Reminders** - Notify when approaching or exceeding budget limits
3. **Custom Reminders** - User-defined reminders for specific events
4. **Weekly/Monthly Summary Reminders** - Periodic spending summaries

### Data Model for Reminders
```dart
class Reminder {
  final String id;
  final String userId;
  final String type; // recurring, budget, custom, summary
  final String title;
  final String description;
  final DateTime scheduledTime;
  final bool isRepeating;
  final String repeatInterval; // daily, weekly, monthly, yearly
  final DateTime? endDate;
  final bool isActive;
  final Map<String, dynamic> metadata; // Additional data based on type
  final DateTime createdAt;
  final DateTime updatedAt;
}
```

## UI Implementation

### Reminder Setup
- Toggle for enabling reminders on expenses
- Time picker for reminder scheduling
- Repeat options for recurring reminders
- End date selector (optional)
- Preview of upcoming notifications

### Reminder Management
- List view of all active reminders
- Filter by type (recurring, budget, custom)
- Action buttons for edit/cancel
- Status indicators (active, paused, expired)
- Quick toggle for reminder activation

### Notification Preferences
- Global notification settings
- Category-specific notification preferences
- Time window preferences (morning, afternoon, evening)
- Sound and vibration settings

## Service Layer Design

### NotificationService
The NotificationService will handle reminder scheduling and notification operations:

```dart
class NotificationService {
  static final NotificationService _instance = NotificationService._();
  static NotificationService get instance => _instance;
  
  NotificationService._();
  
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  
  // Request notification permissions
  Future<void> requestNotificationPermissions() async {
    // Request permission for notifications
    // Handle permission results
  }
  
  // Schedule a reminder
  Future<String> scheduleReminder(Reminder reminder) async {
    // Save reminder to Firestore
    // Schedule local notification
    // Return reminder ID
  }
  
  // Update a reminder
  Future<void> updateReminder(
    String reminderId, Map<String, dynamic> data) async {
    // Update reminder document in Firestore
    // Reschedule notification if needed
  }
  
  // Cancel a reminder
  Future<void> cancelReminder(String reminderId) async {
    // Set isActive to false
    // Cancel scheduled notification
  }
  
  // Process budget threshold reminders
  Future<void> processBudgetReminders(String userId) async {
    // Check budget progress
    // Schedule notifications for thresholds
  }
  
  // Get user reminders
  Stream<List<Reminder>> getUserReminders(String userId) async* {
    // Query active reminders for user
  }
}
```

## Firebase Cloud Messaging Integration

### FCM Implementation
- Token registration for each user
- Topic subscription for different notification types
- Message handling for received notifications
- Background message processing

### Server-side Notification Scheduling
Using Firebase Functions for server-side notification scheduling:

```javascript
// Function to schedule notifications
exports.scheduleNotification = functions.https.onCall(async (data, context) => {
  // Validate user authentication
  // Create notification in FCM
  // Save to Firestore
});

// Function to send periodic summaries
exports.sendPeriodicSummary = functions.pubsub.schedule('every 24 hours from 09:00')
  .timeZone('America/New_York')
  .onRun(async (context) => {
    // Query users with active summary reminders
    // Generate spending summaries
    // Send notifications via FCM
  });
```

## Local Notifications

### Flutter Plugin Integration
Use the `flutter_local_notifications` plugin for local notification handling:

Key classes:
- `FlutterLocalNotificationsPlugin`: Main interface
- `AndroidNotificationDetails`: Android-specific details
- `IOSNotificationDetails`: iOS-specific details
- `NotificationDetails`: Cross-platform notification details

### Notification Handling
- Display notification when triggered
- Handle notification taps
- Update reminder status after delivery
- Manage notification categories

## User Experience

### Setup Process
- Clear explanation of reminder options
- Visual examples of notification timing
- Date and time validation
- Preview of notification content

### Management
- Easy view of all scheduled reminders
- Quick edit options
- Cancellation confirmation
- History of delivered notifications

### Notification Content
- Clear, actionable titles
- Helpful descriptions with context
- Links to relevant app sections
- Customizable notification actions

## Error Handling

### Notification Errors
- Permission denied for notifications
- Scheduling failures
- Delivery failures
- Invalid reminder configurations

### User Feedback
- Clear error messages for permission issues
- Success confirmation for reminder creation
- Warning for upcoming notifications
- Notification for processing failures

## Privacy Considerations

### Data Protection
- Notification data stored securely
- No sensitive information in notifications
- User control over notification preferences
- Proper access controls

### Permissions
- Request notification permission at setup
- Explain why permissions are needed
- Handle permission denial gracefully
- Allow users to modify permissions in settings

## Testing Strategy

### Unit Tests
- Test reminder scheduling logic
- Validate notification content generation
- Test date/time calculations
- Verify data model operations

### Integration Tests
- Test complete reminder setup flow
- Verify notification delivery
- Test reminder modifications
- Validate permission handling

### Performance Tests
- Test notification scheduling efficiency
- Verify delivery timing accuracy
- Check memory usage during notification processing

## Implementation Considerations

### Platform Differences
- Android: Notification channels and permissions
- iOS: Notification permissions and badge support
- Handle platform-specific notification features

### Data Consistency
- Maintain link between reminders and expenses/budgets
- Handle expense/budget modifications affecting reminders
- Prevent duplicate notification scheduling
- Manage timezone differences in scheduling

### Pro Feature Limitations
- Only available to Pro subscribers
- Clear upgrade prompts for free users
- Graceful degradation when feature is unavailable
- Limit on number of active reminders (e.g., 100)

## Future Enhancements
- Smart reminder suggestions based on spending patterns
- Location-based reminders
- Integration with device calendar
- Rich notification content with charts
- Notification snooze functionality