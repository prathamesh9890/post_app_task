import 'package:equatable/equatable.dart';

class PostListEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadPostsEvent extends PostListEvent {}

class MarkPostReadEvent extends PostListEvent {
  final int postId;
  MarkPostReadEvent(this.postId);

  @override
  List<Object?> get props => [postId];
}
