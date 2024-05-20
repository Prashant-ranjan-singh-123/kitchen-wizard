import 'package:shared_preferences/shared_preferences.dart';

class HomeScreenTurorialSharedPref{
  bool isRunFirst=false;
  
  Future<bool> checkFirstRun() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    bool isFirstRun = pref.getBool('isFirstHomeTutorial') ?? true;
    if(isFirstRun){
      await pref.setBool('isFirstHomeTutorial', false);
    }
    return isFirstRun;
  }
}
class SavedScreenTurorialSharedPref{
  bool _isRunFirst=false;

  Future<bool> checkFirstRun() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    bool _isFirstRun = pref.getBool('isFirstSavedTutorial') ?? true;
    if(_isFirstRun){
      await pref.setBool('isFirstSavedTutorial', false);
    }
    return _isFirstRun;
  }
}