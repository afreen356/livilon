abstract class SearchState {}
class SearchInitial extends SearchState{

}
class SearchLoading extends SearchState{

}

class SearchLoadedSuccess extends SearchState{
  final List<dynamic>results ;

  SearchLoadedSuccess({required this.results});

}
class SearchError extends SearchState {
  final String error;

  SearchError(this.error);
}