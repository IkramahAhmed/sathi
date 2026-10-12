import '../entities/calc_method.dart';

/// The default method and madhab for a country.
class MethodDefaults {
  const MethodDefaults(this.method, this.madhab);

  final CalcMethod method;
  final Madhab madhab;

  @override
  bool operator ==(Object other) =>
      other is MethodDefaults && other.method == method && other.madhab == madhab;

  @override
  int get hashCode => Object.hash(method, madhab);

  @override
  String toString() => 'MethodDefaults($method, $madhab)';
}

/// Maps an ISO-3166 alpha-2 country code to sensible calculation defaults.
/// A user override in settings always wins over this.
class ResolveCalculationMethodForCountry {
  const ResolveCalculationMethodForCountry();

  static const _fallback = MethodDefaults(CalcMethod.muslimWorldLeague, Madhab.shafi);

  static const Map<String, MethodDefaults> _table = {
    'PK': MethodDefaults(CalcMethod.karachi, Madhab.hanafi),
    'IN': MethodDefaults(CalcMethod.karachi, Madhab.hanafi),
    'BD': MethodDefaults(CalcMethod.karachi, Madhab.hanafi),
    'AF': MethodDefaults(CalcMethod.karachi, Madhab.hanafi),
    'SA': MethodDefaults(CalcMethod.ummAlQura, Madhab.shafi),
    'YE': MethodDefaults(CalcMethod.ummAlQura, Madhab.shafi),
    'AE': MethodDefaults(CalcMethod.dubai, Madhab.shafi),
    'QA': MethodDefaults(CalcMethod.qatar, Madhab.shafi),
    'KW': MethodDefaults(CalcMethod.kuwait, Madhab.shafi),
    'EG': MethodDefaults(CalcMethod.egyptian, Madhab.shafi),
    'SD': MethodDefaults(CalcMethod.egyptian, Madhab.shafi),
    'LY': MethodDefaults(CalcMethod.egyptian, Madhab.shafi),
    'TR': MethodDefaults(CalcMethod.turkiye, Madhab.hanafi),
    'SG': MethodDefaults(CalcMethod.singapore, Madhab.shafi),
    'MY': MethodDefaults(CalcMethod.singapore, Madhab.shafi),
    'ID': MethodDefaults(CalcMethod.indonesian, Madhab.shafi),
    'US': MethodDefaults(CalcMethod.northAmerica, Madhab.shafi),
    'CA': MethodDefaults(CalcMethod.northAmerica, Madhab.shafi),
    // GB, FR, DE and the rest of the EU use the Muslim World League, which is
    // also the global default, so they need no explicit entry.
  };

  MethodDefaults call(String countryCode) =>
      _table[countryCode.trim().toUpperCase()] ?? _fallback;
}
