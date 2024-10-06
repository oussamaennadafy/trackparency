class TabButton {
  const TabButton({
    required this.id,
    required this.label,
    required this.onPressed,
  });

  final String id;
  final String label;
  final void Function() onPressed;
}
