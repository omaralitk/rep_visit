import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rep_visit/screens/profile_screen/provider/profile_provider.dart';
import 'package:rep_visit/screens/profile_screen/ui/widgets/files_widget.dart';
import 'package:rep_visit/screens/profile_screen/ui/widgets/info_widget.dart';

import '../../../base/constants/app_colors.dart';
import '../../../base/ui/widgets/main_header.dart';
import '../../../base/ui/widgets/text_widget.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ProfilePage();
  }
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    var profileProvider = Provider.of<ProfileProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: MainHeader(
          title: "Profile".tr(),
          subTitle: "Manage your account information",
          isProfile: true,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Selector<ProfileProvider, int>(
                selector: (_, provider) => provider.selectedTab,
                builder: (context, selectedIndex, _) {
                  return Row(
                    children: [
                      _tabItem(
                          context, "Info.", 0, selectedIndex, profileProvider),
                      const SizedBox(width: 12),
                      _tabItem(
                          context, "Files", 1, selectedIndex, profileProvider),
                    ],
                  );
                },
              ),
              const SizedBox(
                height: 30,
              ),
              Selector<ProfileProvider, int>(
                  builder: (context, provider, widget) {
                    switch (provider) {
                      case 0:
                        return const InfoWidget();
                      case 1:
                        return const FilesWidget();
                      default:
                        return const InfoWidget();
                    }
                  },
                  selector: (context, selector) => selector.selectedTab)
            ],
          ),
        ),
      ),
    );
  }

  Widget _tabItem(BuildContext context, String title, int index,
      int selectedIndex, ProfileProvider provider) {
    bool isSelected = selectedIndex == index;

    return GestureDetector(
      onTap: () {
        provider.changeTab(index);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.mainColor : AppColors.whiteColor,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isSelected ? Colors.transparent : AppColors.grey200,
          ),
        ),
        child: Center(
          child: TextWidget(
            title,
            textSize: 12,
            textColor: isSelected ? AppColors.whiteColor : AppColors.fontColor,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
