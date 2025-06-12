# Screen Time Oracle 🔮📱

A Flutter app that gives you quirky predictions and advice based on your phone usage patterns!

## Features ✨

### 🎯 Core Functionality
- **Real Device Screen Time**: Access actual usage data (Android only)
- **Mock Data Mode**: Simulated screen time for testing and iOS
- **Oracle Messages**: 4 categories with hilarious wisdom:
  - **< 1 hour**: "Enlightened" (Green) 🧘‍♀️
  - **1-3 hours**: "Mortal" (Blue) 📱  
  - **3-5 hours**: "Overtime" (Orange) ⚠️
  - **5+ hours**: "Salvation" (Red) 🆘

### 🎮 Interactive Elements
- **New Prophecy**: Get a different message in the same category
- **Refresh Data**: Reload real screen time data
- **Add Time**: Simulate additional usage (mock mode)
- **Reset Day**: Start fresh with 0 minutes
- **Enable Real Data**: Request device permissions (Android)

### 🎨 Beautiful UI
- Smooth fade animations for oracle messages
- Color-coded categories with matching icons
- Data source indicators (Real vs Mock)
- Scrollable responsive design

## Getting Real Screen Time Data 📊

### Android Setup
1. **Automatic Permission Request**: The app will automatically request "Usage Access" permission
2. **Manual Setup** (if needed):
   - Go to Settings → Privacy → Special App Access → Usage Access
   - Find "Screen Time Oracle" and enable it
3. **Refresh Data**: Tap the "Refresh Data" button to load real usage

### iOS Limitations
- iOS requires special Apple developer permissions for Screen Time access
- The app automatically uses mock data on iOS
- Mock data is saved locally and persists between sessions

## Technical Details 🛠️

### Dependencies
- `usage_stats`: Android usage statistics access
- `permission_handler`: Permission management
- `device_info_plus`: Device information
- `shared_preferences`: Local data storage

### Permissions Required (Android)
- `android.permission.PACKAGE_USAGE_STATS`: Access to app usage data

### Architecture
- **ScreenTimeService**: Handles real device data and fallbacks
- **OraclePage**: Main UI with animations and state management
- **Test Mode**: Disabled real data access during testing

## Oracle Message Categories 🔮

### Enlightened (< 1 hour) 🧘‍♀️
- "You're digitally enlightened!"
- "Welcome to the real world, chosen one."
- "Your chakras are aligned with reality."
- "The screen gods smile upon your restraint."
- "You've achieved digital nirvana."

### Mortal (1-3 hours) 📱
- "You're doing okay, mortal."
- "Moderation is your middle name."
- "The balance is strong with this one."
- "You've earned some quality memes."
- "A reasonable human in the digital age."

### Overtime (3-5 hours) ⚠️
- "Your thumbs are working overtime!"
- "Time to take a walk... maybe?"
- "Do you remember what sunlight feels like?"
- "The scroll is strong with you."
- "Your phone misses you when you blink."

### Salvation (5+ hours) 🆘
- "Seek digital salvation immediately!"
- "Touch grass. This is not a suggestion."
- "You're one with the screen now."
- "The phone has become an extension of your hand."
- "Legend says you can still see the screen burn-in."

## Development 👨‍💻

### Running the App
```bash
flutter pub get
flutter run
```

### Running Tests
```bash
flutter test
```

### Building for Release
```bash
# Android
flutter build apk --release

# iOS (requires Apple Developer Account for real screen time)
flutter build ios --release
```

## Learning Outcomes 📚

This project demonstrates:
- **Platform-specific APIs**: Different approaches for Android vs iOS
- **Permission Handling**: Requesting and managing sensitive permissions
- **Fallback Strategies**: Graceful degradation when permissions aren't available
- **State Management**: Loading states, error handling, and data persistence
- **UI Animations**: Smooth transitions and user feedback
- **Testing**: Widget tests with mock data and edge cases

## Troubleshooting 🔧

### Build Issues (Android)
1. **NDK Version Error**: 
   - The app specifies NDK version `27.0.12077973`
   - Install via Android Studio SDK Manager if needed
2. **Minimum SDK Version**: 
   - Requires Android API 22+ for usage stats
   - Excludes devices running Android 5.0 and below

### "No Real Data" on Android
1. Check if Usage Access permission is granted
2. Try the "Enable Real Data" button
3. Manually enable in Settings → Privacy → Usage Access

### Tests Failing
- Tests use mock data to avoid permission issues
- Use `testMode: true` parameter for reliable testing

### Large Screen Time Values
- Android sometimes returns inflated values
- App automatically caps at 24 hours and falls back to mock data

---

**Made with ❤️ and a healthy dose of digital skepticism!** 🔮✨
