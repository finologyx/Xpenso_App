# Recurring Expenses Functionality Design

## Overview
This document outlines the design for recurring expenses in Xpenso, allowing users to set up repeating transactions for subscriptions, rent, and other regular payments.

## Feature Requirements
- Create recurring expenses with different intervals (daily, weekly, monthly, yearly)
- Automatic generation of expense instances
- Manual and automatic recurrence processing
- Edit or cancel recurring expense templates
- View upcoming and past recurring expenses
- Pro feature (not available in free version)

## Implementation Strategy

### Recurrence Types
1. **Daily** - Repeat every day
2. **Weekly** - Repeat every week on the same day
3. **Monthly** - Repeat every month on the same date
4. **Yearly** - Repeat every year on the same date
5. **Custom** - Repeat every N days/weeks/months/years

### Data Model Extensions
Extend the Expense model with recurrence fields:
- `isRecurring` (Boolean): Whether this expense recurs
- `recurringTemplateId` (String): ID of the template this expense was generated from
- `recurringType` (String): Type of recurrence (daily, weekly, monthly, yearly, custom)
- `recurringInterval` (int): Interval for custom recurrence
- `nextOccurrence` (DateTime): Next scheduled occurrence (for templates)
- `endDate` (DateTime): End date for recurrence (optional)

### New Recurring Template Model
```dart
class RecurringTemplate {
  final String id;
  final String userId;
  final String title;
  final double amount;
  final String currency;
  final String category;
  final String paymentMethod;
  final String notes;
  final List<String> tags;
  final String recurringType;
  final int recurringInterval;
  final DateTime startDate;
  final DateTime? endDate;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
}
```

## UI Implementation

### Recurring Expense Setup
- Toggle for making expense recurring
- Recurrence type selector (dropdown)
- Custom interval input (for custom recurrence)
- Start date picker
- End date picker (optional)
- Preview of next occurrences

### Recurring Expenses List
- Separate tab or section for recurring expenses
- Display templates with next occurrence dates
- Indicate active/inactive status
- Show recurrence pattern
- Action buttons for edit/cancel

### Expense Instance Display
- Indicate which expenses are recurring instances
- Link to parent template
- Option to break recurrence link (make independent)

## Service Layer Design

### RecurrenceService
The RecurrenceService will handle recurring expense operations:

```dart
class RecurrenceService {
  static final RecurrenceService _instance = RecurrenceService._();
  static RecurrenceService get instance => _instance;
  
  RecurrenceService._();
  
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Create recurring template
  Future<String> createRecurringTemplate(RecurringTemplate template) async {
    // Save template to Firestore
    // Return template ID
  }
  
  // Generate expense instance from template
  Future<String> generateExpenseInstance(
    RecurringTemplate template, DateTime date) async {
    // Create expense instance with template data
    // Set recurringTemplateId field
    // Save to Firestore
    // Return expense ID
  }
  
  // Process recurring expenses
  Future<void> processRecurringExpenses(String userId) async {
    // Query active recurring templates
    // Check if instances need to be generated
    // Create new expense instances
    // Update nextOccurrence field
  }
  
  // Update recurring template
  Future<void> updateRecurringTemplate(
    String templateId, Map<String, dynamic> data) async {
    // Update template document in Firestore
  }
  
  // Cancel recurring template
  Future<void> cancelRecurringTemplate(String templateId) async {
    // Set isActive to false
    // Update nextOccurrence to null
  }
  
  // Get upcoming recurring expenses
  Stream<List<Expense>> getUpcomingRecurringExpenses(
    String userId, DateTime startDate, DateTime endDate) async* {
    // Query recurring expenses in date range
  }
}
```

## Processing Logic

### Automatic Processing
- Daily background job to check for new instances
- Process all active recurring templates
- Generate instances for past due dates
- Update template nextOccurrence dates

### Manual Processing
- User can manually generate instances
- Preview upcoming instances before generation
- Bulk generation for multiple templates

### Example Processing Flow
1. Check all active recurring templates
2. For each template, compare nextOccurrence with current date
3. If nextOccurrence <= current date, generate expense instance
4. Calculate new nextOccurrence based on recurrence pattern
5. Update template with new nextOccurrence

## Firebase Functions Implementation

### Recurrence Processing Function
Server-side function for automatic processing:

```javascript
// Daily function to process recurring expenses
exports.processRecurringExpenses = functions.pubsub.schedule('every 24 hours from 00:00')
  .timeZone('America/New_York')
  .onRun(async (context) => {
    // Query all active recurring templates
    // Process each template
    // Generate expense instances
    // Update templates
  });

// Function to generate single instance
exports.generateRecurringInstance = functions.https.onCall(async (data, context) => {
  // Validate user authentication
  // Generate single expense instance
  // Update template
});
```

## User Experience

### Setup Process
- Clear explanation of recurrence options
- Visual examples of different patterns
- Date validation for recurrence
- Preview of future instances

### Management
- Easy view of all recurring templates
- Quick edit options
- Cancellation confirmation
- History of generated instances

## Error Handling

### Recurrence Errors
- Invalid recurrence patterns
- Date calculation errors
- Firestore save failures
- Template processing conflicts

### User Feedback
- Clear error messages for invalid inputs
- Success confirmation for template creation
- Warning for upcoming expense instances
- Notification for processing failures

## Testing Strategy

### Unit Tests
- Test recurrence date calculations
- Validate template processing logic
- Test expense instance generation
- Verify data model extensions

### Integration Tests
- Test complete recurrence setup flow
- Verify automatic processing
- Test manual instance generation
- Validate template updates and cancellations

### Performance Tests
- Test processing with large numbers of templates
- Verify date calculation efficiency
- Check Firestore query performance

## Implementation Considerations

### Data Consistency
- Maintain link between templates and instances
- Handle template modifications affecting future instances
- Prevent duplicate instance generation
- Manage timezone differences in date calculations

### User Experience
- Clear distinction between templates and instances
- Helpful recurrence pattern explanations
- Easy management of recurring expenses
- Visual indicators for recurring items

### Pro Feature Limitations
- Only available to Pro subscribers
- Clear upgrade prompts for free users
- Graceful degradation when feature is unavailable

## Future Enhancements
- Advanced recurrence patterns (nth day of month, etc.)
- Recurrence exceptions (skip specific dates)
- Smart recurrence detection (learning from user patterns)
- Recurring budget templates