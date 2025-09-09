# Firestore Database Structure

## Overview
This document details the Firestore database structure for the Xpenso app, including collections, documents, and field structures.

## Database Schema

### Users Collection
**Path:** `/users/{userId}`

**Fields:**
- `uid` (String): User ID from Firebase Authentication
- `email` (String): User's email address
- `name` (String): User's display name
- `photoUrl` (String): URL to user's profile picture (optional)
- `isPro` (Boolean): Whether the user has Pro subscription
- `subscriptionExpiry` (Timestamp): When Pro subscription expires
- `createdAt` (Timestamp): When the user account was created
- `lastLoginAt` (Timestamp): When the user last logged in
- `isActive` (Boolean): Whether the user account is active

### Expenses Collection
**Path:** `/expenses/{expenseId}`

**Fields:**
- `id` (String): Expense ID
- `userId` (String): ID of user who created the expense
- `title` (String): Expense description
- `amount` (Number): Expense amount
- `currency` (String): Currency code (e.g., "USD")
- `category` (String): Expense category
- `paymentMethod` (String): Payment method used
- `notes` (String): Additional notes (optional)
- `tags` (Array of String): Tags associated with expense (optional)
- `date` (Timestamp): When the expense occurred
- `receiptUrl` (String): URL to receipt image (optional)
- `isRecurring` (Boolean): Whether this is a recurring expense
- `recurringType` (String): Type of recurrence (daily/weekly/monthly/yearly)
- `createdAt` (Timestamp): When the expense was created
- `updatedAt` (Timestamp): When the expense was last updated

### Budgets Collection
**Path:** `/budgets/{budgetId}`

**Fields:**
- `id` (String): Budget ID
- `userId` (String): ID of user who created the budget
- `category` (String): Category for budget ("Overall" for total budget)
- `amount` (Number): Budget amount
- `spent` (Number): Amount spent against budget
- `startDate` (Timestamp): Start of budget period
- `endDate` (Timestamp): End of budget period
- `isRecurring` (Boolean): Whether budget automatically renews
- `createdAt` (Timestamp): When the budget was created
- `updatedAt` (Timestamp): When the budget was last updated

### Categories Collection
**Path:** `/categories/{categoryId}`

**Fields:**
- `id` (String): Category ID
- `name` (String): Category name
- `icon` (String): Category icon (emoji)
- `color` (String): Color code for UI
- `isCustom` (Boolean): Whether this is a custom category
- `userId` (String): ID of user who created category (for custom categories)
- `createdAt` (Timestamp): When the category was created

### Subscriptions Collection
**Path:** `/subscriptions/{subscriptionId}`

**Fields:**
- `id` (String): Subscription ID
- `userId` (String): ID of subscribed user
- `status` (String): Subscription status (active/canceled/expired)
- `plan` (String): Plan type (monthly/yearly)
- `startDate` (Timestamp): When subscription started
- `expiryDate` (Timestamp): When subscription expires
- `createdAt` (Timestamp): When subscription record was created
- `updatedAt` (Timestamp): When subscription was last updated

### SharedAccounts Collection
**Path:** `/shared_accounts/{accountId}`

**Fields:**
- `id` (String): Account ID
- `name` (String): Account name
- `ownerId` (String): ID of account owner
- `members` (Array of String): User IDs of account members
- `createdAt` (Timestamp): When account was created
- `updatedAt` (Timestamp): When account was last updated

### AdminConfig Collection
**Path:** `/admin_config/{configId}`

**Fields:**
- `id` (String): Configuration ID
- `key` (String): Configuration key
- `value` (String): Configuration value
- `updatedAt` (Timestamp): When config was last updated

## Indexes

### Composite Indexes
1. **Expenses by User and Date**
   - Collection: expenses
   - Fields: userId (ascending), date (descending)
   - Query scope: Collection

2. **Expenses by User and Category**
   - Collection: expenses
   - Fields: userId (ascending), category (ascending), date (descending)
   - Query scope: Collection

3. **Budgets by User and Date Range**
   - Collection: budgets
   - Fields: userId (ascending), startDate (ascending), endDate (descending)
   - Query scope: Collection

4. **Categories by User**
   - Collection: categories
   - Fields: userId (ascending), isCustom (ascending)
   - Query scope: Collection

## Security Rules

### General Principles
- Users can only read/write their own data
- Admin users have additional read privileges for analytics
- All data is validated for proper structure
- Timestamps are automatically set on server side where possible

### Example Rules Structure
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can read/write their own user document
    match /users/{userId} {
      allow read, write: if request.auth.uid == userId;
    }
    
    // Users can read/write their own expenses
    match /expenses/{expenseId} {
      allow read, write: if request.auth.uid == resource.data.userId;
    }
    
    // Users can read/write their own budgets
    match /budgets/{budgetId} {
      allow read, write: if request.auth.uid == resource.data.userId;
    }
    
    // Users can read all default categories
    // Users can read/write their own custom categories
    match /categories/{categoryId} {
      allow read: if true;
      allow write: if request.auth.uid == resource.data.userId || 
                   resource.data.isCustom == false;
    }
    
    // Users can read their own subscriptions
    match /subscriptions/{subscriptionId} {
      allow read, write: if request.auth.uid == resource.data.userId;
    }
    
    // Users can read shared accounts they're members of
    // Users can write to shared accounts they own
    match /shared_accounts/{accountId} {
      allow read: if request.auth.uid in resource.data.members;
      allow write: if request.auth.uid == resource.data.ownerId;
    }
    
    // Admins can read all data for analytics
    match /{document=**} {
      allow read: if request.auth.token.admin == true;
    }
  }
}
```

## Data Aggregation for Admin Panel

### Monthly Analytics Aggregation
- Aggregate total expenses by category monthly
- Track new user signups
- Monitor subscription conversions
- Calculate revenue from Pro subscriptions

### Real-time Analytics
- Track active users
- Monitor expense entry frequency
- Identify popular categories
- Detect unusual spending patterns for fraud alerts

## Implementation Considerations

### Data Validation
- Use Firestore triggers to validate data structure
- Implement server-side validation for critical fields
- Sanitize user inputs before saving

### Performance Optimization
- Use pagination for large data sets
- Implement caching for frequently accessed data
- Use batch operations for multiple document updates

### Offline Support
- Enable Firestore persistence for offline access
- Handle conflicts with server timestamps
- Queue operations for sync when online

## Testing Strategy

### Unit Tests
- Validate document structures match expected models
- Test security rules with Firestore emulator
- Verify index configurations

### Integration Tests
- Test data aggregation functions
- Verify sync behavior between local and cloud
- Check performance with large data sets

### Security Tests
- Verify users cannot access other users' data
- Test admin access privileges
- Validate input sanitization