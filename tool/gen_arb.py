#!/usr/bin/env python3
"""Generates lib/l10n/app_{en,ur,en_PK}.arb from one table so keys never drift.

Roman Urdu is shipped as the `en_PK` locale. Edit the table below, then run
`python3 tool/gen_arb.py && flutter gen-l10n`.
"""
import json
from pathlib import Path

OUT = Path(__file__).resolve().parent.parent / "lib" / "l10n"

# key: (en, ur, en_PK, placeholders)  placeholders = {name: type} or None
E = {}


def add(key, en, ur, pk, ph=None):
    E[key] = (en, ur, pk, ph)


add("appName", "Saathi", "ساتھی", "Saathi")
add("navHome", "Home", "ہوم", "Home")
add("navTimetable", "Timetable", "ٹائم ٹیبل", "Timetable")
add("navQibla", "Qibla", "قبلہ", "Qibla")
add("navSettings", "Settings", "ترتیبات", "Settings")
add("ok", "OK", "ٹھیک ہے", "Theek hai")
add("cancel", "Cancel", "منسوخ", "Cancel")
add("skip", "Skip", "چھوڑیں", "Skip")
add("next", "Next", "آگے", "Aagay")
add("back", "Back", "پیچھے", "Wapas")
add("done", "Done", "مکمل", "Mukammal")
add("retry", "Try again", "دوبارہ کوشش کریں", "Dobara koshish karein")
add("close", "Close", "بند کریں", "Band karein")
add("allow", "Allow", "اجازت دیں", "Ijazat dein")
add("allowed", "Allowed", "اجازت مل گئی", "Ijazat mil gayi")
add("genericError", "Something went wrong", "کچھ غلط ہو گیا", "Kuch ghalat ho gaya")

add("prayerFajr", "Fajr", "فجر", "Fajr")
add("prayerSunrise", "Sunrise", "طلوعِ آفتاب", "Tuloo-e-Aftab")
add("prayerDhuhr", "Dhuhr", "ظہر", "Zuhr")
add("prayerAsr", "Asr", "عصر", "Asr")
add("prayerMaghrib", "Maghrib", "مغرب", "Maghrib")
add("prayerIsha", "Isha", "عشاء", "Isha")
add("prayerJumma", "Jumma", "جمعہ", "Jumma")

add("prayerTimesTitle", "Prayer times", "نماز کے اوقات", "Namaz ka waqt")
add("nextPrayer", "Next: {prayer} in {duration}",
    "اگلی نماز: {prayer}، {duration} میں", "Agli namaz: {prayer}, {duration} mein",
    {"prayer": "String", "duration": "String"})
add("sunriseAt", "Sunrise {time}", "طلوعِ آفتاب {time}", "Tuloo-e-Aftab {time}", {"time": "String"})
add("prayedLabel", "Prayed", "ادا کی", "Ada ki")
add("markPrayed", "Mark {prayer} as prayed", "{prayer} ادا کی نشان زد کریں",
    "{prayer} ada ki mark karein", {"prayer": "String"})
add("azanToggle", "Azan for {prayer}", "{prayer} کی اذان", "{prayer} ki azan", {"prayer": "String"})
add("hijriDate", "{day} {month} {year} AH", "{day} {month} {year} ھ", "{day} {month} {year} AH",
    {"day": "int", "month": "String", "year": "int"})
add("locationRefresh", "Update my location", "میری لوکیشن اپ ڈیٹ کریں", "Meri location update karein")
add("locationUpdated", "Location set to {city}", "لوکیشن {city} مقرر ہو گئی",
    "Location {city} set ho gayi", {"city": "String"})
add("locationFailed", "Could not get your location", "آپ کی لوکیشن نہیں مل سکی",
    "Aap ki location nahi mil saki")
add("durationHoursMinutes", "{hours} h {minutes} min", "{hours} گھنٹے {minutes} منٹ",
    "{hours} ghanta {minutes} min", {"hours": "int", "minutes": "int"})
add("durationMinutes", "{minutes} min", "{minutes} منٹ", "{minutes} min", {"minutes": "int"})
add("durationSeconds", "{seconds} s", "{seconds} سیکنڈ", "{seconds} sec", {"seconds": "int"})

add("bannerExactTitle", "Exact alarms are off", "درست وقت کے الارم بند ہیں", "Exact alarms band hain")
add("bannerExactBody",
    "Azan may arrive a few minutes late. Allow “Alarms & reminders” for on-time azan.",
    "اذان چند منٹ دیر سے آ سکتی ہے۔ بروقت اذان کے لیے ’الارم اور ریمائنڈرز‘ کی اجازت دیں۔",
    "Azan kuch minute late aa sakti hai. Waqt par azan ke liye “Alarms & reminders” ki ijazat dein.")
add("bannerExactAction", "Allow", "اجازت دیں", "Ijazat dein")
add("bannerNotifTitle", "Notifications are off", "نوٹیفکیشن بند ہیں", "Notifications band hain")
add("bannerNotifBody", "Turn notifications on to hear the azan.",
    "اذان سننے کے لیے نوٹیفکیشن آن کریں۔", "Azan sunne ke liye notifications on karein.")

add("tasbeehTitle", "Tasbeeh", "تسبیح", "Tasbeeh")
add("tasbeehTapHint", "Tap to count", "گننے کے لیے ٹیپ کریں", "Ginnay ke liye tap karein")
add("tasbeehReset", "Reset", "ری سیٹ", "Reset")

add("timetableTitle", "Monthly timetable", "ماہانہ ٹائم ٹیبل", "Mahana timetable")
add("shareImage", "Share as image", "تصویر کے طور پر شیئر کریں", "Image ki soorat mein share karein")
add("shareFailed", "Could not share the timetable", "ٹائم ٹیبل شیئر نہیں ہو سکا",
    "Timetable share nahi ho saka")
add("colDate", "Date", "تاریخ", "Tareekh")
add("previousMonth", "Previous month", "پچھلا مہینہ", "Pichla mahina")
add("nextMonth", "Next month", "اگلا مہینہ", "Agla mahina")

add("settingsTitle", "Settings", "ترتیبات", "Settings")
add("secLocation", "Location", "مقام", "Maqam")
add("useMyLocation", "Use my location", "میری لوکیشن استعمال کریں", "Meri location istemal karein")
add("chooseCity", "Choose a city", "شہر منتخب کریں", "Shehar chunein")
add("searchCity", "Search city", "شہر تلاش کریں", "Shehar talash karein")
add("currentLocation", "{city}, {country}", "{city}، {country}", "{city}, {country}",
    {"city": "String", "country": "String"})
add("followMe", "Update when I travel", "سفر پر خود بخود اپ ڈیٹ کریں", "Safar par khud update karein")
add("followMeHint", "Recalculates when you move more than 50 km",
    "50 کلومیٹر سے زیادہ سفر پر دوبارہ حساب ہوگا", "50 km se ziyada safar par dobara hisab hoga")
add("secCalculation", "Calculation", "حساب کا طریقہ", "Hisab ka tareeqa")
add("method", "Method", "طریقہ", "Tareeqa")
add("madhab", "Asr (madhab)", "عصر (مسلک)", "Asr (madhab)")
add("madhabHanafi", "Hanafi", "حنفی", "Hanafi")
add("madhabShafi", "Shafi’i / Maliki / Hanbali", "شافعی / مالکی / حنبلی", "Shafi’i / Maliki / Hanbali")
add("highLatRule", "High-latitude rule", "بلند عرض بلد کا اصول", "High-latitude rule")
add("highLatMiddle", "Middle of the night", "آدھی رات", "Aadhi raat")
add("highLatSeventh", "One-seventh of the night", "رات کا ساتواں حصہ", "Raat ka satwan hissa")
add("highLatAngle", "Twilight angle", "شفق کا زاویہ", "Shafaq ka zaawiya")
add("autoMethod", "Auto: {method}", "خودکار: {method}", "Auto: {method}", {"method": "String"})
add("useCountryDefaults", "Use country defaults", "ملک کے مطابق طے شدہ", "Mulk ke mutabiq default")
add("secPrayers", "Prayers", "نمازیں", "Namazein")
add("masjidAdjust", "Masjid time (± minutes)", "مسجد کا وقت (± منٹ)", "Masjid ka waqt (± minute)")
add("minutesValue", "{minutes} min", "{minutes} منٹ", "{minutes} min", {"minutes": "int"})
add("preReminder", "Reminder before prayer", "نماز سے پہلے یاد دہانی", "Namaz se pehle yaad-dehani")
add("off", "Off", "بند", "Band")
add("azanSound", "Azan sound", "اذان کی آواز", "Azan ki awaz")
add("soundBeep", "Beep", "بیپ", "Beep")
add("soundFull", "Azan (full)", "اذان (مکمل)", "Azan (mukammal)")
add("soundShort", "Azan (short)", "اذان (مختصر)", "Azan (mukhtasar)")
add("soundSilent", "Silent", "خاموش", "Khamosh")
add("audioCredits", "Audio credits", "آڈیو کا حوالہ", "Audio ka hawala")
add("audioCreditsBody",
    "Azan recording: “The Adhan - Muslim Call to Prayer - Aaqib Azeez”, shared on Wikimedia Commons by Atcovi under CC BY-SA 4.0. The short version is a trimmed copy with a fade-out. Source: commons.wikimedia.org (File:The Adhan - Muslim Call to Prayer - Aaqib Azeez.mp3). License: creativecommons.org/licenses/by-sa/4.0",
    "اذان کی ریکارڈنگ: “The Adhan - Muslim Call to Prayer - Aaqib Azeez”، جسے Atcovi نے Wikimedia Commons پر CC BY-SA 4.0 کے تحت شیئر کیا۔ مختصر ورژن اسی کی کاٹی گئی کاپی ہے جس کے آخر میں آواز مدھم ہوتی ہے۔ ماخذ: commons.wikimedia.org (File:The Adhan - Muslim Call to Prayer - Aaqib Azeez.mp3)۔ لائسنس: creativecommons.org/licenses/by-sa/4.0",
    "Azan ki recording: “The Adhan - Muslim Call to Prayer - Aaqib Azeez”, jo Atcovi ne Wikimedia Commons par CC BY-SA 4.0 ke tahat share ki. Mukhtasar version usi ki kati hui copy hai jis ke aakhir mein awaz dheemi hoti hai. Source: commons.wikimedia.org (File:The Adhan - Muslim Call to Prayer - Aaqib Azeez.mp3). License: creativecommons.org/licenses/by-sa/4.0")
add("previewSound", "Preview", "سنیں", "Suniye")
add("secHijri", "Hijri date", "ہجری تاریخ", "Hijri tareekh")
add("hijriAdjust", "Moon-sighting correction", "چاند دیکھنے کی تصحیح", "Chand dekhne ki tasheeh")
add("hijriNoChange", "No change", "کوئی تبدیلی نہیں", "Koi tabdeeli nahi")
add("hijriPlusOne", "+1 day", "+1 دن", "+1 din")
add("hijriMinusOne", "−1 day", "−1 دن", "−1 din")
add("secLanguage", "Language", "زبان", "Zubaan")
add("langEnglish", "English", "English", "English")
add("langUrdu", "اردو", "اردو", "اردو")
add("langRomanUrdu", "Roman Urdu", "Roman Urdu", "Roman Urdu")
add("testNotification", "Test notification in 10 s", "10 سیکنڈ میں ٹیسٹ نوٹیفکیشن",
    "10 second mein test notification")
add("testScheduled", "A test notification will arrive in 10 seconds",
    "10 سیکنڈ میں ٹیسٹ نوٹیفکیشن آئے گا", "10 second mein test notification aayegi")
add("testTitle", "Saathi test", "ساتھی ٹیسٹ", "Saathi test")
add("testBody", "If you can hear this, the azan will work",
    "اگر آپ یہ سن رہے ہیں تو اذان ٹھیک کام کرے گی", "Agar aap yeh sun rahe hain to azan theek kaam karegi")
add("batteryHelp", "Battery & background help", "بیٹری اور بیک گراؤنڈ مدد", "Battery aur background madad")
add("pendingCount", "{count} azan alerts scheduled", "{count} اذان الرٹس مقرر ہیں",
    "{count} azan alerts set hain", {"count": "int"})

add("qiblaTitle", "Qibla", "قبلہ", "Qibla")
add("qiblaBearing", "Qibla is {degrees}° from north", "قبلہ شمال سے {degrees}° پر ہے",
    "Qibla shimal se {degrees}° par hai", {"degrees": "int"})
add("qiblaNoSensor", "This phone has no compass sensor. Use the bearing above with a compass.",
    "اس فون میں کمپاس سینسر نہیں۔ اوپر دی گئی ڈگری کمپاس کے ساتھ استعمال کریں۔",
    "Is phone mein compass sensor nahi. Upar di gayi degree compass ke saath istemal karein.")
add("qiblaFace", "Turn until the arrow points up", "تیر کے اوپر کی طرف ہونے تک گھمائیں",
    "Teer ke upar ki taraf hone tak ghumayein")

add("stepOf", "Step {current} of {total}", "مرحلہ {current} از {total}", "Marhala {current} / {total}",
    {"current": "int", "total": "int"})
add("onbWelcomeTitle", "Assalamu alaikum", "السلام علیکم", "Assalamu alaikum")
add("onbWelcomeBody", "Saathi tells you prayer times and plays the azan, even with no internet.",
    "ساتھی آپ کو نماز کے اوقات بتاتا ہے اور اذان سناتا ہے، انٹرنیٹ کے بغیر بھی۔",
    "Saathi aap ko namaz ke auqaat batata hai aur azan sunata hai, internet ke baghair bhi.")
add("onbLanguageTitle", "Choose your language", "اپنی زبان منتخب کریں", "Apni zubaan chunein")
add("onbLocationTitle", "Your location", "آپ کا مقام", "Aap ka maqam")
add("onbLocationBody", "Used to calculate accurate prayer times. It stays on your phone.",
    "درست اوقات کے حساب کے لیے استعمال ہوتی ہے۔ یہ آپ کے فون ہی میں رہتی ہے۔",
    "Durust auqaat ke hisab ke liye istemal hoti hai. Yeh aap ke phone hi mein rehti hai.")
add("onbLocationAllow", "Use my location", "میری لوکیشن استعمال کریں", "Meri location istemal karein")
add("onbLocationManual", "Or choose a city", "یا شہر منتخب کریں", "Ya shehar chunein")
add("onbNotifTitle", "Azan notifications", "اذان کے نوٹیفکیشن", "Azan ke notifications")
add("onbNotifBody", "Allow notifications so Saathi can call you to prayer.",
    "نوٹیفکیشن کی اجازت دیں تاکہ ساتھی آپ کو نماز کے لیے بلا سکے۔",
    "Notifications ki ijazat dein taake Saathi aap ko namaz ke liye bula sake.")
add("onbExactTitle", "On-time alarms", "بروقت الارم", "Waqt par alarms")
add("onbExactBody", "Allow “Alarms & reminders” so the azan fires at the exact minute.",
    "اذان عین وقت پر بجنے کے لیے ’الارم اور ریمائنڈرز‘ کی اجازت دیں۔",
    "Azan ain waqt par bajne ke liye “Alarms & reminders” ki ijazat dein.")
add("onbOemTitle", "Keep Saathi running", "ساتھی کو چالو رکھیں", "Saathi ko chaalu rakhein")
add("onbOemBody", "Your phone may stop apps in the background. A few settings keep the azan reliable.",
    "آپ کا فون بیک گراؤنڈ ایپس بند کر سکتا ہے۔ چند ترتیبات اذان کو قابلِ اعتماد رکھتی ہیں۔",
    "Aap ka phone background apps band kar sakta hai. Chand settings azan ko qabil-e-aitmaad rakhti hain.")
add("onbOemOpen", "See the steps", "مراحل دیکھیں", "Marahil dekhein")
add("onbDoneTitle", "All set", "سب تیار ہے", "Sab tayyar hai")
add("onbDoneBody", "Saathi will call you at every prayer.", "ساتھی ہر نماز پر آپ کو بلائے گا۔",
    "Saathi har namaz par aap ko bulayega.")
add("onbStart", "Start", "شروع کریں", "Shuru karein")

add("oemTitle", "Allow background azan", "بیک گراؤنڈ اذان کی اجازت", "Background azan ki ijazat")
add("oemIntro", "{brand} phones often stop background apps to save battery. Do these steps once:",
    "{brand} فونز اکثر بیٹری بچانے کے لیے بیک گراؤنڈ ایپس بند کر دیتے ہیں۔ یہ مراحل ایک بار کریں:",
    "{brand} phones aksar battery bachane ke liye background apps band kar dete hain. Yeh steps ek baar karein:",
    {"brand": "String"})
add("oemStep1", "Open App info, then Battery, and choose “No restrictions” (or “Unrestricted”).",
    "ایپ کی معلومات کھولیں، پھر بیٹری، اور ’کوئی پابندی نہیں‘ منتخب کریں۔",
    "App info kholein, phir Battery, aur “No restrictions” (ya “Unrestricted”) chunein.")
add("oemStep2", "Turn on “Autostart” or “Auto-launch” for Saathi.",
    "ساتھی کے لیے ’آٹو اسٹارٹ‘ یا ’آٹو لانچ‘ آن کریں۔",
    "Saathi ke liye “Autostart” ya “Auto-launch” on karein.")
add("oemStep3", "In Recent apps, lock Saathi (pull its card down or long-press, then choose Lock).",
    "حالیہ ایپس میں ساتھی کو لاک کریں (کارڈ نیچے کھینچیں یا دبائے رکھیں، پھر لاک چنیں)۔",
    "Recent apps mein Saathi ko lock karein (card neeche khainchein ya dabaye rakhein, phir Lock chunein).")
add("oemStep4", "Keep notifications and notification sound switched on.",
    "نوٹیفکیشن اور نوٹیفکیشن کی آواز آن رکھیں۔",
    "Notifications aur notification ki awaz on rakhein.")
add("oemOpenSettings", "Open app settings", "ایپ کی ترتیبات کھولیں", "App settings kholein")
add("oemDontShow", "Don’t show again", "دوبارہ نہ دکھائیں", "Dobara na dikhayein")
add("oemGotIt", "Got it", "سمجھ گیا", "Samajh gaya")


def build(idx, locale):
    data = {"@@locale": locale}
    for key, vals in E.items():
        data[key] = vals[idx]
        ph = vals[3]
        if idx == 0 and ph:
            data["@" + key] = {
                "placeholders": {
                    name: ({"type": t} if t != "String" else {"type": "String"})
                    for name, t in ph.items()
                }
            }
    return data


def main():
    OUT.mkdir(parents=True, exist_ok=True)
    for idx, locale in enumerate(["en", "ur", "en_PK"]):
        path = OUT / f"app_{locale}.arb"
        path.write_text(json.dumps(build(idx, locale), ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
        print("wrote", path.name, len(E), "keys")


main()
