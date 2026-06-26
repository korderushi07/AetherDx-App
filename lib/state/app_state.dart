import 'package:flutter/material.dart';

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
      notifyListeners();
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
    if (_avatarType == AvatarType.asset) {
      return CircleAvatar(
        radius: radius,
        backgroundImage: const AssetImage('assets/images/profile_avatar.png'),
        backgroundColor: Colors.transparent,
      );
    }

    List<Color> colors;
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

    // Get Initials (max 2 characters)
    String initials = '';
    if (_name.trim().isNotEmpty) {
      final parts = _name.trim().split(RegExp(r'\s+'));
      if (parts.isNotEmpty) {
        initials += parts[0][0].toUpperCase();
        if (parts.length > 1) {
          initials += parts[parts.length - 1][0].toUpperCase();
        }
      }
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
          fontSize: radius * 0.8,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.5,
        ),
      ),
    );
  }
}
