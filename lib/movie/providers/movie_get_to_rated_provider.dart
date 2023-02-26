import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:movie_db/movie/repositories/movie_repository.dart';

import '../models/movie_model.dart';

class MovieGetTopRatedProvider with ChangeNotifier {
  final MovieRepository _movieRepository;

  MovieGetTopRatedProvider(this._movieRepository);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  final List<MovieModel> _movies = [];
  List<MovieModel> get movies => _movies;

  void getPopular(BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    final result = await _movieRepository.getTopRated();

    result.fold(
      (messageError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(messageError),
          ),
        );

        _isLoading = false;
        notifyListeners();
        return;
      },
      (response) {
        _movies.clear();
        _movies.addAll(response.results);

        _isLoading = false;
        notifyListeners();
        return;
      },
    );
  }

  void getPopularWithPagination(
    BuildContext context, {
    required PagingController pagingController,
    required int page,
  }) async {
    final result = await _movieRepository.getTopRated();
 
   result.fold(
      (messageError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(messageError),
          ),
        );

pagingController.error = messageError;

        return;
      },
      (response) {
      if (response.results.length < 20) {
          pagingController.appendLastPage(response.results);
        } else {
          pagingController.appendPage(response.results, page + 1);
        }
        return;
      },
    );
 
  }
}
