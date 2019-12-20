import 'package:flutter/material.dart';
import 'package:preferences/preferences.dart';
import 'package:quran_images/data/data_client.dart';
import 'package:quran_images/data/tafseer_data_client.dart';

import 'my_app.dart';

main() async {
  await init();
  runApp(RestartWidget(
    child: MyApp(),
  ));
}

init() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PrefService.init(prefix: 'pref_');
  Map<String,Object> defaultValues = new Map();
  defaultValues["audio_player_sound"] = "Abdurrahmaan_As-Sudais_64kbps";
  defaultValues["start_page"] = 1;
  defaultValues["lang"] = "ar";
  defaultValues["is_first_time"] = true;
  PrefService.setDefaultValues(defaultValues);
  DataBaseClient dataBaseClient = DataBaseClient.instance;
  dataBaseClient.initDatabase();
  TafseerDataBaseClient tafseerDataBaseClient = TafseerDataBaseClient.instance;
  tafseerDataBaseClient.initDatabase();
}

class RestartWidget extends StatefulWidget {
  final Widget child;

  RestartWidget({this.child});

  static restartApp(BuildContext context) {
    final _RestartWidgetState state =
    context.ancestorStateOfType(const TypeMatcher<_RestartWidgetState>());
    state.restartApp();
  }

  @override
  _RestartWidgetState createState() => new _RestartWidgetState();
}

class _RestartWidgetState extends State<RestartWidget> {
  Key key = new UniqueKey();

  void restartApp() {
    this.setState(() {
      key = new UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      key: key,
      child: widget.child,
    );
  }
}