import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/post_model.dart';


class PostTimerState extends Equatable {
  final Map<int, int> remainingSeconds; // postId -> remaining seconds
  final Map<int, bool> isRunning; // postId -> is running

  const PostTimerState({
    required this.remainingSeconds,
    required this.isRunning,
  });

  factory PostTimerState.initial() =>
      const PostTimerState(remainingSeconds: {}, isRunning: {});

  PostTimerState copyWith({
    Map<int, int>? remainingSeconds,
    Map<int, bool>? isRunning,
  }) {
    return PostTimerState(
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      isRunning: isRunning ?? this.isRunning,
    );
  }

  @override
  List<Object?> get props => [remainingSeconds, isRunning];
}

class PostTimerCubit extends Cubit<PostTimerState> {
  Timer? _ticker;

  PostTimerCubit() : super(PostTimerState.initial());

  void initializeTimers(List<PostModel> posts) {
    // if it is already initialized then skip
    if (state.remainingSeconds.isNotEmpty) return;

    final remaining = <int, int>{};
    final running = <int, bool>{};

    for (final p in posts) {
      remaining[p.id] = p.timerDuration;
      running[p.id] = false;
    }

    emit(PostTimerState(remainingSeconds: remaining, isRunning: running));
    _startTicker();
  }

  void _startTicker() {
    _ticker ??= Timer.periodic(const Duration(seconds: 1), (_) {
      _onTick();
    });
  }

  void _onTick() {
    final current = state;
    final newRemaining = Map<int, int>.from(current.remainingSeconds);

    bool changed = false;

    current.isRunning.forEach((postId, running) {
      if (running && (newRemaining[postId] ?? 0) > 0) {
        newRemaining[postId] = (newRemaining[postId]! - 1).clamp(0, 9999);
        changed = true;
      }
    });

    if (changed) {
      emit(current.copyWith(remainingSeconds: newRemaining));
    }
  }

  void resumeTimerForPost(int postId) {
    if (!state.remainingSeconds.containsKey(postId)) return;
    if (state.remainingSeconds[postId] == 0) return;

    final newRunning = Map<int, bool>.from(state.isRunning);
    newRunning[postId] = true;
    emit(state.copyWith(isRunning: newRunning));
  }

  void pauseTimerForPost(int postId) {
    if (!state.isRunning.containsKey(postId)) return;
    final newRunning = Map<int, bool>.from(state.isRunning);
    newRunning[postId] = false;
    emit(state.copyWith(isRunning: newRunning));
  }

  int getRemainingForPost(int postId) {
    return state.remainingSeconds[postId] ?? 0;
  }

  @override
  Future<void> close() {
    _ticker?.cancel();
    return super.close();
  }
}
