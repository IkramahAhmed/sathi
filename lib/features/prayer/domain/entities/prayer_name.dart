/// The six timed events of a prayer day. Sunrise is informational only.
enum PrayerName {
  fajr,
  sunrise,
  dhuhr,
  asr,
  maghrib,
  isha;

  /// Whether this entry has an azan (everything except sunrise).
  bool get hasAzan => this != PrayerName.sunrise;

  /// The five obligatory prayers, in order.
  static const List<PrayerName> obligatory = [fajr, dhuhr, asr, maghrib, isha];
}
