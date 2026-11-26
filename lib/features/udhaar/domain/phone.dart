/// Turns a number as typed ("0300…", "300…", "+92 300…", "0092300…") into the
/// digits wa.me expects, with the country code and no leading zeros.
/// Returns null when it cannot be a real phone number.
String? whatsAppNumber(String raw) {
  var digits = raw.replaceAll(RegExp(r'[^0-9]'), '');
  if (digits.isEmpty) return null;
  if (digits.startsWith('00')) {
    digits = digits.substring(2);
  } else if (digits.startsWith('0')) {
    digits = '92${digits.substring(1)}';
  } else if (digits.length == 10 && digits.startsWith('3')) {
    digits = '92$digits';
  }
  return digits.length >= 10 && digits.length <= 15 ? digits : null;
}
