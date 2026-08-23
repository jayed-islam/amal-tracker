class LocationInfo {
  final String nameBn;
  final String nameEn;
  final double latitude;
  final double longitude;
  final String? divisionBn;
  final bool isForeign;

  const LocationInfo({
    required this.nameBn,
    required this.nameEn,
    required this.latitude,
    required this.longitude,
    this.divisionBn,
    this.isForeign = false,
  });
}

class LocationData {
  /// All 64 Districts of Bangladesh with static coordinates
  static const List<LocationInfo> bdDistricts = [
    // Dhaka Division
    LocationInfo(nameBn: 'ঢাকা', nameEn: 'Dhaka', latitude: 23.8103, longitude: 90.4125, divisionBn: 'ঢাকা'),
    LocationInfo(nameBn: 'ফরিদপুর', nameEn: 'Faridpur', latitude: 23.6071, longitude: 89.8425, divisionBn: 'ঢাকা'),
    LocationInfo(nameBn: 'গাজীপুর', nameEn: 'Gazipur', latitude: 24.0023, longitude: 90.4264, divisionBn: 'ঢাকা'),
    LocationInfo(nameBn: 'গোপালগঞ্জ', nameEn: 'Gopalganj', latitude: 23.0051, longitude: 89.8266, divisionBn: 'ঢাকা'),
    LocationInfo(nameBn: 'কিশোরগঞ্জ', nameEn: 'Kishoreganj', latitude: 24.4449, longitude: 90.7766, divisionBn: 'ঢাকা'),
    LocationInfo(nameBn: 'মাদারীপুর', nameEn: 'Madaripur', latitude: 23.1641, longitude: 90.1897, divisionBn: 'ঢাকা'),
    LocationInfo(nameBn: 'মানিকগঞ্জ', nameEn: 'Manikganj', latitude: 23.8644, longitude: 90.0047, divisionBn: 'ঢাকা'),
    LocationInfo(nameBn: 'মুন্সীগঞ্জ', nameEn: 'Munshiganj', latitude: 23.5422, longitude: 90.5305, divisionBn: 'ঢাকা'),
    LocationInfo(nameBn: 'নারায়ণগঞ্জ', nameEn: 'Narayanganj', latitude: 23.6238, longitude: 90.5000, divisionBn: 'ঢাকা'),
    LocationInfo(nameBn: 'নরসিংদী', nameEn: 'Narsingdi', latitude: 23.9193, longitude: 90.7206, divisionBn: 'ঢাকা'),
    LocationInfo(nameBn: 'রাজবাড়ী', nameEn: 'Rajbari', latitude: 23.7574, longitude: 89.6444, divisionBn: 'ঢাকা'),
    LocationInfo(nameBn: 'শরীয়তপুর', nameEn: 'Shariatpur', latitude: 23.2423, longitude: 90.4348, divisionBn: 'ঢাকা'),
    LocationInfo(nameBn: 'টাঙ্গাইল', nameEn: 'Tangail', latitude: 24.2513, longitude: 89.9167, divisionBn: 'ঢাকা'),

    // Chattogram Division
    LocationInfo(nameBn: 'চট্টগ্রাম', nameEn: 'Chattogram', latitude: 22.3569, longitude: 91.7832, divisionBn: 'চট্টগ্রাম'),
    LocationInfo(nameBn: 'বান্দরবান', nameEn: 'Bandarban', latitude: 21.8311, longitude: 92.3686, divisionBn: 'চট্টগ্রাম'),
    LocationInfo(nameBn: 'ব্রাহ্মণবাড়িয়া', nameEn: 'Brahmanbaria', latitude: 23.9571, longitude: 91.1119, divisionBn: 'চট্টগ্রাম'),
    LocationInfo(nameBn: 'চাঁদপুর', nameEn: 'Chandpur', latitude: 23.2333, longitude: 90.6667, divisionBn: 'চট্টগ্রাম'),
    LocationInfo(nameBn: 'কুমিল্লা', nameEn: 'Cumilla', latitude: 23.4607, longitude: 91.1809, divisionBn: 'চট্টগ্রাম'),
    LocationInfo(nameBn: 'কক্সবাজার', nameEn: "Cox's Bazar", latitude: 21.4272, longitude: 92.0058, divisionBn: 'চট্টগ্রাম'),
    LocationInfo(nameBn: 'ফেনী', nameEn: 'Feni', latitude: 23.0159, longitude: 91.3976, divisionBn: 'চট্টগ্রাম'),
    LocationInfo(nameBn: 'খাগড়াছড়ি', nameEn: 'Khagrachhari', latitude: 23.1193, longitude: 91.9847, divisionBn: 'চট্টগ্রাম'),
    LocationInfo(nameBn: 'লক্ষ্মীপুর', nameEn: 'Lakshmipur', latitude: 22.9447, longitude: 90.8282, divisionBn: 'চট্টগ্রাম'),
    LocationInfo(nameBn: 'নোয়াখালী', nameEn: 'Noakhali', latitude: 22.8696, longitude: 91.0995, divisionBn: 'চট্টগ্রাম'),
    LocationInfo(nameBn: 'রাঙ্গামাটি', nameEn: 'Rangamati', latitude: 22.6533, longitude: 92.1753, divisionBn: 'চট্টগ্রাম'),

    // Rajshahi Division
    LocationInfo(nameBn: 'রাজশাহী', nameEn: 'Rajshahi', latitude: 24.3745, longitude: 88.6042, divisionBn: 'রাজশাহী'),
    LocationInfo(nameBn: 'বগুড়া', nameEn: 'Bogura', latitude: 24.8481, longitude: 89.3730, divisionBn: 'রাজশাহী'),
    LocationInfo(nameBn: 'জয়পুরহাট', nameEn: 'Joypurhat', latitude: 25.1016, longitude: 89.0267, divisionBn: 'রাজশাহী'),
    LocationInfo(nameBn: 'নওগাঁ', nameEn: 'Naogaon', latitude: 24.7936, longitude: 88.9318, divisionBn: 'রাজশাহী'),
    LocationInfo(nameBn: 'নাটোর', nameEn: 'Natore', latitude: 24.4102, longitude: 89.0076, divisionBn: 'রাজশাহী'),
    LocationInfo(nameBn: 'চাঁপাইনবাবগঞ্জ', nameEn: 'Chapainawabganj', latitude: 24.5965, longitude: 88.2775, divisionBn: 'রাজশাহী'),
    LocationInfo(nameBn: 'পাবনা', nameEn: 'Pabna', latitude: 24.0114, longitude: 89.2568, divisionBn: 'রাজশাহী'),
    LocationInfo(nameBn: 'সিরাজগঞ্জ', nameEn: 'Sirajganj', latitude: 24.4534, longitude: 89.7008, divisionBn: 'রাজশাহী'),

    // Khulna Division
    LocationInfo(nameBn: 'খুলনা', nameEn: 'Khulna', latitude: 22.8456, longitude: 89.5403, divisionBn: 'খুলনা'),
    LocationInfo(nameBn: 'বাগেরহাট', nameEn: 'Bagerhat', latitude: 22.6516, longitude: 89.7859, divisionBn: 'খুলনা'),
    LocationInfo(nameBn: 'চুয়াডাঙ্গা', nameEn: 'Chuadanga', latitude: 23.6402, longitude: 88.8418, divisionBn: 'খুলনা'),
    LocationInfo(nameBn: 'যশোর', nameEn: 'Jashore', latitude: 23.1664, longitude: 89.2081, divisionBn: 'খুলনা'),
    LocationInfo(nameBn: 'ঝিনাইদহ', nameEn: 'Jhenaidah', latitude: 23.5448, longitude: 89.1539, divisionBn: 'খুলনা'),
    LocationInfo(nameBn: 'কুষ্টিয়া', nameEn: 'Kushtia', latitude: 23.9013, longitude: 88.9560, divisionBn: 'খুলনা'),
    LocationInfo(nameBn: 'মাগুরা', nameEn: 'Magura', latitude: 23.4873, longitude: 89.4199, divisionBn: 'খুলনা'),
    LocationInfo(nameBn: 'মেহেরপুর', nameEn: 'Meherpur', latitude: 23.7622, longitude: 88.6318, divisionBn: 'খুলনা'),
    LocationInfo(nameBn: 'নড়াইল', nameEn: 'Narail', latitude: 23.1725, longitude: 89.5127, divisionBn: 'খুলনা'),
    LocationInfo(nameBn: 'সাতক্ষীরা', nameEn: 'Satkhira', latitude: 22.7185, longitude: 89.0705, divisionBn: 'খুলনা'),

    // Barishal Division
    LocationInfo(nameBn: 'বরিশাল', nameEn: 'Barishal', latitude: 22.7010, longitude: 90.3535, divisionBn: 'বরিশাল'),
    LocationInfo(nameBn: 'বরগুনা', nameEn: 'Barguna', latitude: 22.1570, longitude: 90.1246, divisionBn: 'বরিশাল'),
    LocationInfo(nameBn: 'ভোলা', nameEn: 'Bhola', latitude: 22.6859, longitude: 90.6482, divisionBn: 'বরিশাল'),
    LocationInfo(nameBn: 'ঝালকাঠি', nameEn: 'Jhalokathi', latitude: 22.6406, longitude: 90.1987, divisionBn: 'বরিশাল'),
    LocationInfo(nameBn: 'পটুয়াখালী', nameEn: 'Patuakhali', latitude: 22.3596, longitude: 90.3299, divisionBn: 'বরিশাল'),
    LocationInfo(nameBn: 'পিরোজপুর', nameEn: 'Pirojpur', latitude: 22.5841, longitude: 89.9720, divisionBn: 'বরিশাল'),

    // Sylhet Division
    LocationInfo(nameBn: 'সিলেট', nameEn: 'Sylhet', latitude: 24.8949, longitude: 91.8687, divisionBn: 'সিলেট'),
    LocationInfo(nameBn: 'হবিগঞ্জ', nameEn: 'Habiganj', latitude: 24.3749, longitude: 91.4155, divisionBn: 'সিলেট'),
    LocationInfo(nameBn: 'মৌলভীবাজার', nameEn: 'Moulvibazar', latitude: 24.4829, longitude: 91.7774, divisionBn: 'সিলেট'),
    LocationInfo(nameBn: 'সুনামগঞ্জ', nameEn: 'Sunamganj', latitude: 25.0658, longitude: 91.3950, divisionBn: 'সিলেট'),

    // Rangpur Division
    LocationInfo(nameBn: 'রংপুর', nameEn: 'Rangpur', latitude: 25.7439, longitude: 89.2752, divisionBn: 'রংপুর'),
    LocationInfo(nameBn: 'দিনাজপুর', nameEn: 'Dinajpur', latitude: 25.6217, longitude: 88.6354, divisionBn: 'রংপুর'),
    LocationInfo(nameBn: 'গাইবান্ধা', nameEn: 'Gaibandha', latitude: 25.3288, longitude: 89.5403, divisionBn: 'রংপুর'),
    LocationInfo(nameBn: 'কুড়িগ্রাম', nameEn: 'Kurigram', latitude: 25.8054, longitude: 89.6361, divisionBn: 'রংপুর'),
    LocationInfo(nameBn: 'লালমনিরহাট', nameEn: 'Lalmonirhat', latitude: 25.9165, longitude: 89.4532, divisionBn: 'রংপুর'),
    LocationInfo(nameBn: 'নীলফামারী', nameEn: 'Nilphamari', latitude: 25.9318, longitude: 88.8560, divisionBn: 'রংপুর'),
    LocationInfo(nameBn: 'পঞ্চগড়', nameEn: 'Panchagarh', latitude: 26.3411, longitude: 88.5541, divisionBn: 'রংপুর'),
    LocationInfo(nameBn: 'ঠাকুরগাঁও', nameEn: 'Thakurgaon', latitude: 26.0337, longitude: 88.4617, divisionBn: 'রংপুর'),

    // Mymensingh Division
    LocationInfo(nameBn: 'ময়মনসিংহ', nameEn: 'Mymensingh', latitude: 24.7471, longitude: 90.4203, divisionBn: 'ময়মনসিংহ'),
    LocationInfo(nameBn: 'জামালপুর', nameEn: 'Jamalpur', latitude: 24.9375, longitude: 89.9377, divisionBn: 'ময়মনসিংহ'),
    LocationInfo(nameBn: 'নেত্রকোণা', nameEn: 'Netrokona', latitude: 24.8709, longitude: 90.7279, divisionBn: 'ময়মনসিংহ'),
    LocationInfo(nameBn: 'শেরপুর', nameEn: 'Sherpur', latitude: 25.0205, longitude: 90.0153, divisionBn: 'ময়মনসিংহ'),
  ];

  /// Popular Foreign Locations / Expat Cities
  static const List<LocationInfo> foreignLocations = [
    LocationInfo(nameBn: 'মক্কা (সৌদি আরব)', nameEn: 'Makkah, Saudi Arabia', latitude: 21.4225, longitude: 39.8262, isForeign: true),
    LocationInfo(nameBn: 'মদিনা (সৌদি আরব)', nameEn: 'Madinah, Saudi Arabia', latitude: 24.5247, longitude: 39.5692, isForeign: true),
    LocationInfo(nameBn: 'রিয়াদ (সৌদি আরব)', nameEn: 'Riyadh, Saudi Arabia', latitude: 24.7136, longitude: 46.6753, isForeign: true),
    LocationInfo(nameBn: 'জেদ্দা (সৌদি আরব)', nameEn: 'Jeddah, Saudi Arabia', latitude: 21.5433, longitude: 39.1728, isForeign: true),
    LocationInfo(nameBn: 'দুবাই (ইউএই)', nameEn: 'Dubai, UAE', latitude: 25.2048, longitude: 55.2708, isForeign: true),
    LocationInfo(nameBn: 'আবুধাবি (ইউএই)', nameEn: 'Abu Dhabi, UAE', latitude: 24.4539, longitude: 54.3773, isForeign: true),
    LocationInfo(nameBn: 'শারজাহ (ইউএই)', nameEn: 'Sharjah, UAE', latitude: 25.3463, longitude: 55.4209, isForeign: true),
    LocationInfo(nameBn: 'দোহা (কাতার)', nameEn: 'Doha, Qatar', latitude: 25.2854, longitude: 51.5310, isForeign: true),
    LocationInfo(nameBn: 'কুয়েত সিটি (কুয়েত)', nameEn: 'Kuwait City, Kuwait', latitude: 29.3759, longitude: 47.9774, isForeign: true),
    LocationInfo(nameBn: 'মাস্কাট (ওমান)', nameEn: 'Muscat, Oman', latitude: 23.5880, longitude: 58.3829, isForeign: true),
    LocationInfo(nameBn: 'মানামা (বাহরাইন)', nameEn: 'Manama, Bahrain', latitude: 26.2285, longitude: 50.5860, isForeign: true),
    LocationInfo(nameBn: 'কুয়ালালামপুর (মালয়েশিয়া)', nameEn: 'Kuala Lumpur, Malaysia', latitude: 3.1390, longitude: 101.6869, isForeign: true),
    LocationInfo(nameBn: 'সিঙ্গাপুর', nameEn: 'Singapore', latitude: 1.3521, longitude: 103.8198, isForeign: true),
    LocationInfo(nameBn: 'লন্ডন (যুক্তরাজ্য)', nameEn: 'London, UK', latitude: 51.5074, longitude: -0.1278, isForeign: true),
    LocationInfo(nameBn: 'নিউ ইয়র্ক (যুক্তরাষ্ট্র)', nameEn: 'New York, USA', latitude: 40.7128, longitude: -74.0060, isForeign: true),
    LocationInfo(nameBn: 'টরন্টো (কানাডা)', nameEn: 'Toronto, Canada', latitude: 43.6532, longitude: -79.3832, isForeign: true),
    LocationInfo(nameBn: 'সিউল (দক্ষিণ কোরিয়া)', nameEn: 'Seoul, South Korea', latitude: 37.5665, longitude: 126.9780, isForeign: true),
    LocationInfo(nameBn: 'টোকিও (জাপান)', nameEn: 'Tokyo, Japan', latitude: 35.6762, longitude: 139.6503, isForeign: true),
    LocationInfo(nameBn: 'রোম (ইতালি)', nameEn: 'Rome, Italy', latitude: 41.9028, longitude: 12.4964, isForeign: true),
    LocationInfo(nameBn: 'কলকাতা (ভারত)', nameEn: 'Kolkata, India', latitude: 22.5726, longitude: 88.3639, isForeign: true),
  ];

  /// Default Dhaka coordinates fallback
  static const double defaultLat = 23.8103;
  static const double defaultLng = 90.4125;

  /// Look up static coordinates for a district or foreign city name
  static Map<String, double> getCoordinates(String? name) {
    if (name == null || name.trim().isEmpty) {
      return {'latitude': defaultLat, 'longitude': defaultLng};
    }

    final query = name.trim().toLowerCase();

    // Check BD Districts
    for (final loc in bdDistricts) {
      if (loc.nameBn.toLowerCase() == query ||
          loc.nameEn.toLowerCase() == query ||
          query.contains(loc.nameBn.toLowerCase()) ||
          loc.nameEn.toLowerCase().contains(query)) {
        return {'latitude': loc.latitude, 'longitude': loc.longitude};
      }
    }

    // Check Foreign Locations
    for (final loc in foreignLocations) {
      if (loc.nameBn.toLowerCase() == query ||
          loc.nameEn.toLowerCase() == query ||
          query.contains(loc.nameBn.toLowerCase()) ||
          loc.nameEn.toLowerCase().contains(query)) {
        return {'latitude': loc.latitude, 'longitude': loc.longitude};
      }
    }

    // Secondary soft match for BD districts (e.g. spelling variations)
    final Map<String, LocationInfo> aliasMap = {
      'chittagong': bdDistricts[13],
      'chattogram': bdDistricts[13],
      'barisal': bdDistricts[42],
      'barishal': bdDistricts[42],
      'comilla': bdDistricts[17],
      'cumilla': bdDistricts[17],
      'bogra': bdDistricts[25],
      'bogura': bdDistricts[25],
      'jessore': bdDistricts[35],
      'jashore': bdDistricts[35],
      "cox's bazar": bdDistricts[18],
      'coxs bazar': bdDistricts[18],
      'cox bazar': bdDistricts[18],
    };

    for (final entry in aliasMap.entries) {
      if (query.contains(entry.key)) {
        return {'latitude': entry.value.latitude, 'longitude': entry.value.longitude};
      }
    }

    // Fallback to default (Dhaka) if unknown location
    return {'latitude': defaultLat, 'longitude': defaultLng};
  }
}
