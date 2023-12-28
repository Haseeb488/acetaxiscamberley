import 'package:acetaxiscamberley/Pages/dropoff_search_screen.dart';
import 'package:acetaxiscamberley/Pages/splashScreen.dart';
import 'package:acetaxiscamberley/app_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'Pages/pickup_location_screen.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AppInfo()),
        // Add more providers if needed
      ],
      child: MaterialApp(
        routes: {
          '/PickUpSearchScreen': (context) => PickUpSearchScreen(),
          '/DropOffSearchScreen': (context) => DropOffSearchScreen(),

          // Add other routes as needed
        },
        title: 'Your App Title',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          // Add your theme configurations here
        ),
        home: const SplashScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline6,
            ),
          ],
        ),
      ),
      floatingActionButton: Row(
        children: [
          FloatingActionButton(
            onPressed: () {
              SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
            },
            tooltip: 'Hide bar',
            child: const Icon(Icons.hide_image),
          ),
          FloatingActionButton(
            onPressed: () {
              SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
                  overlays: SystemUiOverlay.values);
            },
            tooltip: 'Show bar',
            child: const Icon(Icons.show_chart),
          ),
        ],
      ),
    );
  }
}
