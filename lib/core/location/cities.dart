/// A bundled city, used for manual selection and as an offline fallback when
/// reverse geocoding is unavailable.
class City {
  const City(this.name, this.countryCode, this.lat, this.lng, this.timezoneId);

  final String name;
  final String countryCode;
  final double lat;
  final double lng;
  final String timezoneId;
}

const List<City> kCities = [
  City('Karachi', 'PK', 24.8607, 67.0011, 'Asia/Karachi'),
  City('Lahore', 'PK', 31.5204, 74.3587, 'Asia/Karachi'),
  City('Islamabad', 'PK', 33.6844, 73.0479, 'Asia/Karachi'),
  City('Rawalpindi', 'PK', 33.5651, 73.0169, 'Asia/Karachi'),
  City('Faisalabad', 'PK', 31.4504, 73.1350, 'Asia/Karachi'),
  City('Multan', 'PK', 30.1575, 71.5249, 'Asia/Karachi'),
  City('Peshawar', 'PK', 34.0151, 71.5249, 'Asia/Karachi'),
  City('Quetta', 'PK', 30.1798, 66.9750, 'Asia/Karachi'),
  City('Hyderabad', 'PK', 25.3960, 68.3578, 'Asia/Karachi'),
  City('Sialkot', 'PK', 32.4945, 74.5229, 'Asia/Karachi'),
  City('Gujranwala', 'PK', 32.1877, 74.1945, 'Asia/Karachi'),
  City('Bahawalpur', 'PK', 29.3544, 71.6911, 'Asia/Karachi'),
  City('Sukkur', 'PK', 27.7052, 68.8574, 'Asia/Karachi'),
  City('Abbottabad', 'PK', 34.1463, 73.2117, 'Asia/Karachi'),
  City('Muzaffarabad', 'PK', 34.3700, 73.4711, 'Asia/Karachi'),
  City('Gilgit', 'PK', 35.9208, 74.3080, 'Asia/Karachi'),
  City('Makkah', 'SA', 21.4225, 39.8262, 'Asia/Riyadh'),
  City('Madinah', 'SA', 24.5247, 39.5692, 'Asia/Riyadh'),
  City('Riyadh', 'SA', 24.7136, 46.6753, 'Asia/Riyadh'),
  City('Jeddah', 'SA', 21.4858, 39.1925, 'Asia/Riyadh'),
  City('Dubai', 'AE', 25.2048, 55.2708, 'Asia/Dubai'),
  City('Doha', 'QA', 25.2854, 51.5310, 'Asia/Qatar'),
  City('Kuwait City', 'KW', 29.3759, 47.9774, 'Asia/Kuwait'),
  City('Istanbul', 'TR', 41.0082, 28.9784, 'Europe/Istanbul'),
  City('Cairo', 'EG', 30.0444, 31.2357, 'Africa/Cairo'),
  City('Dhaka', 'BD', 23.8103, 90.4125, 'Asia/Dhaka'),
  City('Delhi', 'IN', 28.6139, 77.2090, 'Asia/Kolkata'),
  City('Mumbai', 'IN', 19.0760, 72.8777, 'Asia/Kolkata'),
  City('Kabul', 'AF', 34.5553, 69.2075, 'Asia/Kabul'),
  City('Kuala Lumpur', 'MY', 3.1390, 101.6869, 'Asia/Kuala_Lumpur'),
  City('Singapore', 'SG', 1.3521, 103.8198, 'Asia/Singapore'),
  City('Jakarta', 'ID', -6.2088, 106.8456, 'Asia/Jakarta'),
  City('London', 'GB', 51.5074, -0.1278, 'Europe/London'),
  City('Manchester', 'GB', 53.4808, -2.2426, 'Europe/London'),
  City('Paris', 'FR', 48.8566, 2.3522, 'Europe/Paris'),
  City('Berlin', 'DE', 52.5200, 13.4050, 'Europe/Berlin'),
  City('New York', 'US', 40.7128, -74.0060, 'America/New_York'),
  City('Toronto', 'CA', 43.6532, -79.3832, 'America/Toronto'),
];
