import 'package:flutter/widgets.dart';
import 'package:flutter_tv_series_app/main.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  initCoreInjection();
  initMovieInjection();
  initTvSeriesInjection();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
