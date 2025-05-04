import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/models/inapp_purchase.dart';
import 'package:todoapp/models/logged_user.dart';

class BuyPremium extends StatelessWidget {
  const BuyPremium({super.key});

  @override
  Widget build(BuildContext context) {
    final loggedUser = Provider.of<LoggedUser>(context);
    final iap = Provider.of<InAppPurchaseService>(context);
    return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                    'Buy premium',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.sp,
                    ),
                ),
                SizedBox(height: 12.h),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      iap.buyGroupMonthlySubscription(loggedUser.id!);
                    },
                    child: const Text(
                      'Purchase',
                      style: TextStyle(fontWeight: FontWeight.bold)
                    ))
              ],
            )
          ),
        ),
    );
  }
}