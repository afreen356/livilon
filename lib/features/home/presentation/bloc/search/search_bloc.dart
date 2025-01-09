import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:livilon/features/home/presentation/bloc/search/search_event.dart';
import 'package:livilon/features/home/presentation/bloc/search/search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc() : super(SearchInitial()) {
    on<SearchQueryChnged>(_onSearchQueryChanged);
    on<FilterApplied>(_onFilterApplied);
  }

  FutureOr<void> _onSearchQueryChanged(
      SearchQueryChnged event, Emitter<SearchState> emit) async {
    emit(SearchLoading());
    try {
      final querySnapshot =await FirebaseFirestore.instance
          .collection('Products')
          .where('name', isGreaterThanOrEqualTo: event.query)
          .where('name', isLessThan: '${event.query}\uf8ff')
          .get();
          final results = querySnapshot.docs.map((doc) => doc.data()).toList();
          emit(SearchLoadedSuccess(results: results));
    } catch (e) {
       emit(SearchError('Failed to load results: $e'));
    }
  }

  FutureOr<void> _onFilterApplied(
      FilterApplied event, Emitter<SearchState> emit)async {
        emit(SearchLoading());
        try {
              Query query = FirebaseFirestore.instance.collection('Products');
     
        query = query.where('category', isEqualTo: event.category);
       
      
    
      final querySnapshot = await query.get();
      final results = querySnapshot.docs.map((doc) => doc.data()).toList();
      emit(SearchLoadedSuccess(results: results));
        } catch (e) {
          emit(SearchError('Error filtering products: ${e.toString()}'));
        }
      }
      
}
