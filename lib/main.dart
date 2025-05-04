import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:todoapp/models/inapp_purchase.dart';
import 'package:todoapp/screens/signup_screen.dart';
import 'package:todoapp/widgets/start_app.dart';

import 'models/crud_todo.dart';
import 'models/logged_user.dart';
import 'models/todo.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

final didReceiveLocalNotificationSubject =
    BehaviorSubject<ReceivedNotification>();

final selectedNotificationSubject = BehaviorSubject<String?>();

const MethodChannel platform =
    MethodChannel('dexterx.dev/flutter_local_notifications_example');

class ReceivedNotification {
  ReceivedNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
  });

  final int id;
  final String? title;
  final String? body;
  final String? payload;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensures binding is initialized
  const AndroidInitializationSettings initiallizationSettings =
      AndroidInitializationSettings('app_icon');
  InitializationSettings initializationSettings = const InitializationSettings(
    android: initiallizationSettings,
    iOS: null,
    macOS: null,
    windows: null,
    linux: null,
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
    if (response.payload != null) {
      debugPrint('notification payload: ${response.payload}');
    }
    selectedNotificationSubject.add(response.payload);
  });
  MobileAds.instance.initialize();
  runApp(RestartWidget(
    child: const MyApp(),
  ));
}

class RestartWidget extends StatefulWidget {
  const RestartWidget({super.key, required this.child});

  final Widget child;

  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_RestartWidgetState>();
  }

  @override
  State<RestartWidget> createState() => _RestartWidgetState();
}

class _RestartWidgetState extends State<RestartWidget> {
  Key key = UniqueKey();

  void restartApp() {
    setState(() {
      key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(key: key, child: widget.child);
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    final iap = InAppPurchaseService();
    final crudTodo = CrudTodo();

    return FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            return ScreenUtilInit(
              designSize: const Size(390, 844),
              builder: (context, child) => MultiProvider(providers: [
                ChangeNotifierProvider(create: (BuildContext context) {
                  return crudTodo;
                }),
                ChangeNotifierProvider(create: (BuildContext context) {
                  return LoggedUser();
                }),
                ChangeNotifierProvider<InAppPurchaseService>(create: (BuildContext context) {
                  return iap;
                }),
                StreamProvider(
                  create: (context) => iap.getPurchaseDetailsList(context),
                  initialData: null,
                ),
                StreamProvider<List<Todo>>(
                  create: (context) {
                    return crudTodo.getTaskItemsFromServer();
                  },
                  initialData: [],
                ),
              ],
              child: MaterialApp(
                title: 'Flutter demo',
                debugShowCheckedModeBanner: false,
                theme: ThemeData(
                  primarySwatch: Colors.blue,
                ),
                home: const StartApp(),
              ),
            ));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }
}
