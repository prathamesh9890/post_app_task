import 'package:equatable/equatable.dart';
import '../../models/post_model.dart';

class PostListState extends Equatable {
  @override
  List<Object?> get props => [];
}

class PostListInitial extends PostListState {}

class PostListLoading extends PostListState {}

class PostListLoaded extends PostListState {
  final List<PostModel> posts;
  final Set<int> readPostIds;
  final bool fromCache;
  final String? message;

  PostListLoaded({
    required this.posts,
    required this.readPostIds,
    required this.fromCache,
    this.message,
  });

  PostListLoaded copyWith({
    List<PostModel>? posts,
    Set<int>? readPostIds,
    bool? fromCache,
    String? message,
  }) {
    return PostListLoaded(
      posts: posts ?? this.posts,
      readPostIds: readPostIds ?? this.readPostIds,
      fromCache: fromCache ?? this.fromCache,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [posts, readPostIds, fromCache, message];
}

class PostListError extends PostListState {
  final String message;

  PostListError(this.message);

  @override
  List<Object?> get props => [message];
}
