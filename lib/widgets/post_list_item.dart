import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../colors/colors.dart';
import '../cubit/post_timer_cubit.dart';
import '../models/post_model.dart';

class PostListItem extends StatelessWidget {
  final PostModel post;
  final bool isRead;
  final VoidCallback onTap;

  const PostListItem({

    super.key,
    required this.post,
    required this.isRead,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final timerCubit = context.read<PostTimerCubit>();

    return VisibilityDetector(
      key: Key('post_visibility_${post.id}'),
      onVisibilityChanged: (info) {
        final visibleFraction = info.visibleFraction;
        if (visibleFraction > 0.0) {
          timerCubit.resumeTimerForPost(post.id);
        } else {
          timerCubit.pauseTimerForPost(post.id);
        }
      },
      child: BlocBuilder<PostTimerCubit, PostTimerState>(
        builder: (context, timerState) {
          final remaining = timerState.remainingSeconds[post.id] ?? post.timerDuration;
          return InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: isRead ? kwhite : kyellow,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: kgrey.withOpacity(0.2)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      post.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: isRead ? FontWeight.w400 : FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                  ),

                  // TIMER PILL UI
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.timer_outlined, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          "${remaining}s",
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
