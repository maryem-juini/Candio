/// App configuration class for centralized settings
class AppConfig {
  // Private constructor to prevent instantiation
  AppConfig._();

  // App information - easily customizable
  static const String appName = 'Flutter kanz';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'A customizable Flutter kanz with GetX';

  // App URLs - customize as needed
  static const String privacyPolicyUrl = 'https://example.com/privacy';
  static const String termsOfServiceUrl = 'https://example.com/terms';
  static const String supportUrl = 'https://example.com/support';

  // API configuration - customize for your backend
  static const String baseUrl = 'https://api.example.com';
  static const String apiVersion = 'v1';
  static const int apiTimeoutSeconds = 30;

  // App settings - easily customizable
  static const bool enableAnalytics = true;
  static const bool enableCrashReporting = true;
  static const bool enablePushNotifications = true;

  // Theme settings - customize colors here
  static const bool enableDarkMode = true;
  static const bool enableSystemTheme = true;
  static const String defaultTheme = 'system'; // 'light', 'dark', 'system'

  // Navigation settings
  static const String defaultTransition = 'default';

  // Debug settings
  static const bool showDebugBanner = false;
  static const bool enableLogging = true;

  // Storage keys - customize as needed
  static const String themeKey = 'theme_mode';
  static const String userKey = 'user_data';
  static const String settingsKey = 'app_settings';

  // Animation durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);

  // UI constants
  static const double defaultPadding = 16.0;
  static const double defaultRadius = 8.0;
  static const double defaultElevation = 2.0;

  // Network settings
  static const int maxRetries = 3;
  static const Duration retryDelay = Duration(seconds: 2);

  // Cache settings
  static const Duration cacheExpiration = Duration(hours: 24);
  static const int maxCacheSize = 50; // MB

  /// Get full API URL
  static String get apiUrl => '$baseUrl/$apiVersion';

  /// Get app version string
  static String get versionString => '$appName v$appVersion';

  /// Check if app is in debug mode
  static bool get isDebugMode {
    bool inDebugMode = false;
    assert(inDebugMode = true); // This will only be true in debug mode
    return inDebugMode;
  }

  /// Get appropriate timeout duration
  static Duration get timeoutDuration => Duration(seconds: apiTimeoutSeconds);
}
