import '../models/models.dart';

class DummyData {
  static const User initialUser = User(
    id: 'user_1',
    name: 'Marion',
    avatar:
        'https://images.unsplash.com/photo-1544005313-94ddf0286df2?fit=crop&w=150&h=150&q=80',
    streak: 5,
    progress: 10,
    level: 1,
    score: 0,
  );

  static const List<Lesson> lessons = [
    Lesson(
      id: 'l1',
      lessonPrefix: 'Lesson One',
      title: 'Learn Hello World',
      description: 'Help Robo speak its very first coding words.',
      category: 'Lessons',
      difficulty: 'Beginners',
      locked: false,
      progress: 0,
      totalItems: 5,
      image:
          'https://images.unsplash.com/photo-1503676260728-1c00da094a0b?auto=format&fit=crop&q=80&w=300&h=300',
      colorBg: 'bg-indigo-50',
    ),
    Lesson(
      id: 'l2',
      lessonPrefix: 'Lesson Two',
      title: 'Loops and Repeats',
      description: 'Use loops to help Robo collect five apples.',
      category: 'Lessons',
      difficulty: 'Beginners',
      locked: true,
      progress: 0,
      totalItems: 6,
      image:
          'https://images.unsplash.com/photo-1511895426328-dc8714191300?auto=format&fit=crop&q=80&w=300&h=300',
      colorBg: 'bg-orange-50',
    ),
    Lesson(
      id: 'l3',
      lessonPrefix: 'Lesson Three',
      title: 'About Variables',
      description: 'Learn how variables store values that can change.',
      category: 'Lessons',
      difficulty: 'Intermediate',
      locked: true,
      progress: 0,
      totalItems: 6,
      image:
          'https://images.unsplash.com/photo-1577896849786-738ed6c73530?auto=format&fit=crop&q=80&w=300&h=300',
      colorBg: 'bg-purple-50',
    ),
  ];

  static const List<Flashcard> flashcards = [
    Flashcard(id: 'f1', front: 'Hello', back: 'Hola', pronunciation: '/o.la/'),
    Flashcard(
      id: 'f2',
      front: 'Thank you',
      back: 'Gracias',
      pronunciation: '/ɡɾa.sjas/',
    ),
    Flashcard(
      id: 'f3',
      front: 'Goodbye',
      back: 'Adiós',
      pronunciation: '/a.ðjos/',
    ),
    Flashcard(
      id: 'f4',
      front: 'Please',
      back: 'Por favor',
      pronunciation: '/poɾ fa.βoɾ/',
    ),
  ];

  static const List<QuizQuestion> quizQuestions = [
    QuizQuestion(
      id: 'q1',
      question: 'How do you say "Hello" in Spanish?',
      options: ['Hola', 'Adiós', 'Gracias', 'Por favor'],
      correctAnswer: 'Hola',
    ),
    QuizQuestion(
      id: 'q2',
      question: 'What does "Gracias" mean?',
      options: ['Hello', 'Please', 'Thank you', 'Goodbye'],
      correctAnswer: 'Thank you',
    ),
    QuizQuestion(
      id: 'q3',
      question: 'Select the translation for "Goodbye"',
      options: ['Por favor', 'Adiós', 'Hola', 'Amigo'],
      correctAnswer: 'Adiós',
    ),
  ];
}
