import 'package:flutter/material.dart';
import 'package:peliculas/providers/movie_provider.dart';
import 'package:provider/provider.dart';

import 'screens/screens.dart';

//Linea 8 -> Linea 9
//void main() => runApp(MyApp());
void main() => runApp(AppState());

// PROVIDER}pse
class AppState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            // P se ejecuta para crear primera instancia del PROVIDER
            create: (_) => MoviesProvider(),
            lazy: false)
      ],
      child: MyApp(),
    );
  }
}

// CLASE PRINCIPAL MyAPP
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Peliculas',
        initialRoute: 'home',
        routes: {
          'home': (_) => HomeScreen(),
          'details': (_) => DetailsScreen()
        },
        // Manejar el tema LIGHT
        theme: ThemeData.light()
            .copyWith(appBarTheme: AppBarTheme(color: Colors.red)));
  }
}
