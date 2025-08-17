# Flutter kanz Customization Guide

This Flutter kanz is designed to be highly customizable and easy to modify. Here's how to customize different aspects of the app:

## 🎨 Theme Customization

### Colors
Edit `lib/core/theme/app_theme.dart` to customize colors:

```dart
// Primary colors - change these to match your brand
static const Color _primaryColor = Color(0xFF6750A4);
static const Color _secondaryColor = Color(0xFF625B71);
static const Color _tertiaryColor = Color(0xFF7D5260);
static const Color _errorColor = Color(0xFFBA1A1A);
```

### Text Styles
Customize text styles in the same file:

```dart
static const TextStyle headlineLarge = TextStyle(
  fontSize: 32,
  fontWeight: FontWeight.bold,
  letterSpacing: -0.5,
);
```

## ⚙️ App Configuration

Edit `lib/core/config/app_config.dart` to customize app settings:

### App Information
```dart
static const String appName = 'Your App Name';
static const String appVersion = '1.0.0';
static const String appDescription = 'Your app description';
```

### API Configuration
```dart
static const String baseUrl = 'https://your-api.com';
static const String apiVersion = 'v1';
static const int apiTimeoutSeconds = 30;
```

## 🚀 Adding New Pages

1. Create a new page in `lib/presentation/views/`
2. Add the route in `lib/presentation/routes/app_routes.dart`
3. Register the page in `lib/presentation/routes/app_pages.dart`

## 🎯 Adding New Controllers

1. Create a controller in `lib/presentation/controllers/`
2. Register it in your page bindings

## 📱 Customizing the Home Page

Edit `lib/presentation/views/home/home_page.dart` to customize the home page content.

## 🔄 Theme Switching

The app includes a built-in theme controller that supports:
- Light/Dark theme switching
- System theme detection
- Theme persistence
- Reactive theme updates

## 🚀 Quick Start

1. **Change App Name**: Edit `AppConfig.appName` in `lib/core/config/app_config.dart`
2. **Change Colors**: Edit color constants in `lib/core/theme/app_theme.dart`
3. **Add Pages**: Follow the "Adding New Pages" section above
4. **Customize Home**: Edit `lib/presentation/views/home/home_page.dart`

This kanz provides a solid foundation for building scalable Flutter applications with clean architecture and easy customization. 