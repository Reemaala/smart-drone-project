class LocalDatabase {
  static final List<String> _emails = [];

  static Future<void> insertEmail(String email) async {
    if (!_emails.contains(email)) {
      _emails.add(email);
    }
  }

  static Future<List<String>> getAllEmails() async {
    return _emails;
  }

  static Future<void> deleteEmail(String email) async {
    _emails.remove(email);
  }
}
