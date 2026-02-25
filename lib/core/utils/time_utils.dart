abstract final class TimeUtils {
  static const String _sentence = "Il est l'heure";
  static const List<int> _pastisMinutes = [6, 10, 26, 36, 46, 56];

  static String whatToDo(int hour, int minute) {
    if (_pastisMinutes.contains(minute)) {
      return "$_sentence du Pastis \ud83e\udd43";
    }
    if (minute == 15) {
      return "$_sentence du Ricard \ud83e\udd43";
    }
    if (hour >= 11 && hour < 12) {
      return "$_sentence de l'Ap\u00e9ro ! \ud83c\udf7b";
    }
    if (hour >= 17 && hour < 20) {
      return "$_sentence de l'Ap\u00e9ro (avec du saucisson) ! \ud83c\udf7b";
    }
    if (hour == 12 || (hour == 13 && minute < 30)) {
      return "$_sentence du vin \ud83c\udf77";
    }
    if (hour >= 20 && hour < 22) {
      return "$_sentence du vin \ud83c\udf77";
    }
    if ((hour == 13 && minute >= 30) || hour == 14) {
      return "$_sentence du dijo !";
    }
    // Fixed: overnight condition (22:00 -> 03:00)
    if (hour >= 22 || hour < 3) {
      return "$_sentence du cocktail \ud83c\udf79";
    }
    if (hour >= 3 && hour < 7) {
      return "$_sentence du dodo \ud83d\ude34";
    }
    return "Il n'est pas encore l'heure de boire ! (Officiellement) \ud83d\ude07";
  }

  static String formatTime(int value) => value.toString().padLeft(2, '0');
}
