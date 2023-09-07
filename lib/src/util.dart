int secondsSinceEpoch() {
  return (DateTime.now().millisecondsSinceEpoch / 1000).floor();
}
