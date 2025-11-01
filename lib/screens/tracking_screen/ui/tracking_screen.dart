import 'package:flutter/material.dart';
import 'package:rep_visit/base/ui/widgets/main_header.dart';

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  MainHeader(
            title: "Visit Tracking", subTitle: "Monitor your daily visits"),
      ),
      body:const  Padding(
        padding:  EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [

          ],
        ),
      ),
    );
  }
}
