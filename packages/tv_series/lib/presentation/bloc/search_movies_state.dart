part of 'search_movies_bloc.dart';

abstract class SearchMoviesState extends Equatable {
  const SearchMoviesState();

  @override
  List<Object> get props => [];
}

class SearchEmpty extends SearchMoviesState {}

class SearchLoading extends SearchMoviesState {}

class SearchError extends SearchMoviesState {
  final String message;

  const SearchError(this.message);

  @override
  List<Object> get props => [message];
}

class SearchHasData extends SearchMoviesState {
  final List<Movie> result;

  const SearchHasData(this.result);

  @override
  List<Object> get props => [result];
}
