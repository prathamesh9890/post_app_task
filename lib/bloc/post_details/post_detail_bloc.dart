import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/post_repository.dart';
import 'post_detail_event.dart';
import 'post_detail_state.dart';

class PostDetailBloc extends Bloc<PostDetailEvent, PostDetailState> {
  final PostRepository repository;

  PostDetailBloc({required this.repository}) : super(PostDetailInitial()) {
    on<LoadPostDetailEvent>(_onLoadDetail);
  }

  Future<void> _onLoadDetail(
      LoadPostDetailEvent event, Emitter<PostDetailState> emit) async {
    emit(PostDetailLoading());
    try {
      final post = await repository.getPostDetail(event.postId);
      emit(PostDetailLoaded(post));
    } catch (e) {
      emit(PostDetailError('Failed to load post details. Please try again.'));
    }
  }
}
