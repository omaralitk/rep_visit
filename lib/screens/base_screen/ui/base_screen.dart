import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rep_visit/screens/base_screen/providers/base_provider.dart';
import 'package:rep_visit/screens/doctors_screen/ui/doctors_screen.dart';
import 'package:rep_visit/screens/home_screen/ui/home_screen.dart';
import 'package:rep_visit/screens/reports/ui/reports_screen.dart';

import '../../../base/ui/widgets/bottom_nav_bar.dart';
import '../../schedule_screen/ui/schedule_screen.dart';
import '../../tracking_screen/ui/tracking_screen.dart';

class BaseScreen extends StatelessWidget {
  const BaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const BasePage();
  }
}

class BasePage extends StatefulWidget {
  const BasePage({super.key});

  @override
  State<BasePage> createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Selector<BaseProvider, int>(
          builder: (context, index, widget) {
            switch (index) {
              case 0:
                return const HomeScreen();
              case 1:
                return const ScheduleScreen();
              case 2:
                return const TrackingScreen();
              case 3:
                return const DoctorsScreen();
              case 4:
                return const ReportsScreen();
              default:
                return const SizedBox();
            }
          },
          selector: (context, provider) => provider.currentIndex),
      bottomNavigationBar: Selector<BaseProvider, int>(
          builder: (context, index, widget) {
            return CustomBottomNavBar(currentIndex: index);
          },
          selector: (context, provider) => provider.currentIndex),
    );
  }
}
