import 'package:tymoff/SharedPref/SharedPrefUtil.dart';
import 'package:tymoff/Utils/AppTheme/ThemeModel.dart';
import 'package:rxdart/rxdart.dart';

class ThemeBloc {

  ThemeBloc(){
    getAppTheme();
  }

  SharedPrefUtil _prefs = SharedPrefUtil();
  final _themeController = BehaviorSubject<ThemeModel>();

  Stream<ThemeModel> get getTheme => _themeController.stream;
  Sink<ThemeModel> get setTheme => _themeController.sink;

  void updateTheme(ThemeModel model) async {
    _themeController.sink.add(model);
    var isThemeSave = await _prefs.saveTheme(model.name);
    print(isThemeSave);
    print("My theme is -> ${model.name}");
  }

   getAppTheme() async {
    String theme;
    final user = await SharedPrefUtil.getTheme();
    if(user == ThemeModel.THEME_LIGHT){
      theme = user;
    } else if(user == ThemeModel.THEME_DARK){
      theme = user;
    }
    return theme;
  }

  void dispose() {
    _themeController.close();
  }
}