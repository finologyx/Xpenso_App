import 'package:flutter/material.dart';
import '../services/pro_service.dart';

class SubscriptionStatusWidget extends StatefulWidget {
  const SubscriptionStatusWidget({super.key});

  @override
  State<SubscriptionStatusWidget> createState() => _SubscriptionStatusWidgetState();
}

class _SubscriptionStatusWidgetState extends State<SubscriptionStatusWidget> {
  bool _isProUser = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkSubscriptionStatus();
  }

  Future<void> _checkSubscriptionStatus() async {
    try {
      bool isPro = await ProService.instance.isProUser();
      if (mounted) {
        setState(() {
          _isProUser = isPro;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return Card(
      margin: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Subscription Status',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(
                  _isProUser ? Icons.star : Icons.star_border,
                  color: _isProUser ? Colors.amber : Colors.grey,
                  size: 24,
                ),
                const SizedBox(width: 10),
                Text(
                  _isProUser ? 'Pro User' : 'Free User',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: _isProUser ? Colors.amber : Colors.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            if (!_isProUser)
              ElevatedButton(
                onPressed: () {
                  // Navigate to Pro upgrade screen
                  Navigator.pushNamed(context, '/pro_upgrade');
                },
                child: const Text('Upgrade to Pro'),
              )
            else
              const Text(
                'Enjoy all premium features!',
                style: TextStyle(
                  color: Colors.green,
                ),
              ),
          ],
        ),
      ),
    );
  }
}