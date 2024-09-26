import 'package:quize_app/features/quize/models/question.dart';

final List<Question> quizQuestions = [
  const Question(
    question: "What is Flutter?",
    choices: [
      'A framework',
      'A platform',
      'An operating system',
      'A programming language',
    ],
    answer: 'A framework',
  ),
  const Question(
    question: "Which language is used to write Flutter apps?",
    choices: [
      'Java',
      'Kotlin',
      'Dart',
      'Swift',
    ],
    answer: 'Dart',
  ),
  const Question(
    question: "Who developed Flutter?",
    choices: [
      'Apple',
      'Google',
      'Facebook',
      'Microsoft',
    ],
    answer: 'Google',
  ),
  const Question(
    question: "What is the purpose of the 'pubspec.yaml' file in Flutter?",
    choices: [
      'Defines the UI structure',
      'Manages packages and assets',
      'Defines platform-specific code',
      'Configures the app icon',
    ],
    answer: 'Manages packages and assets',
  ),
  const Question(
    question: "Which of the following is a state management solution for Flutter?",
    choices: [
      'Redux',
      'Provider',
      'MobX',
      'All of the above',
    ],
    answer: 'All of the above',
  ),
  const Question(
    question: "What is the command to create a new Flutter project?",
    choices: [
      'flutter start',
      'flutter new',
      'flutter create',
      'flutter init',
    ],
    answer: 'flutter create',
  ),
  const Question(
    question: "Which widget is used to create a scrollable list in Flutter?",
    choices: [
      'Column',
      'Row',
      'ListView',
      'Stack',
    ],
    answer: 'ListView',
  ),
  const Question(
    question: "Which of the following is not a lifecycle method in Flutter?",
    choices: [
      'initState',
      'build',
      'dispose',
      'updateWidget',
    ],
    answer: 'updateWidget',
  ),
  const Question(
    question: "How do you add padding to a widget in Flutter?",
    choices: [
      'Using the Container widget',
      'Using the Padding widget',
      'Using the Scaffold widget',
      'Using the Align widget',
    ],
    answer: 'Using the Padding widget',
  ),
  const Question(
    question: "What is the use of the 'setState' method in Flutter?",
    choices: [
      'To navigate between screens',
      'To rebuild the UI',
      'To fetch data from an API',
      'To handle gestures',
    ],
    answer: 'To rebuild the UI',
  ),
];
