import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/features/search/data/search_repository.dart';
import 'package:social_app/features/search/presentation/cubits/search_states.dart';

class SearchCubit extends Cubit<SearchStates> {
  final SearchRepository searchRepository;

  SearchCubit({required this.searchRepository}) : super(SearchInitial());

  Future<void> searchUsers(String query) async {
    if (query.isEmpty) {
      emit(SearchInitial());
      return;
    }
    try {
      emit(SearchLoading());
      final users = await searchRepository.searchUsers(query);
      emit(SearchLoaded(users));
    } catch (e) {
      emit(SearchError('Error fetching search results:$e'));
    }
  }
}
