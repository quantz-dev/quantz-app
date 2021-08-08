DateTime _now = DateTime.now().toUtc();
String getFuzzyDay(int timestamp) {
  if (timestamp == -1) {
    return 'is available now';
  }
  var nowMillis = _now.millisecondsSinceEpoch ~/ 1000;
  var diff = timestamp - nowMillis;
  var diffDuration = Duration(milliseconds: diff * 1000);
  var days = diffDuration.inDays;
  if (days == 0) {
    var inHours = diffDuration.inHours;
    if (inHours > 0) {
      return 'in ${inHours == 1 ? "an" : inHours} hour${inHours == 1 ? "" : "s"}';
    }
    var inMinutes = diffDuration.inMinutes;
    if (inMinutes > 40) {
      return 'in an hour';
    }
    return 'in a few minutes';
  } else {
    return 'in ${days == 1 ? "a" : days} day${days == 1 ? "" : "s"}';
  }
}
