# Expense Categories Design

## Overview
This document outlines the design for default and custom expense categories in the Xpenso app.

## Default Categories
The app will include a set of default categories that are available to all users:

1. Food & Dining
   - Icon: 🍔
   - Color: #FF5722 (Deep Orange)

2. Transportation
   - Icon: 🚗
   - Color: #2196F3 (Blue)

3. Shopping
   - Icon: 🛍️
   - Color: #4CAF50 (Green)

4. Bills & Utilities
   - Icon: 💡
   - Color: #9C27B0 (Purple)

5. Entertainment
   - Icon: 🎬
   - Color: #FF9800 (Orange)

6. Health & Fitness
   - Icon: 🏥
   - Color: #E91E63 (Pink)

7. Travel
   - Icon: ✈️
   - Color: #3F51B5 (Indigo)

8. Education
   - Icon: 📚
   - Color: #00BCD4 (Cyan)

9. Groceries
   - Icon: 🛒
   - Color: #8BC34A (Light Green)

10. Gifts & Donations
    - Icon: 🎁
    - Color: #795548 (Brown)

## Category Model Structure
Each category will have the following properties:
- `id`: Unique identifier
- `name`: Display name of the category
- `icon`: Emoji or icon identifier
- `color`: Color code for UI representation
- `isCustom`: Boolean flag indicating if it's a user-created category
- `userId`: User ID for custom categories (null for default categories)

## User Interface Design

### Category Selection
- Dropdown or bottom sheet with grid layout
- Each category displayed as a card with icon and color
- Search functionality to filter categories
- "Add Custom Category" option at the bottom

### Custom Category Creation
- Form with name input
- Icon selection (emoji picker or custom icons)
- Color picker
- Save/Cancel buttons

## Data Flow

### Loading Categories
1. App initializes default categories in local database
2. On user login, fetch custom categories from Firestore
3. Merge default and custom categories for display

### Adding Custom Categories
1. User navigates to category creation screen
2. Fills out category details
3. Saves to local database
4. Syncs to Firestore

### Editing Custom Categories
1. User selects a custom category to edit
2. Modifies category details
3. Updates local database
4. Syncs changes to Firestore

### Deleting Custom Categories
1. User selects a custom category to delete
2. Confirmation dialog appears
3. Updates local database
4. Removes from Firestore

## Service Layer Design

### CategoryService
The CategoryService will handle all category-related operations:

```dart
class CategoryService {
  // Initialize default categories
  Future<void> initializeDefaultCategories() async {
    // Check if default categories exist
    // If not, create them in local database
  }
  
  // Get all categories for user
  Stream<List<Category>> getCategories(String userId) async* {
    // Return stream of merged default and custom categories
  }
  
  // Add custom category
  Future<String> addCustomCategory(Category category) async {
    // Save to local database
    // Sync to Firestore
    // Return category ID
  }
  
  // Edit custom category
  Future<void> editCustomCategory(Category category) async {
    // Update in local database
    // Sync to Firestore
  }
  
  // Delete custom category
  Future<void> deleteCustomCategory(String categoryId) async {
    // Mark as deleted in local database
    // Remove from Firestore
  }
}
```

## Implementation Considerations

### Default Categories Storage
- Store default categories as constants in the app
- Initialize them in local database on first run
- They should not be editable or deletable by users

### Custom Categories Storage
- Store custom categories in Firestore under user collection
- Sync to local database for offline access
- Handle conflicts with last-write-wins strategy

### Category Icons
- Use emojis for simplicity (no external assets needed)
- Support for custom icons can be added later as Pro feature
- Consistent sizing and styling across the app

## Error Handling
- Handle cases where default categories fail to initialize
- Display user-friendly error messages for custom category operations
- Log errors for debugging purposes

## Testing Considerations
- Unit tests for CategoryService methods
- Widget tests for category selection UI
- Integration tests for syncing custom categories
- Test edge cases like duplicate category names