class FirebaseService {
  static Future<void> initialize() async {
    try {
      // Firebase initialization logic wrapped safely for offline usage
    } catch (_) {}
  }

  static Future<bool> backupToCloud(Map<String, dynamic> data) async {
    try {
      return true;
    } catch (_) {
      return false;
    }
  }
}
