import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:movie_db/app_constants.dart';
import 'package:movie_db/movie/pages/movie_page.dart';
import 'package:movie_db/movie/repositories/movie_repository.dart';
import 'package:movie_db/movie/repositories/movie_repository_impl.dart';
import 'package:provider/provider.dart';

import 'movie/providers/movie_get_discover_provider.dart';
import 'movie/providers/movie_get_now_playing_provider.dart';
import 'movie/providers/movie_get_top_rated_provider.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

final dioOptions = BaseOptions(
  baseUrl: AppConstants.baseUrl,
  queryParameters: { 'api_key': AppConstants.apiKey},
);


  final Dio dio = Dio(dioOptions);
  final MovieRepository movieRepository = MovieRepositoryImpl(dio);
 
 runApp(App(movieRepository: movieRepository));
  FlutterNativeSplash.remove();
}

class App extends StatelessWidget {
  const App({super.key, required this.movieRepository});

  final  MovieRepository movieRepository;

  @override
  Widget build(BuildContext context) {

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => MovieGetDiscoverProvider(movieRepository),
          ),
          ChangeNotifierProvider(
          create: (_) => MovieGetTopRatedProvider(movieRepository),
          ),
          ChangeNotifierProvider(
          create: (_) => MovieGetNowPlayingProvider(movieRepository),
          ),
      ],
      child: MaterialApp(
        title: 'CineVault',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MoviePage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
