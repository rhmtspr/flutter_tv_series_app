import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tv_series_app/domain/entities/tv_series.dart';
import 'package:flutter_tv_series_app/domain/usecases/search_tv_series.dart';
import 'package:rxdart/rxdart.dart';

part 'search_tv_series_event.dart';
part 'search_tv_series_state.dart';

class SearchTvSeriesBloc
    extends Bloc<SearchTvSeriesEvent, SearchTvSeriesState> {
  final SearchTvSeries _searchTvSeries;

  SearchTvSeriesBloc(this._searchTvSeries) : super(SearchEmpty()) {
    on<OnQueryChanged>((event, emit) async {
      final query = event.query;

      emit(SearchLoading());
      final result = await _searchTvSeries.execute(query);

      result.fold(
        (failure) {
          emit(SearchError(failure.message));
        },
        (data) {
          emit(SearchHasData(data));
        },
      );
    }, transformer: debounce(const Duration(milliseconds: 500)));
  }
}

EventTransformer<T> debounce<T>(Duration duration) {
  return (events, mapper) => events.debounceTime(duration).flatMap(mapper);
}
