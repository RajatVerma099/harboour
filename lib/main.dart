import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:harbour/show_data.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'onboard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  OneSignal.initialize("56c94a7a-618b-41d6-8db3-955968baf359");

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.deepPurple),
        // Adjust other theme properties as needed
      ),
      home: AnimatedSplashScreen(
        splash: Image.asset('img/infinity.gif', fit: BoxFit.cover),
        splashIconSize: 200,
        splashTransition: SplashTransition.scaleTransition,
        backgroundColor: Colors.black,
        duration: 2000,
        nextScreen: MyAppScreen(),
      ),
    );
  }
}

class MyAppScreen extends StatefulWidget {
  @override
  _MyAppScreenState createState() => _MyAppScreenState();
}

class _MyAppScreenState extends State<MyAppScreen> {
  int? isViewed;

  @override
  void initState() {
    super.initState();
    checkOnBoardStatus();
  }

  Future<void> checkOnBoardStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isViewed = prefs.getInt('onBoard');
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: isViewed != 0 ? OnBoard() : MyHomePage(title: "Welcome Seeker !!"),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;

  const MyHomePage({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(title),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome to Job Shore. This is where you, as a community, work together to find jobs!',
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.large(
        onPressed: () => goTo(const ShowData(), context),
        tooltip: 'Let\'s start!',
        child: const Icon(Icons.play_arrow_rounded),
      ),
    );
  }
}


void goTo(Widget page, BuildContext context) {
  Navigator.of(context).push(MaterialPageRoute(builder: (context) => page));
}
