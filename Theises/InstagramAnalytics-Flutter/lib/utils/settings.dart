import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings with ChangeNotifier{

  bool _darkMode = false;
  bool _switchAutomatically = false;

  Future<bool> getDarkMode() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool("DARK_MODE") ?? false;
  }

  Future<bool> getSwitchAutomatically() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool("SWITCH_AUTOMATICALLY") ?? false;
  }

  void onChangePlatformBrightness(Brightness platformBrightness){
    if(_switchAutomatically) {
      darkMode = platformBrightness == Brightness.dark;
    }
  }

  Future<void> initSettings() async{
    _switchAutomatically = await getSwitchAutomatically();
    _darkMode = await getDarkMode();
    notifyListeners();
  }

  get darkMode => _darkMode;
  get switchAutomatically => _switchAutomatically;

  set darkMode(bool value){
    SharedPreferences.getInstance().then((prefs){
      prefs.setBool("DARK_MODE", value);
      _darkMode = value;
      notifyListeners();
    });
  }

  set switchAutomatically(bool value) {
    if(value) {
      darkMode = WidgetsBinding.instance.window.platformBrightness==Brightness.dark;
    }
    SharedPreferences.getInstance().then((prefs){
      prefs.setBool("SWITCH_AUTOMATICALLY", value);
      _switchAutomatically = value;
      notifyListeners();
    });
  }

}