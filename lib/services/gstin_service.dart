class GSTINService {
  static const Map<String, String> stateMap = {
    '01': 'Jammu & Kashmir',
    '02': 'Himachal Pradesh',
    '03': 'Punjab',
    '04': 'Chandigarh',
    '05': 'Uttarakhand',
    '06': 'Haryana',
    '07': 'Delhi',
    '08': 'Rajasthan',
    '09': 'Uttar Pradesh',
    '10': 'Bihar',
    '11': 'Sikkim',
    '12': 'Arunachal Pradesh',
    '13': 'Nagaland',
    '14': 'Manipur',
    '15': 'Mizoram',
    '16': 'Tripura',
    '17': 'Meghalaya',
    '18': 'Assam',
    '19': 'West Bengal',
    '20': 'Jharkhand',
    '21': 'Odisha',
    '22': 'Chhattisgarh',
    '23': 'Madhya Pradesh',
    '24': 'Gujarat',
    '26': 'Dadra & Nagar Haveli and Daman & Diu',
    '27': 'Maharashtra',
    '28': 'Andhra Pradesh',
    '29': 'Karnataka',
    '30': 'Goa',
    '31': 'Lakshadweep',
    '32': 'Kerala',
    '33': 'Tamil Nadu',
    '34': 'Puducherry',
    '35': 'Andaman & Nicobar Islands',
    '36': 'Telangana',
    '37': 'Andhra Pradesh (New)',
  };

  static String formatGSTIN(String raw) {
    return raw.toUpperCase().replaceAll(RegExp(r'[\s\-]'), '');
  }

  static bool isValidFormat(String gstin) {
    final clean = formatGSTIN(gstin);
    if (clean.length != 15) return false;

    final stateCode = clean.substring(0, 2);
    final stateNum = int.tryParse(stateCode);
    if (stateNum == null || stateNum < 1 || stateNum > 37) return false;

    final gstRegex = RegExp(
        r'^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[1-9A-Z]{1}Z[0-9A-Z]{1}$');
    return gstRegex.hasMatch(clean);
  }

  static String? getStateName(String gstin) {
    final clean = formatGSTIN(gstin);
    if (clean.length < 2) return null;
    final code = clean.substring(0, 2);
    return stateMap[code];
  }

  static String? getPANFromGSTIN(String gstin) {
    final clean = formatGSTIN(gstin);
    if (clean.length < 12) return null;
    return clean.substring(2, 12);
  }

  static bool isSameState(String gstin1, String gstin2) {
    final clean1 = formatGSTIN(gstin1);
    final clean2 = formatGSTIN(gstin2);
    if (clean1.length < 2 || clean2.length < 2) return true;
    return clean1.substring(0, 2) == clean2.substring(0, 2);
  }

  static Map<String, String>? getStateFromGSTIN(String gstin) {
    final name = getStateName(gstin);
    if (name == null) return null;
    final code = formatGSTIN(gstin).substring(0, 2);
    return {'code': code, 'name': name};
  }
}
