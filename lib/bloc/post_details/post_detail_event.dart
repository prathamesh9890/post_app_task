import 'package:equatable/equatable.dart';

class PostDetailEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadPostDetailEvent extends PostDetailEvent {
  final int postId;

  LoadPostDetailEvent(this.postId);

  @override
  List<Object?> get props => [postId];
}
