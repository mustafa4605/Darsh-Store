import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/providers/auth_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the authProvider to get the current state
    final authState = ref.watch(authProvider);
    // Get the AuthNotifier to call methods like logout
    final authNotifier = ref.read(authProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // Call the logout method
              authNotifier.logout();
            },
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Welcome to Your Dashboard!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            // Display the balance from the authState
            Text(
              'Your Current Balance is:',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 10),
            authState.balance != null
                ? Text(
                    '\$${authState.balance!.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  )
                : const CircularProgressIndicator(), // Show loader while balance is fetching
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                // Add navigation to other features here
              },
              child: const Text('View Products'),
            ),
          ],
        ),
      ),
    );
  }
}
