class AppFormatters {
  static String formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '${_twoDigits(hours)}:${_twoDigits(minutes)}:${_twoDigits(seconds)}';
    }
    return '${_twoDigits(minutes)}:${_twoDigits(seconds)}';
  }

  static String formatListeningTime(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }

  static String formatHoursMinutes(double totalHours) {
    final hours = totalHours.floor();
    final minutes = ((totalHours - hours) * 60).round();
    return '${hours}h ${minutes}m';
  }

  static String formatDate(DateTime date) {
    return '${_twoDigits(date.day)}/${_twoDigits(date.month)}/${date.year}';
  }

  static String formatUserName(String firstName, String lastName) {
    return '$firstName $lastName';
  }

  static String _twoDigits(int n) {
    return n.toString().padLeft(2, '0');
  }
}
