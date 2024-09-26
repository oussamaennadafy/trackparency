class Result {
  const Result({
    required this.question,
    required this.usersAnswer,
    required this.rightAnswer,
    required this.isRight,
  });
  final String question;
  final String rightAnswer;
  final String usersAnswer;
  final bool isRight;
}
