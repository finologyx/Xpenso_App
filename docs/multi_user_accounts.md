# Multi-User Accounts Design

## Overview
This document outlines the design for multi-user accounts in Xpenso, allowing families or shared accounts to track expenses together.

## Feature Requirements
- Create shared expense accounts
- Invite users to shared accounts
- Manage user permissions in shared accounts
- Track expenses for different users in shared account
- Separate budgets per user in shared account
- Pro feature (not available in free version)

## Implementation Strategy

### Shared Account Model
```dart
class SharedAccount {
  final String id;
  final String name;
  final String ownerId;
  final List<String> memberIds;
  final Map<String, SharedAccountRole> userRoles;
  final DateTime createdAt;
  final DateTime updatedAt;
}

enum SharedAccountRole {
  owner,
  admin,
  member
}
```

### Data Model Extensions
Extend the Expense model with user-specific fields:
- `sharedAccountId` (String): ID of the shared account (if applicable)
- `paidByUserId` (String): ID of the user who paid for the expense
- `splitWithUserIds` (List<String>): IDs of users who share this expense

Extend the Budget model with user-specific fields:
- `sharedAccountId` (String): ID of the shared account (if applicable)
- `userId` (String): ID of the user this budget belongs to (in shared account)

## UI Implementation

### Shared Account Setup
- Create shared account button
- Form with account name
- Owner automatically added as first member
- Option to invite members immediately

### User Invitation Flow
1. Enter email or phone number of invitee
2. Select user role (member, admin)
3. Send invitation
4. Track invitation status (pending, accepted, declined)

### Shared Account Dashboard
- Account selector in main app
- Switch between personal and shared accounts
- View expenses specific to account
- Filter expenses by user within account
- Account-specific budgets

### Member Management
- List of account members
- Role assignment and modification
- Remove members from account
- Leave shared account option

## Service Layer Design

### SharedAccountService
The SharedAccountService will handle multi-user account operations:

```dart
class SharedAccountService {
  static final SharedAccountService _instance = SharedAccountService._();
  static SharedAccountService get instance => _instance;
  
  SharedAccountService._();
  
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseFunctions _functions = FirebaseFunctions.instance;
  
  // Create shared account
  Future<String> createSharedAccount(SharedAccount account) async {
    // Save shared account to Firestore
    // Set up proper permissions
    // Return account ID
  }
  
  // Invite user to shared account
  Future<void> inviteUserToAccount(
    String accountId, String inviteeId, SharedAccountRole role) async {
    // Send invitation via Firebase Functions
    // Update account member list
    // Set user role
  }
  
  // Accept invitation
  Future<void> acceptInvitation(String invitationId) async {
    // Validate invitation
    // Add user to account member list
    // Set up user permissions
  }
  
  // Get user's shared accounts
  Stream<List<SharedAccount>> getUserSharedAccounts(String userId) async* {
    // Query shared accounts where user is member
  }
  
  // Get account members
  Stream<List<XpensoUser>> getAccountMembers(String accountId) async* {
    // Query users who are members of account
  }
  
  // Update user role
  Future<void> updateUserRole(
    String accountId, String userId, SharedAccountRole newRole) async {
    // Update user role in account
    // Validate permission to change role
  }
  
  // Remove user from account
  Future<void> removeUserFromAccount(String accountId, String userId) async {
    // Remove user from member list
    // Update user permissions
    // Reassign expenses if needed
  }
}
```

## Firebase Functions Implementation

### Server-side Shared Account Functions
```javascript
// Function to send invitation
exports.sendSharedAccountInvitation = functions.https.onCall(async (data, context) => {
  // Validate user authentication
  // Validate permission to invite
  // Send invitation email/push notification
  // Save invitation to Firestore
});

// Function to validate invitation
exports.validateSharedAccountInvitation = functions.https.onCall(async (data, context) => {
  // Validate invitation token
  // Check if user is already member
  // Add user to account
  // Update permissions
});
```

## User Experience

### Account Switching
- Quick toggle between accounts
- Visual indicator of current account
- Account-specific color coding
- Easy access to account settings

### Expense Tracking in Shared Accounts
- Select "Paid by" user when adding expense
- Option to split expense with other members
- View expenses by member
- Account-level reporting

### Budget Management
- Separate budgets per member
- Account-level budget overview
- Member-specific budget tracking
- Shared vs individual expense distinction

## Permissions and Roles

### Role-Based Access Control
1. **Owner**:
   - Full access to account settings
   - Can invite/remove members
   - Can assign roles
   - Cannot be removed by others

2. **Admin**:
   - Can invite/remove members
   - Can manage expenses
   - Can view all budgets
   - Cannot change owner

3. **Member**:
   - Can add/edit their own expenses
   - Can view account expenses
   - Can manage their own budgets
   - Cannot invite/remove members

## Data Privacy and Security

### Access Controls
- Users can only view shared accounts they belong to
- Users can only edit expenses they created (unless admin/owner)
- Proper Firestore security rules for shared data
- Audit trail for account modifications

### Data Separation
- Clear distinction between personal and shared expenses
- Account-specific data storage
- User-specific budgets within accounts
- Secure invitation system

## Error Handling

### Shared Account Errors
- Invalid invitation tokens
- Permission denied errors
- Firestore save failures
- User already member of account

### User Feedback
- Clear validation messages for account creation
- Success confirmation for invitations sent
- Notification for received invitations
- Error messages for failed operations

## Testing Strategy

### Unit Tests
- Test shared account creation logic
- Validate role-based permissions
- Test invitation system
- Verify data model extensions

### Integration Tests
- Test complete account creation flow
- Verify user invitation and acceptance
- Test expense tracking in shared accounts
- Validate budget management in shared accounts

### Security Tests
- Verify unauthorized access is prevented
- Test role-based permissions
- Validate data isolation between accounts
- Check invitation token security

## Implementation Considerations

### Data Consistency
- Maintain link between users and shared accounts
- Handle user removal effects on expenses
- Prevent duplicate invitations
- Manage role changes properly

### Performance
- Efficient querying of shared account data
- Caching of account information
- Background sync for account changes
- Pagination for large member lists

### Pro Feature Limitations
- Only available to Pro subscribers
- Clear upgrade prompts for free users
- Graceful degradation when feature is unavailable
- Limit on number of shared accounts per user (e.g., 5)

## Future Enhancements
- Expense splitting algorithms (equal, percentage-based)
- Shared budget goals
- Account activity feed
- Integration with family sharing features
- Cross-platform account synchronization