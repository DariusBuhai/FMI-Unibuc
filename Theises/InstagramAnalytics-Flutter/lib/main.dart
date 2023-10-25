import 'package:instagram_analytics/tabbed_app.dart';
import 'package:instagram_analytics/utils/settings.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:instagram_analytics/utils/theme.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  await Hive.initFlutter();

  await Hive.openBox('options');
  await Hive.openBox('auth');

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver{

  Settings settingsProvider = Settings();

  @override
  void initState() {
    settingsProvider.initSettings().then((value){
      settingsProvider.onChangePlatformBrightness(WidgetsBinding.instance.window.platformBrightness);
    });
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    settingsProvider.dispose();
    super.dispose();
  }

  @override
  void didChangePlatformBrightness() async{
    settingsProvider.onChangePlatformBrightness(WidgetsBinding.instance.window.platformBrightness);
    super.didChangePlatformBrightness();
  }

  @override
  Widget build(BuildContext context) {

    return ValueListenableBuilder(
      valueListenable: Hive.box('options').listenable(),
      builder: (BuildContext context, value, Widget child) {
        return GestureDetector(
          onTap: (){
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) => settingsProvider),
            ],
            child: Consumer<Settings>(
              builder: (context, _, __){
                return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  title: 'News Stocks',
                  theme: Styles.themeData(settingsProvider.darkMode, context),
                  home: const TabbedApp()
                );
              }
            ),
          ),
        );
      },
    );

  }
}
