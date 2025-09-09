# Custom Categories with Icons Design

## Overview
This document outlines the design for custom categories in Xpenso, allowing Pro users to create personalized expense categories with custom icons.

## Feature Requirements
- Create custom categories with names
- Assign icons to custom categories
- Edit or delete custom categories
- Use custom categories in expense tracking
- Pro feature (not available in free version)

## Implementation Strategy

### Data Model Extensions
Extend the Category model with user-specific fields:
- `isCustom` (Boolean): Whether this category is user-created
- `userId` (String): ID of the user who created the category
- `createdAt` (DateTime): When the category was created
- `updatedAt` (DateTime): When the category was last modified

### Icon Selection
Options for category icons:
1. **Emoji icons** - Unicode emojis (default option)
2. **Material icons** - Standard Flutter Material icons
3. **Custom images** - User-uploaded images (future enhancement)

## UI Implementation

### Custom Category Setup
- Add category button in categories section
- Form with name input field
- Icon selection interface:
  - Emoji picker with common emojis
  - Material icon picker (grid view)
  - Custom image upload (Pro feature)
- Color selection for category
- Save and cancel buttons

### Category Management
- List view of all categories (default and custom)
- Visual distinction between default and custom categories
- Edit button for custom categories
- Delete button for custom categories (with confirmation)
- Default categories cannot be edited or deleted

### Icon Picker Components
```dart
class IconPicker {
  // Emoji picker widget
  Widget buildEmojiPicker() {
    // Grid of common emojis
    // Search functionality
    // Category grouping
  }
  
  // Material icon picker widget
  Widget buildMaterialIconPicker() {
    // Grid of Material icons
    // Search by name
    // Filter by category
  }
  
  // Custom image picker widget
  Widget buildCustomImagePicker() {
    // Image selection from device
    // Image cropping
    // Preview of selected image
  }
}
```

## Service Layer Design

### CategoryService
The CategoryService will handle custom category operations:

```dart
class CategoryService {
  static final CategoryService _instance = CategoryService._();
  static CategoryService get instance => _instance;
  
  CategoryService._();
  
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  
  // Get all categories for user
  Stream<List<Category>> getUserCategories(String userId) async* {
    // Query default categories
    // Query user's custom categories
    // Combine and return
  }
  
  // Create custom category
  Future<String> createCustomCategory(Category category) async {
    // Validate category name
    // Save category to Firestore
    // Return category ID
  }
  
  // Update custom category
  Future<void> updateCustomCategory(
    String categoryId, Map<String, dynamic> data) async {
    // Update category document in Firestore
  }
  
  // Delete custom category
  Future<void> deleteCustomCategory(String categoryId) async {
    // Delete category document from Firestore
    // Update associated expenses to default category
  }
  
  // Upload custom category image
  Future<String> uploadCategoryImage(
    String userId, String categoryId, File imageFile) async {
    // Upload image to Firebase Storage
    // Return download URL
  }
}
```

## User Experience

### Creation Flow
1. User taps "Add Category" button
2. Enter category name
3. Select icon from emoji or Material icon picker
4. Choose category color
5. Save custom category

### Management
- View all custom categories in a dedicated section
- Edit category details (name, icon, color)
- Delete categories with confirmation dialog
- See usage count for each category

### Icon Selection
- Intuitive emoji picker with search
- Material icon picker with preview
- Consistent styling with app theme
- Large touch targets for easy selection

## Error Handling

### Category Creation Errors
- Duplicate category names
- Invalid category names
- Firestore save failures
- Icon selection errors

### User Feedback
- Clear validation messages for category names
- Success confirmation for category creation
- Warning when deleting categories with expenses
- Error messages for failed operations

## Privacy Considerations

### Data Protection
- Custom categories stored per user
- No sharing of custom categories between users
- Secure storage of custom images
- Proper access controls

## Testing Strategy

### Unit Tests
- Test category name validation
- Validate icon selection components
- Test Firestore operations for categories
- Verify data model extensions

### Integration Tests
- Test complete category creation flow
- Verify category usage in expense tracking
- Test category editing and deletion
- Validate custom image upload (if implemented)

### UI Tests
- Test icon picker interfaces
- Verify category list display
- Check responsive design
- Validate accessibility features

## Implementation Considerations

### Performance
- Efficient querying of user categories
- Caching of category data
- Optimized icon picker rendering
- Background sync for category changes

### Data Consistency
- Prevent duplicate category names per user
- Handle category deletion effects on expenses
- Maintain link between categories and expenses
- Validate icon selections

### Pro Feature Limitations
- Only available to Pro subscribers
- Clear upgrade prompts for free users
- Graceful degradation when feature is unavailable
- Limit on number of custom categories (e.g., 50)

## Future Enhancements
- Custom image icons for categories
- Category grouping and hierarchy
- Category import/export
- Smart category suggestions based on spending patterns
- Category budget templates