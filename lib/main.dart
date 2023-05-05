import 'dart:async';

import 'package:flutter/material.dart';
import 'package:bitprice/page.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:lottie/lottie.dart';


void main() => runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AnimatedSplashScreen(
        splash: Lottie.asset("assets/SplashScreen.json"),
        nextScreen: const Home(),
        splashTransition: SplashTransition.fadeTransition,
        splashIconSize: 200
      ),
    )
);

