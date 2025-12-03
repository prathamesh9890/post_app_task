import 'dart:math';

class PostModel {
  final int id;
  final int userId;
  final String title;
  final String body;
  final int timerDuration;

  PostModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    required this.timerDuration,
  });

  static final _random = Random();

  static int _generateRandomDuration() {
    const options = [10, 20, 25];
    return options[_random.nextInt(options.length)];
  }

  factory PostModel.fromJson(Map<String, dynamic> json) {
    final timerFromJson = json['timerDuration'];
    return PostModel(
      id: json['id'] as int,
      userId: json['userId'] as int,
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
      timerDuration: timerFromJson is int ? timerFromJson : _generateRandomDuration(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'id': id,
      'title': title,
      'body': body,
      'timerDuration': timerDuration,
    };
  }

  PostModel copyWith({
    int? id,
    int? userId,
    String? title,
    String? body,
    int? timerDuration,
  }) {
    return PostModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      body: body ?? this.body,
      timerDuration: timerDuration ?? this.timerDuration,
    );
  }
}
