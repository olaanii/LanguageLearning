class User {
  final String id;
  final String name;
  final String avatar;
  final int streak;
  final int progress;
  final int level;
  final int score;

  const User({
    required this.id,
    required this.name,
    required this.avatar,
    required this.streak,
    required this.progress,
    required this.level,
    required this.score,
  });

  factory User.fromJson(Map<String, dynamic> json, String documentId) {
    return User(
      id: documentId,
      name: json['name'] ?? 'Learner',
      avatar: json['avatar'] ?? '',
      streak: json['streak'] ?? 0,
      progress: json['progress'] ?? 0,
      level: json['level'] ?? 1,
      score: json['score'] ?? 0,
    );
  }
}

class Lesson {
  final String id;
  final String lessonPrefix;
  final String title;
  final String description;
  final String category;
  final String difficulty;
  final bool locked;
  final int progress;
  final int totalItems;
  final String? image;
  final String? colorBg;

  const Lesson({
    required this.id,
    required this.lessonPrefix,
    required this.title,
    required this.description,
    required this.category,
    required this.difficulty,
    required this.locked,
    required this.progress,
    required this.totalItems,
    this.image,
    this.colorBg,
  });

  factory Lesson.fromJson(Map<String, dynamic> json, String documentId) {
    return Lesson(
      id: documentId,
      lessonPrefix: json['lessonPrefix'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      difficulty: json['difficulty'] ?? 'Beginners',
      locked: json['locked'] ?? false,
      progress: json['progress'] ?? 0,
      totalItems: json['totalItems'] ?? 0,
      image: json['image'],
      colorBg: json['colorBg'],
    );
  }
}

class Flashcard {
  final String id;
  final String front;
  final String back;
  final String? pronunciation;

  const Flashcard({
    required this.id,
    required this.front,
    required this.back,
    this.pronunciation,
  });

  factory Flashcard.fromJson(Map<String, dynamic> json, String documentId) {
    return Flashcard(
      id: documentId,
      front: json['front'] ?? '',
      back: json['back'] ?? '',
      pronunciation: json['pronunciation'],
    );
  }
}

class QuizQuestion {
  final String id;
  final String question;
  final List<String> options;
  final String correctAnswer;

  const QuizQuestion({
    required this.id,
    required this.question,
    required this.options,
    required this.correctAnswer,
  });

  factory QuizQuestion.fromJson(Map<String, dynamic> json, String documentId) {
    return QuizQuestion(
      id: documentId,
      question: json['question'] ?? '',
      options: List<String>.from(json['options'] ?? []),
      correctAnswer: json['correctAnswer'] ?? '',
    );
  }
}
