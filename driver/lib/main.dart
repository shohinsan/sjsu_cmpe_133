import 'package:driver/info_handler/app_info.dart';
import 'package:driver/splash/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    AppLauncher(
      child: ChangeNotifierProvider(
        create: (context) => AppInfo(),
        child: MaterialApp(
          title: 'Drivers App',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: const MySplashScreen(),
          debugShowCheckedModeBanner: false,
        ),
      ),
    ),
  );
}

class AppLauncher extends StatefulWidget {
  final Widget? child;

  const AppLauncher({this.child});

  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_AppLauncherState>()!.restartApp();
  }

  @override
  _AppLauncherState createState() => _AppLauncherState();
}

class _AppLauncherState extends State<AppLauncher> {
  Key key = UniqueKey();

  void restartApp() {
    setState(() {
      key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: key,
      child: widget.child!,
    );
  }
}

// Flutter Clearn
// rm -rf Pods
// rm -rf ios/Podfile
// flutter clean & flutter run
