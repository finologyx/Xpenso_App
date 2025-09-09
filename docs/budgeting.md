# Budgeting Features Design

## Overview
This document outlines the design for budget creation and progress tracking features in the Xpenso app.

## Feature Requirements
- Users can create monthly budgets for specific categories or overall spending
- Users can view their budget progress in real-time
- Budgets should automatically calculate spent amounts from expenses
- Pro users can create recurring budgets
- Budget progress should be visualized with progress bars and charts

## User Interface Design

### Budget Creation Screen
The Budget Creation screen will be a form with the following fields:
- Category (dropdown selector, including "Overall" option)
- Budget Amount (numeric input)
- Currency (dropdown selector, defaults to user's primary currency)
- Start Date (date picker, defaults to current date)
- End Date (date picker, defaults to end of month)
- Recurring (toggle switch, Pro feature only)

UI Elements:
- Form validation for required fields
- Date range validation (end date must be after start date)
- Category selection with visual indicators
- Currency conversion display if different from primary

### Budget List Screen
The Budget List screen will display active budgets:
- Each budget as a card with category, amount, and progress bar
- Visual indicators for budget status (on track, warning, exceeded)
- Quick actions to edit or delete budgets
- Filter by active/inactive budgets

### Budget Progress Widget
A widget that displays budget progress on the home screen:
- Circular progress indicator for overall budget
- Linear progress bars for category budgets
- Color-coded status indicators (green, yellow, red)
- Tap to view detailed budget report

## Data Flow

### Creating a Budget
1. User fills out the budget form
2. Form validates required fields and date range
3. Budget is saved to local database
4. If online, budget is simultaneously saved to Firestore
5. If offline, budget is queued for sync when connection is restored

### Tracking Budget Progress
1. Expenses are linked to budgets by category and date range
2. When an expense is added/edited/deleted, update budget spent amounts
3. Calculate percentage of budget used in real-time
4. Display visual indicators based on progress thresholds:
   - 0-80%: On track (green)
   - 80-100%: Warning (yellow)
   - 100%+: Exceeded (red)

### Recurring Budgets (Pro Feature)
1. When a recurring budget ends, automatically create a new one
2. Maintain same parameters but update date range
3. Reset spent amount to zero for the new period

## Service Layer Design

### BudgetService
The BudgetService will handle all budget-related operations:

```dart
class BudgetService {
  // Add a new budget
  Future<String> addBudget(Budget budget) async {
    // Save to local database
    // Sync to Firestore if online
    // Return budget ID
  }
  
  // Edit an existing budget
  Future<void> editBudget(Budget budget) async {
    // Update in local database
    // Sync to Firestore if online
  }
  
  // Delete a budget
  Future<void> deleteBudget(String budgetId) async {
    // Mark as deleted in local database
    // Delete from Firestore if online
  }
  
  // Get all budgets for user
  Stream<List<Budget>> getBudgets(String userId) async* {
    // Return stream of budgets from local database
    // Listen for Firestore updates and sync to local
  }
  
  // Get budget by ID
  Future<Budget> getBudgetById(String budgetId) async {
    // Return budget from local database
  }
  
  // Get active budgets for current period
  Stream<List<Budget>> getActiveBudgets(String userId, DateTime date) async* {
    // Return stream of active budgets for given date
  }
  
  // Update budget spent amount
  Future<void> updateSpentAmount(String budgetId, double amount) async {
    // Update spent amount in local database
    // Sync to Firestore if online
  }
  
  // Calculate budget progress
  double calculateProgress(Budget budget) {
    // Return percentage of budget used
  }
}
```

## Budget Progress Calculation

### Algorithm
1. For each budget, query expenses within the budget period
2. Sum expenses by category (or all expenses for overall budget)
3. Calculate percentage: (spent amount / budget amount) * 100
4. Update progress indicators in real-time

### Example Implementation
```dart
double calculateProgress(Budget budget) {
  if (budget.amount <= 0) return 0;
  if (budget.spent <= 0) return 0;
  double progress = (budget.spent / budget.amount) * 100;
  return progress > 100 ? 100 : progress;
}
```

## Firestore Database Structure

### Budgets Collection
- Path: `/budgets/{budgetId}`
- Fields match the Budget model
- Indexed by userId, category, and date range for efficient querying

### Budget-Expense Relationship
- Expenses link to budgets through category and date fields
- No direct foreign key relationship to maintain flexibility
- Budget service calculates associations dynamically

## Implementation Considerations

### Progress Visualization
- Use CircularProgressIndicator for overall budget
- Use LinearProgressIndicator for category budgets
- Color-code based on progress thresholds
- Animate transitions for smooth UX

### Date Range Management
- Validate that budgets don't overlap for the same category
- Handle timezone differences in date calculations
- Automatically adjust end dates to period boundaries

### Real-time Updates
- Listen for expense changes and update budget progress
- Use streams to provide real-time UI updates
- Debounce frequent updates to prevent UI jitter

## Error Handling
- Validate budget amounts are positive numbers
- Handle date range conflicts with user-friendly messages
- Display network errors with retry options
- Log calculation errors for debugging

## Testing Considerations
- Unit tests for budget calculation algorithms
- Widget tests for budget creation forms
- Integration tests for real-time progress updates
- Test edge cases like overlapping budgets and timezone differences