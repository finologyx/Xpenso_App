# Admin Panel Design

## Overview
This document outlines the design for the Xpenso admin panel, a web-based interface for managing users, subscriptions, and analytics.

## Feature Requirements
- User management (view, block, suspend)
- Subscription tracking (Free vs Pro)
- Expense data monitoring
- Analytics and trends visualization
- AdMob monetization reports
- Feedback and crash report management
- AI chatbot response configuration
- Fraud/risk alert monitoring

## Technology Stack
- Flutter Web for UI implementation
- Firebase Admin SDK for backend operations
- Firebase Functions for server-side logic
- Firebase Authentication for admin access
- Firestore for data storage
- Firebase Analytics for usage tracking

## Admin Panel Structure

### Authentication
- Admin login screen
- Two-factor authentication (optional)
- Session management
- Role-based access control

### Dashboard
- Summary cards for key metrics:
  - Total users
  - Active users
  - Pro subscribers
  - Revenue
  - Daily/weekly/monthly expense entries
- Quick navigation to main sections
- Recent activity feed

### User Management Section
- User list with search and filtering
- User details view
- Actions: View, Edit, Block, Suspend, Delete
- Export user data
- Bulk user operations

### Subscription Management Section
- Subscription list view
- Filter by status (active, expired, canceled)
- Subscription details
- Manual subscription management
- Revenue tracking

### Expense Monitoring Section
- Expense list with search and filtering
- View expense details
- Filter by user, date range, category
- Export expense data
- Flag suspicious expenses

### Analytics Section
- Usage statistics
- User engagement metrics
- Feature adoption tracking
- Spending pattern analysis
- Charts and visualizations

### AdMob Reports Section
- Revenue by ad type
- Click-through rates
- Impression data
- Geographic distribution
- Device-specific performance

### Feedback Management Section
- User feedback list
- Crash report aggregation
- Categorization and tagging
- Response tracking
- Resolution status

## UI Implementation

### Admin Panel Layout
- Responsive sidebar navigation
- Header with user profile and notifications
- Main content area with section views
- Footer with version and support information

### User Management UI
- Data table with user information
- Columns: UID, Email, Name, Registration Date, Last Login, Status, Subscription
- Action buttons for each user
- Bulk action toolbar
- User detail modal

### Subscription Management UI
- Data table with subscription information
- Columns: User, Plan, Status, Start Date, Expiry Date, Revenue
- Filter controls
- Subscription detail view
- Manual renewal/cancellation options

### Analytics Dashboard UI
- Grid layout of metric cards
- Interactive charts using fl_chart
- Date range selector
- Export options for reports
- Comparison tools

## Security Implementation

### Admin Roles
- Super Admin: Full access to all features
- Support Admin: User management, feedback handling
- Analytics Admin: Read-only access to analytics
- Content Admin: AI chatbot response management

### Authentication Flow
1. Admin login with email/password
2. Optional two-factor authentication
3. Role verification
4. Session token generation
5. Access control for each section

### Data Protection
- Secure admin credentials
- Audit logs for admin actions
- Rate limiting for API calls
- IP whitelisting (optional)

## Service Layer Design

### AdminService
The AdminService will handle admin panel operations:

```dart
class AdminService {
  static final AdminService _instance = AdminService._();
  static AdminService get instance => _instance;
  
  AdminService._();
  
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Admin authentication
  Future<UserCredential> adminLogin(String email, String password) async {
    // Authenticate admin user
  }
  
  // Check admin role
  Future<bool> isAdmin(String userId) async {
    // Verify user has admin privileges
  }
  
  // Get user list
  Stream<List<XpensoUser>> getUsers() async* {
    // Query users with pagination
  }
  
  // Update user status
  Future<void> updateUserStatus(String userId, bool isActive) async {
    // Update user document in Firestore
  }
  
  // Get subscription data
  Stream<List<Subscription>> getSubscriptions() async* {
    // Query subscriptions with filters
  }
  
  // Get analytics data
  Future<Map<String, dynamic>> getAnalyticsData(
    DateTime startDate, DateTime endDate) async {
    // Aggregate analytics from Firestore
  }
}
```

## Firebase Functions Implementation

### Admin Functions
Server-side functions for admin operations:

```javascript
// User management functions
exports.blockUser = functions.https.onCall(async (data, context) => {
  // Verify admin privileges
  // Update user status in Firestore
  // Revoke authentication tokens
});

exports.suspendUser = functions.https.onCall(async (data, context) => {
  // Verify admin privileges
  // Update user status in Firestore
  // Send notification to user
});

// Analytics aggregation functions
exports.generateAdminReport = functions.https.onCall(async (data, context) => {
  // Verify admin privileges
  // Query and aggregate data
  // Return formatted report
});
```

## Data Visualization

### Charts for Admin Panel
- Line charts for user growth trends
- Bar charts for category spending distribution
- Pie charts for subscription plan adoption
- Heatmaps for geographic data
- Time series for usage patterns

### Dashboard Widgets
- Metric cards with trend indicators
- Recent alerts and notifications
- Quick action buttons
- Summary statistics

## Error Handling

### Admin Panel Errors
- Authentication failures
- Unauthorized access attempts
- Database query errors
- Export generation failures
- Network connectivity issues

### User Feedback
- Clear error messages for different failure types
- Audit trail for failed operations
- Retry options for network failures
- Success confirmation for completed actions

## Testing Strategy

### Unit Tests
- Test admin authentication logic
- Validate role-based access control
- Test data aggregation functions
- Verify export functionality

### Integration Tests
- Test complete admin workflows
- Verify dashboard data accuracy
- Test user management operations
- Validate analytics reporting

### Security Tests
- Verify unauthorized access is prevented
- Test role-based permissions
- Validate audit logging
- Check data protection measures

## Implementation Considerations

### Performance
- Efficient data querying with pagination
- Caching of dashboard metrics
- Background processing for large reports
- Optimized chart rendering

### User Experience
- Intuitive navigation
- Clear visual hierarchy
- Responsive design for different screen sizes
- Helpful tooltips and documentation

### Data Privacy
- Comply with GDPR/CCPA regulations
- Anonymize user data in reports
- Secure transmission of admin data
- Regular audit of admin access

## Future Enhancements
- Advanced filtering and search
- Custom report builder
- Automated alerts for suspicious activity
- Integration with external analytics tools
- Mobile admin panel app
- Detailed user activity logs