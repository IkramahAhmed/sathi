/// Calculation method presets. Mirrors the presets offered by `adhan_dart`
/// without leaking that package into the domain layer.
enum CalcMethod {
  karachi('University of Islamic Sciences, Karachi'),
  muslimWorldLeague('Muslim World League'),
  ummAlQura('Umm al-Qura'),
  dubai('Dubai'),
  qatar('Qatar'),
  kuwait('Kuwait'),
  egyptian('Egyptian General Authority of Survey'),
  turkiye('Turkiye (Diyanet)'),
  singapore('Singapore'),
  indonesian('Indonesia (KEMENAG)'),
  northAmerica('North America (ISNA)'),
  moonsightingCommittee('Moonsighting Committee');

  const CalcMethod(this.displayName);
  final String displayName;
}

/// Juristic school used for Asr.
enum Madhab {
  hanafi,
  shafi;

  String get displayName => this == hanafi ? 'Hanafi' : "Shafi'i / Maliki / Hanbali";
}

/// How Fajr / Isha are derived where twilight never ends.
enum HighLatitudeRule {
  middleOfTheNight,
  seventhOfTheNight,
  twilightAngle;

  String get displayName => switch (this) {
        middleOfTheNight => 'Middle of the night',
        seventhOfTheNight => 'One-seventh of the night',
        twilightAngle => 'Twilight angle',
      };
}

/// Bundled azan sounds. Each one has its own notification channel because
/// Android caches a channel's sound for good.
enum AzanSound {
  /// A plain three-beep tone.
  beep('azan_beep'),

  /// The complete azan recording (about 1½ minutes). Android only: iOS limits
  /// notification sounds to 30 seconds, so it plays [short] there.
  full('azan_full'),

  /// The opening of the azan, trimmed to under 30 seconds.
  short('azan_short'),
  silent('azan_silent');

  const AzanSound(this.channelId);

  /// Notification channel id and, except for [silent], raw resource name.
  final String channelId;

  bool get isSilent => this == silent;

  /// Parses a stored value. Older versions saved `makkah` and `madina`; those
  /// placeholder sounds map to the real recordings that replaced them.
  static AzanSound fromStored(String? name) => switch (name) {
        'full' || 'makkah' => AzanSound.full,
        'short' || 'madina' => AzanSound.short,
        'silent' => AzanSound.silent,
        _ => AzanSound.beep,
      };
}
