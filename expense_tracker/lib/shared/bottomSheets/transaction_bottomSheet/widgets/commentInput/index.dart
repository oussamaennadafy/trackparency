import 'package:flutter/material.dart';

class CommentInput extends StatelessWidget {
  const CommentInput({
    super.key,
    required this.commentInputController,
  });

  final TextEditingController commentInputController;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: Container(
        alignment: Alignment.center,
        child: TextField(
          controller: commentInputController,
          textAlign: TextAlign.center,
          decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: 'Add comment...',
          ),
        ),
      ),
    );
  }
}
