# Expense Tracking Features Design

## Overview
This document outlines the design for the core expense tracking features of the Xpenso app: adding, editing, and deleting expenses.

## Feature Requirements
- Users can add new expenses with all relevant details
- Users can edit existing expenses
- Users can delete expenses
- All operations should work offline and sync with Firestore when online
- Expenses should be displayed in a list view with card-based UI

## User Interface Design

### Add Expense Screen
The Add Expense screen will be a form with the following fields:
- Title (text input)
- Amount (numeric input)
- Currency (dropdown selector)
- Category (dropdown selector with default and custom categories)
- Payment Method (dropdown selector)
- Date (date picker)
- Notes (text input, optional)
- Tags (chips input, optional)
- Receipt Image (image picker, optional)

UI Elements:
- Floating action button on home screen to navigate to Add Expense
- Form validation for required fields
- Real-time currency conversion display
- Image preview for selected receipts

### Expense List Screen
The Expense List screen will display expenses in a grid/card layout:
- Each expense as a card with title, amount, category, and date
- Swipe gestures for quick actions (edit, delete)
- Filtering options by date range, category, payment method
- Search functionality
- Pull-to-refresh for manual sync

### Edit Expense Screen
The Edit Expense screen will be similar to the Add Expense screen but pre-filled with existing expense data:
- All fields editable except ID
- Save and Cancel buttons
- Delete option in action bar

## Data Flow

### Adding an Expense
1. User fills out the expense form
2. Form validates required fields
3. Expense is saved to local database
4. If online, expense is simultaneously saved to Firestore
5. If offline, expense is queued for sync when connection is restored

### Editing an Expense
1. User selects an expense to edit
2. Expense data is loaded into the form
3. User modifies the data
4. Changes are saved to local database
5. If online, changes are simultaneously updated in Firestore
6. If offline, changes are queued for sync when connection is restored

### Deleting an Expense
1. User swipes or selects delete option for an expense
2. Confirmation dialog appears
3. Expense is marked as deleted in local database
4. If online, expense is simultaneously deleted from Firestore
5. If offline, deletion is queued for sync when connection is restored

## Service Layer Design

### ExpenseService
The ExpenseService will handle all expense-related operations:

```dart
class ExpenseService {
  // Add a new expense
  Future<String> addExpense(Expense expense) async {
    // Save to local database
    // Sync to Firestore if online
    // Return expense ID
  }
  
  // Edit an existing expense
  Future<void> editExpense(Expense expense) async {
    // Update in local database
    // Sync to Firestore if online
  }
  
  // Delete an expense
  Future<void> deleteExpense(String expenseId) async {
    // Mark as deleted in local database
    // Delete from Firestore if online
  }
  
  // Get all expenses for user
  Stream<List<Expense>> getExpenses(String userId) async* {
    // Return stream of expenses from local database
    // Listen for Firestore updates and sync to local
  }
  
  // Get expense by ID
  Future<Expense> getExpenseById(String expenseId) async {
    // Return expense from local database
  }
}
```

## Offline-First Implementation

### Local Database (SQLite/Drift)
- Expenses table with all fields from Expense model
- Sync status column to track upload status
- Last modified timestamp for conflict resolution

### Sync Strategy
- When online, immediately sync changes to Firestore
- When offline, queue changes in local database
- On reconnect, process queue in chronological order
- Handle conflicts with last-write-wins strategy based on timestamps

## Error Handling
- Form validation errors displayed inline
- Network errors shown in snackbar with retry option
- Database errors logged and reported to analytics
- Image upload errors handled with local caching

## Testing Considerations
- Unit tests for ExpenseService methods
- Widget tests for Add/Edit Expense forms
- Integration tests for offline/online sync scenarios
- UI tests for swipe gestures and navigation