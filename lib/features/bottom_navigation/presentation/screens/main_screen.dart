import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:pocket_ledger_app/features/authentication/domain/entities/app_user_entity.dart';
import 'package:pocket_ledger_app/features/home/presentation/screens/home_screen.dart';
import 'package:pocket_ledger_app/features/profile/presentation/screens/profile_screen.dart';
import 'package:pocket_ledger_app/features/transaction/presentation/screens/transaction_screen.dart';

class MainScreen extends StatefulWidget {
  final AppUser currentUser;
  const MainScreen({super.key, required this.currentUser});


  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;


  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [HomeScreen(),TransactionScreen(), ProfileScreen(currentUser: widget.currentUser ,)];

    return Scaffold(
      body: screens[currentIndex],

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        child:
            GNav(

              activeColor: Colors.black,
              tabActiveBorder: Border.all(
                width: 2,
                color: Colors.blueGrey,
              ),
              color: Colors.grey,
              selectedIndex: currentIndex,

              gap: 6,
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),

              onTabChange: (index) {
                setState(() {
                  currentIndex = index;
                });
              },

              tabs: const [
                GButton(
                  icon: Icons.home_outlined,
                  text: 'Home',
                ),
                GButton(
                  icon: Icons.receipt_long_outlined,
                  text: 'Transactions',
                ),

                GButton(
                  icon: Icons.person_outline,
                  text: 'Profile',
                ),
              ],
            ),
        ),
      );
  }
}


class StaticScreen extends StatelessWidget {
  const StaticScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Static Screen"),
      ),
    );
  }
}
