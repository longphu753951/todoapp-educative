import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/models/logged_user.dart';
import 'package:todoapp/screens/onboarding_screen.dart';
import 'package:todoapp/screens/splash_screen.dart';
import 'package:todoapp/screens/todo_screen.dart';

class StartApp extends StatelessWidget {
  const StartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting) {
            return const SplashScreen();
          } else if(snapshot.hasData) {
            Provider.of<LoggedUser>(context, listen: false).setProfileInfo();
            return const TodoScreen();
          }
          else {
            return const OnboardingScreen();
          }
        });
  }
}