import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rep_visit/base/constants/app_colors.dart';
import 'package:rep_visit/base/ui/widgets/main_header.dart';
import 'package:rep_visit/base/ui/widgets/text_widget.dart';
import 'package:rep_visit/screens/tracking_screen/provider/tracking_provider.dart';
import 'package:rep_visit/screens/tracking_screen/ui/widgets/completed_visits.dart';
import 'package:rep_visit/screens/tracking_screen/ui/widgets/pinding_visits.dart';
import 'package:rep_visit/screens/tracking_screen/ui/widgets/tracking_shimmer.dart';

class TrackingScreen extends StatelessWidget {
  const TrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const TrackingPage();
  }
}

class TrackingPage extends StatefulWidget {
  const TrackingPage({super.key});

  @override
  State<TrackingPage> createState() => _TrackingPageState();
}

class _TrackingPageState extends State<TrackingPage> {
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TrackingProvider>(context,listen: false).getVisits();
    });
  }
  @override
  Widget build(BuildContext context) {
    var trackingProvider=Provider.of<TrackingProvider>(context,listen: false);

    return Scaffold(
      appBar: AppBar(
        title: MainHeader(
            title: "Visit Tracking", subTitle: "Monitor your daily visits"),
      ),
      body: Selector<TrackingProvider,bool>(builder: (context,provide,widget){
        return provide?const TrackingShimmer(): Padding(
          padding:const EdgeInsets.symmetric(horizontal: 16.0),
          child: RefreshIndicator(
            onRefresh: (){
              return trackingProvider.getVisits();
            },
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  Selector<TrackingProvider, int>(
                    selector: (_, provider) => provider.selectedTab,
                    builder: (context, selectedIndex, _) {
                      return Row(
                        children: [
                          _tabItem(context, "Pending", 0, selectedIndex,trackingProvider),
                          const SizedBox(width: 12),
                          _tabItem(context, "Completed", 1, selectedIndex,trackingProvider),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 20,),
                  Selector<TrackingProvider, int>(
                      builder: (context, indexProvider, widget) {
                        if (indexProvider == 0) {
                          return const PendingVisits();
                        } else if (indexProvider == 1) {
                          return const CompletedVisits();
                        } else {
                          return  Container();
                        }
                      },
                      selector: (context, selector) => selector.selectedTab)
                ],
              ),
            ),
          ),
        );
      }, selector: (context,selector)=>selector.isLoading),
    );
  }

  Widget _tabItem(
      BuildContext context, String title, int index, int selectedIndex,TrackingProvider provider)
  {
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
