import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pocket_ledger_app/features/authentication/domain/entities/app_user_entity.dart';
import 'package:pocket_ledger_app/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:pocket_ledger_app/features/authentication/presentation/bloc/auth_event.dart';
import 'package:pocket_ledger_app/features/transaction/presentation/screens/transaction_screen.dart';

class ProfileScreen extends StatelessWidget {
  final AppUser currentUser;

  const ProfileScreen({
    super.key,
    required this.currentUser,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const CircleAvatar(
              radius: 45,
              child: Icon(
                Icons.person,
                size: 50,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              currentUser.name,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              currentUser.email,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 35),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const TransactionScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.receipt_long),
                label: const Text('Transactions'),
              ),
            ),
            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  context.read<AuthBloc>().add(LogoutEvent());
                },
                icon: const Icon(Icons.logout),
                label: const Text('Logout'),
              ),
            ),
            SizedBox(height: 10.0,)
          ],
        ),
      ),
    );
  }
}