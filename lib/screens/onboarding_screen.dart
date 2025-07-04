import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(
          children: [
            const Image(image: AssetImage('assets/images/onboarding_todo.png')),
            TextButton(
              onPressed: () {
                // write code here to move to next page i.e sign up page
                // Navigator.pushReplacement(
                //   context,
                //   MaterialPageRoute(
                //     builder: (_) => const SignUpForm(),
                //   ),
                // );
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 24.w),
                height: 75.h,
                width: 400.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(12.r)),
                  color: Colors.blueAccent,
                ),
                child: Center(child: Text("Continue", style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w700, color: Colors.black),)),
              ),
            ),
          ],
        ));
  }
}
