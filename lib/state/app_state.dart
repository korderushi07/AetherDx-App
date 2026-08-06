import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

enum AvatarType {
  asset,
  ocean,
  sunset,
  amethyst,
  emerald,
}

class AppState extends ChangeNotifier {
  static final AppState _instance = AppState._internal();
  factory AppState() => _instance;
  AppState._internal();

  // App Settings / Stats
  bool _hasScans = true;
  bool get hasScans => _hasScans;
  set hasScans(bool value) {
    if (_hasScans != value) {
      _hasScans = value;
      notifyListeners();
    }
  }

  // User Profile
  String _name = 'Rushikesh';
  String get name => _name;
  set name(String value) {
    if (_name != value) {
      _name = value;
      notifyListeners();
    }
  }

  String _username = 'rushikesh';
  String get username => _username;
  set username(String value) {
    if (_username != value) {
      _username = value;
      notifyListeners();
    }
  }

  String _email = 'rushikesh@example.com';
  String get email => _email;
  set email(String value) {
    if (_email != value) {
      _email = value;
      notifyListeners();
    }
  }

  AvatarType _avatarType = AvatarType.asset;
  AvatarType get avatarType => _avatarType;
  set avatarType(AvatarType value) {
    if (_avatarType != value) {
      _avatarType = value;
      notifyListeners();
    }
  }

  // Settings
  String _language = 'English';
  String get language => _language;
  set language(String value) {
    if (_language != value) {
      _language = value;
      _saveLanguagePreference(value);
      notifyListeners();
    }
  }

  Future<void> _saveLanguagePreference(String lang) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('app_language', lang);
    } catch (e) {
      debugPrint("Error saving language preference: $e");
    }
  }

  bool _pushNotifications = true;
  bool get pushNotifications => _pushNotifications;
  set pushNotifications(bool value) {
    if (_pushNotifications != value) {
      _pushNotifications = value;
      notifyListeners();
    }
  }

  bool _emailNotifications = false;
  bool get emailNotifications => _emailNotifications;
  set emailNotifications(bool value) {
    if (_emailNotifications != value) {
      _emailNotifications = value;
      notifyListeners();
    }
  }

  bool _weeklyReports = true;
  bool get weeklyReports => _weeklyReports;
  set weeklyReports(bool value) {
    if (_weeklyReports != value) {
      _weeklyReports = value;
      notifyListeners();
    }
  }

  // Offline Data & Sync
  bool _autoSync = true;
  bool get autoSync => _autoSync;
  set autoSync(bool value) {
    if (_autoSync != value) {
      _autoSync = value;
      notifyListeners();
    }
  }

  String _lastSync = '2 hours ago';
  String get lastSync => _lastSync;
  set lastSync(String value) {
    if (_lastSync != value) {
      _lastSync = value;
      notifyListeners();
    }
  }

  // Health and Registration details
  String _phoneNumber = '+91 98765 43210';
  String get phoneNumber => _phoneNumber;
  set phoneNumber(String value) {
    if (_phoneNumber != value) {
      _phoneNumber = value;
      notifyListeners();
    }
  }

  String _dob = '1995-08-15';
  String get dob => _dob;
  set dob(String value) {
    if (_dob != value) {
      _dob = value;
      notifyListeners();
    }
  }

  String _gender = 'Male';
  String get gender => _gender;
  set gender(String value) {
    if (_gender != value) {
      _gender = value;
      notifyListeners();
    }
  }

  String _bloodGroup = 'O+';
  String get bloodGroup => _bloodGroup;
  set bloodGroup(String value) {
    if (_bloodGroup != value) {
      _bloodGroup = value;
      notifyListeners();
    }
  }

  String _height = '175';
  String get height => _height;
  set height(String value) {
    if (_height != value) {
      _height = value;
      notifyListeners();
    }
  }

  String _weight = '70';
  String get weight => _weight;
  set weight(String value) {
    if (_weight != value) {
      _weight = value;
      notifyListeners();
    }
  }

  String _medicalConditions = '';
  String get medicalConditions => _medicalConditions;
  set medicalConditions(String value) {
    if (_medicalConditions != value) {
      _medicalConditions = value;
      notifyListeners();
    }
  }

  String _medications = '';
  String get medications => _medications;
  set medications(String value) {
    if (_medications != value) {
      _medications = value;
      notifyListeners();
    }
  }

  String _allergies = '';
  String get allergies => _allergies;
  set allergies(String value) {
    if (_allergies != value) {
      _allergies = value;
      notifyListeners();
    }
  }

  String _emergencyContactName = '';
  String get emergencyContactName => _emergencyContactName;
  set emergencyContactName(String value) {
    if (_emergencyContactName != value) {
      _emergencyContactName = value;
      notifyListeners();
    }
  }

  String _emergencyContactRelationship = '';
  String get emergencyContactRelationship => _emergencyContactRelationship;
  set emergencyContactRelationship(String value) {
    if (_emergencyContactRelationship != value) {
      _emergencyContactRelationship = value;
      notifyListeners();
    }
  }

  String _emergencyContactNumber = '';
  String get emergencyContactNumber => _emergencyContactNumber;
  set emergencyContactNumber(String value) {
    if (_emergencyContactNumber != value) {
      _emergencyContactNumber = value;
      notifyListeners();
    }
  }

  bool _isSyncing = false;
  bool get isSyncing => _isSyncing;

  Future<void> performSync() async {
    if (_isSyncing) return;
    _isSyncing = true;
    notifyListeners();

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    _isSyncing = false;
    _lastSync = 'Just now';
    notifyListeners();
  }

  // Helper to build Avatar Widget dynamically
  Widget buildAvatarWidget(double radius) {
    List<Color> colors;
    if (_avatarType == AvatarType.asset) {
      colors = const [Color(0xFF155E63), Color(0xFF114A4E)];
    } else {
      switch (_avatarType) {
        case AvatarType.ocean:
          colors = const [Color(0xFF06B6D4), Color(0xFF0EA5E9)];
          break;
        case AvatarType.sunset:
          colors = const [Color(0xFFF97316), Color(0xFFEF4444)];
          break;
        case AvatarType.amethyst:
          colors = const [Color(0xFFD946EF), Color(0xFF8B5CF6)];
          break;
        case AvatarType.emerald:
          colors = const [Color(0xFF10B981), Color(0xFF059669)];
          break;
        default:
          colors = const [Color(0xFF64748B), Color(0xFF475569)];
      }
    }

    // Get First letter of the name
    String initials = '';
    if (_name.trim().isNotEmpty) {
      initials = _name.trim()[0].toUpperCase();
    }
    if (initials.isEmpty) initials = 'U';

    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        initials,
        style: TextStyle(
          color: Colors.white,
          fontSize: radius * 0.9,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.5,
        ),
      ),
    );
  }

  void clear() {
    _name = '';
    _username = '';
    _email = '';
    _avatarType = AvatarType.asset;
    _phoneNumber = '';
    _dob = '';
    _gender = '';
    _bloodGroup = '';
    _height = '';
    _weight = '';
    _medicalConditions = '';
    _medications = '';
    _allergies = '';
    _emergencyContactName = '';
    _emergencyContactRelationship = '';
    _emergencyContactNumber = '';
    _lastSync = '';
    _isSyncing = false;
    notifyListeners();
  }

  void updateFromMap(Map<String, dynamic> data) {
    if (data['full_name'] != null && data['full_name'].toString().isNotEmpty) {
      _name = data['full_name'];
      _username = data['full_name'].toString().toLowerCase().replaceAll(' ', '');
    }
    if (data['mobile_number'] != null && data['mobile_number'].toString().isNotEmpty) {
      _phoneNumber = data['mobile_number'];
    }
    if (data['dob'] != null && data['dob'].toString().isNotEmpty) {
      _dob = data['dob'];
    }
    if (data['gender'] != null && data['gender'].toString().isNotEmpty) {
      _gender = data['gender'];
    }
    if (data['blood_group'] != null && data['blood_group'].toString().isNotEmpty) {
      _bloodGroup = data['blood_group'];
    }
    if (data['height'] != null && data['height'].toString().isNotEmpty) {
      _height = data['height'];
    }
    if (data['weight'] != null && data['weight'].toString().isNotEmpty) {
      _weight = data['weight'];
    }
    if (data['medical_conditions'] != null) {
      _medicalConditions = data['medical_conditions'];
    }
    if (data['medications'] != null) {
      _medications = data['medications'];
    }
    if (data['allergies'] != null) {
      _allergies = data['allergies'];
    }
    if (data['emergency_contact_name'] != null && data['emergency_contact_name'].toString().isNotEmpty) {
      _emergencyContactName = data['emergency_contact_name'];
    }
    if (data['emergency_contact_relationship'] != null && data['emergency_contact_relationship'].toString().isNotEmpty) {
      _emergencyContactRelationship = data['emergency_contact_relationship'];
    }
    if (data['emergency_contact_number'] != null && data['emergency_contact_number'].toString().isNotEmpty) {
      _emergencyContactNumber = data['emergency_contact_number'];
    }
    notifyListeners();
  }
}
