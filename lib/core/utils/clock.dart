/// Returns the current absolute instant (UTC). Injected so time-dependent
/// logic can be tested deterministically.
typedef Clock = DateTime Function();

DateTime systemClock() => DateTime.now().toUtc();
