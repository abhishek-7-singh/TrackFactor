# TrackFactor 🏋️‍♂️

A comprehensive Flutter fitness tracking application that combines workout logging, nutrition tracking, and step counting with beautiful, professional animations and a clean UI design.

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Hive](https://img.shields.io/badge/Hive-FF6B35?style=for-the-badge&logo=flutter&logoColor=white)

## ✨ Features

### 💪 Workout Tracking
- **Exercise Library**: Browse through a comprehensive collection of exercises with detailed instructions
- **Workout Sessions**: Create and track workout sessions with sets, reps, and weights
- **Progressive Overload**: Track your strength progress over time
- **Exercise Details**: View targeted muscle groups, required equipment, and step-by-step instructions
- **History**: Review past workout sessions and analyze performance trends

### 🍎 Nutrition Tracking
- **Food Search**: Search for foods using the API Ninjas nutrition database
- **Macro Tracking**: Monitor calories, protein, carbohydrates, and fat intake
- **Daily Goals**: Set and track daily nutrition targets
- **Food Diary**: Log meals and snacks throughout the day
- **Progress Visualization**: Charts showing nutrition trends over time

### 👟 Step Counting
- **Real-time Tracking**: Count steps using device sensors or connected wearables
- **Daily Goals**: Set and monitor daily step targets
- **Distance Calculation**: Automatic distance and calorie burn estimation
- **History Graphs**: Visualize step count trends and achievements
- **Health Integration**: Sync with device health apps

### 📊 Progress Analytics
- **Comprehensive Charts**: Beautiful FL Chart visualizations for all metrics
- **Weight Progress**: Track body weight changes over time
- **Performance Metrics**: Monitor workout volume, frequency, and intensity
- **Achievement System**: Celebrate milestones and streaks
- **Export Data**: Export your fitness data in CSV or JSON formats

### ⚙️ Settings & Customization
- **Profile Management**: Personal information and fitness goals
- **Unit Preferences**: Switch between metric and imperial measurements
- **Notifications**: Configurable reminders for workouts and meals
- **Wearable Integration**: Connect fitness trackers and smartwatches
- **Privacy Controls**: Manage data sharing and storage preferences

## 🏗️ Architecture

TrackFactor follows Clean Architecture principles with BLoC (Business Logic Component) pattern for state management:

```
lib/
├── blocs/              # Business Logic Components
│   ├── workout/        # Workout-related state management
│   ├── nutrition/      # Nutrition tracking logic
│   └── steps/          # Step counting functionality
├── models/             # Data models and entities
├── repositories/       # Data access layer
├── services/           # External API integrations
├── screens/            # UI screens and pages
├── widgets/            # Reusable UI components
├── theme/              # App theming and styling
└── utils/              # Helper functions and constants
```

### Key Design Patterns
- **BLoC Pattern**: Separates business logic from UI components
- **Repository Pattern**: Abstracts data sources and provides clean API
- **Service Layer**: Handles external API calls and device integrations
- **Clean Architecture**: Ensures maintainability and testability

## 🚀 Getting Started

### Prerequisites
- Flutter SDK: >= 3.0.0
- Dart SDK: >= 3.0.0
- Android Studio or VS Code with Flutter extensions
- API Keys: Sign up for API Ninjas for nutrition data

### Installation

1. **Clone the repository**
```bash
git clone https://github.com/abhishek-7-singh/TrackFactor.git
cd TrackFactor
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Set up environment variables**
Create a `.env` file in the project root:
```
API_NINJAS_KEY=your_api_ninjas_key_here
NUTRITION_API_URL=https://api.api-ninjas.com/v1/nutrition
APP_NAME=TrackFactor
DEBUG_MODE=true
```

4. **Generate Hive adapters**
```bash
dart run build_runner build --delete-conflicting-outputs
```

5. **Configure permissions**

**Android** (`android/app/src/main/AndroidManifest.xml`):
```xml
<uses-permission android:name="android.permission.ACTIVITY_RECOGNITION" />
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
```

**iOS** (`ios/Runner/Info.plist`):
```xml
<key>NSMotionUsageDescription</key>
<string>This app needs access to motion data to count your steps</string>
<key>NSHealthUpdateUsageDescription</key>
<string>This app needs access to health data to track your fitness progress</string>
```

6. **Run the app**
```bash
flutter run
```

## 📦 Dependencies

### Core Dependencies
- `flutter_bloc: ^8.1.3` - State management
- `hive_flutter: ^1.1.0` - Local database
- `dio: ^5.3.3` - HTTP client for API calls
- `cached_network_image: ^3.3.1` - Image caching
- `fl_chart: ^0.66.0` - Beautiful charts
- `animations: ^2.0.8` - Page transitions
- `pedometer: ^4.1.1` - Step counting
- `health: ^10.2.0` - Health data integration

### Development Dependencies
- `build_runner: ^2.4.7` - Code generation
- `hive_generator: ^2.0.1` - Hive type adapters
- `flutter_lints: ^3.0.1` - Linting rules

## 🎨 UI/UX Design

### Design Philosophy
- **Professional & Mature**: Clean, modern interface suitable for serious fitness enthusiasts
- **Accessibility First**: Proper contrast ratios, text scaling, and screen reader support
- **Responsive Design**: Adapts to different screen sizes and orientations
- **Subtle Animations**: Smooth transitions that enhance user experience without distraction

### Color Scheme
- **Primary**: Dark charcoal (#1A1A1A) for professional appearance
- **Accent**: iOS blue (#007AFF) for interactive elements
- **Success**: Green (#28A745) for achievements and positive actions
- **Warning**: Orange (#FF9500) for important notifications
- **Error**: Red (#DC3545) for error states

### Typography
- **Headings**: Bold, slightly condensed for impact
- **Body Text**: Optimized for readability with proper line spacing
- **Labels**: All-caps with increased letter spacing for secondary information

## 🔧 Configuration

### API Configuration
Update `.env` file with your API credentials:
```
# Required for nutrition tracking
API_NINJAS_KEY=your_key_here

# Optional: Custom API endpoints
NUTRITION_API_URL=https://api.api-ninjas.com/v1/nutrition
```

### Database Configuration
TrackFactor uses Hive for local data storage. No additional configuration required - the app automatically initializes the database on first run.

### Health Integration
The app integrates with:
- **iOS Health**: Automatic sync with Apple Health app
- **Google Fit**: Android health data integration
- **Fitness Trackers**: Support for major wearable devices

## 📱 Screenshots

| Home Screen | Workout Tracking | Nutrition Logging | Progress Charts |
|-------------|------------------|-------------------|-----------------|
| Coming Soon | Coming Soon      | Coming Soon       | Coming Soon     |

## 🧪 Testing

Run the test suite:
```bash
# Unit tests
flutter test

# Integration tests
flutter test integration_test/

# Widget tests
flutter test test/widget_test.dart
```

## 🚢 Building for Production

### Android APK
```bash
flutter build apk --release
```

### iOS Archive
```bash
flutter build ios --release
```

### Android App Bundle (for Play Store)
```bash
flutter build appbundle --release
```

## 🤝 Contributing

We welcome contributions! Please follow these steps:

1. Fork the repository
2. Create a feature branch
```bash
git checkout -b feature/amazing-feature
```
3. Commit your changes
```bash
git commit -m 'Add some amazing feature'
```
4. Push to the branch
```bash
git push origin feature/amazing-feature
```
5. Open a Pull Request

### Development Guidelines
- Follow Flutter's style guide
- Write comprehensive tests for new features
- Update documentation for any API changes
- Ensure all tests pass before submitting PR


## 🙏 Acknowledgments

- Flutter Team for the amazing framework
- BLoC Library for excellent state management
- API Ninjas for nutrition data
- FL Chart for beautiful data visualizations
- Hive for fast local storage

## 📞 Support

- **Documentation**: [Wiki](https://github.com/abhishek-7-singh/TrackFactor/wiki)
- **Issues**: [GitHub Issues](https://github.com/abhishek-7-singh/TrackFactor/issues)
- **Discussions**: [GitHub Discussions](https://github.com/abhishek-7-singh/TrackFactor/discussions)
- **Email**: support@trackfactor.app

## 🗺️ Roadmap

### Version 2.0
- [ ] Social features and workout sharing
- [ ] Personal trainer AI recommendations
- [ ] Advanced analytics with ML insights
- [ ] Apple Watch and Wear OS apps
- [ ] Cloud sync and backup

### Version 1.1
- [ ] Meal planning and recipes
- [ ] Custom workout builder
- [ ] Barcode scanning for food items
- [ ] Export to popular fitness apps
- [ ] Dark mode improvements

---

**Built with ❤️ using Flutter**

*TrackFactor - Your Professional Fitness Companion*
