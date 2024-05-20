import 'package:flutter/material.dart';
import 'package:frontend/challenge/certification/camera/camera_awosome.dart';
import 'package:frontend/challenge/create/create_challenge_screen_fir.dart';
import 'package:frontend/challenge/detail/detail_challenge_screen.dart';
import 'package:frontend/login/login_screen.dart';
import 'package:frontend/model/controller/user_controller.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:frontend/main/main_screen.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await initializeDateFormatting('ko_KR', null);

  bool isLoggedIn = await checkIfLoggedIn();
  FlutterNativeSplash.remove();
  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatefulWidget {
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    Get.put(UserController());

    return ScreenUtilInit(
        designSize: const Size(375, 844),
        minTextAdapt: true,
        builder: (context, child) {
          return GetMaterialApp(
              theme: ThemeData(primaryColor: Colors.white),
              initialRoute: widget.isLoggedIn ? 'main' : 'login',
              useInheritedMediaQuery: true,
              routes: {
                'login': (context) => const LoginScreen(),
                'main': (context) => MainScreen(),
                'create_challenge': (context) => const CreateChallengeFir(),
                'detail_challenge': (context) =>
                    ChallengeDetailScreen(challengeId: Get.arguments),
                // 'community': (context) => const CommunityScreen(),
                'camera2': (context) => const CameraAwesomeApp(),
              });
        });
  }
}

Future<bool> checkIfLoggedIn() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? accessToken = prefs.getString('access_token');

  bool isLoggedIn = accessToken != null;

  return isLoggedIn;
}
