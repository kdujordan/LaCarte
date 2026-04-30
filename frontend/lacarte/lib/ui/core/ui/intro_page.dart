import 'package:flutter/material.dart';
import 'package:lacarte/ui/core/ui/station.dart';
import 'package:lacarte/ui/lacarte_ft/view_models/auth_view_model.dart';
import 'package:provider/provider.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({Key? key}) : super(key: key);

  final String testQrCodeId = 'table_1_abc123';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Consumer<AuthViewModel>(
          builder: (context, authViewModel, child) {
            if (authViewModel.isLoading) {
              return const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text("Setting up your table..."),
                ],
              );
            }

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Welcome To La Carte',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 20),

                if (authViewModel.errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Text(
                      authViewModel.errorMessage!,
                      style: const TextStyle(color: Colors.red, fontSize: 16),
                    ),
                  ),

                ElevatedButton(
                  onPressed: () async {
                    bool success = await context
                        .read<AuthViewModel>()
                        .guestEnter(testQrCodeId);

                    if (success && context.mounted) {
                      // Navigate to the next page (e.g., MenuPage)
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => Station()),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 15,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text('Enter', style: TextStyle(fontSize: 16)),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
