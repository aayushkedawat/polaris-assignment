import 'dart:async';

import 'package:flutter/material.dart';
import 'package:polairs_assignment/features/form/presentation/pages/home/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    navigateToScreen();
  }

  void navigateToScreen() async {
    Widget screenToNavigate = const HomeScreen();
    // if (!(await ConnectivityCheck.isConnected())) {
    //   ToastWidget.showToast('You are not connected to internet');
    //   return;
    // }
    Timer(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => screenToNavigate,
        ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Center(
      child: Text('Welcome to the application'),
    ));
  }
}
