abstract class SearchEvent {}
class SearchQueryChnged extends SearchEvent{
   final String query;

  SearchQueryChnged({required this.query});
   
}
class FilterApplied extends SearchEvent{
  final String category;
  final String priceRange;

  FilterApplied({required this.category, required this.priceRange});


}