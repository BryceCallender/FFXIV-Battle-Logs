extension DurationUtils on Duration {
  String toHHMMSS() {
    final hh = (this.inHours).toString();
    final mm = (this.inMinutes % 60).toString();
    final ss = (this.inSeconds % 60).toString().padLeft(2, '0');

    if (this.inHours > 0) {
      return '$hh:$mm:$ss';
    } else {
      return '$mm:$ss';
    }

  }
}