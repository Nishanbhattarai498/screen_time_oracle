import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';
import 'services/screen_time_service.dart';

void main() {
  runApp(const ScreenTimeOracleApp());
}

class ScreenTimeOracleApp extends StatelessWidget {
  const ScreenTimeOracleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Screen Time Oracle',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const OraclePage(),
    );
  }
}

class OraclePage extends StatefulWidget {
  const OraclePage({super.key, this.testMode = false});

  final bool testMode; // Disable real screen time access during testing

  @override
  State<OraclePage> createState() => _OraclePageState();
}

class _OraclePageState extends State<OraclePage> with TickerProviderStateMixin {
  int _screenTimeMinutes = 0;
  String _currentMessage = "";
  String _currentCategory = "";
  bool _isUsingRealData = false;
  bool _isLoading = true;
  String _dataSource = "Mock Data";
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final Map<String, List<String>> oracleMessages = {
    "enlightened": [
      "You're digitally enlightened! 🧘‍♀️",
      "Welcome to the real world, chosen one.",
      "Your chakras are aligned with reality.",
      "The screen gods smile upon your restraint.",
      "You've achieved digital nirvana.",
    ],
    "mortal": [
      "You're doing okay, mortal. 📱",
      "Moderation is your middle name.",
      "The balance is strong with this one.",
      "You've earned some quality memes.",
      "A reasonable human in the digital age.",
    ],
    "overtime": [
      "Your thumbs are working overtime! 👍💪",
      "Time to take a walk... maybe?",
      "Do you remember what sunlight feels like?",
      "The scroll is strong with you.",
      "Your phone misses you when you blink.",
    ],
    "salvation": [
      "Seek digital salvation immediately! 🆘",
      "Touch grass. This is not a suggestion.",
      "You're one with the screen now.",
      "The phone has become an extension of your hand.",
      "Legend says you can still see the screen burn-in.",
    ],
  };

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _loadScreenTime();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadScreenTime() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Use mock data in test mode
      if (widget.testMode) {
        await _loadMockData();
      } else {
        // Try to get real screen time data first
        if (ScreenTimeService.isRealScreenTimeSupported) {
          bool hasPermission = await ScreenTimeService.requestPermissions();

          if (hasPermission) {
            int realScreenTime = await ScreenTimeService.getTodayScreenTime();
            setState(() {
              _screenTimeMinutes = realScreenTime;
              _isUsingRealData = true;
              _dataSource = "Real Device Data";
            });
          } else {
            // Fall back to saved mock data
            await _loadMockData();
          }
        } else {
          // Platform doesn't support real data, use mock
          await _loadMockData();
        }
      }
    } catch (e) {
      print('Error loading screen time: $e');
      await _loadMockData();
    }

    setState(() {
      _isLoading = false;
    });

    _generateOracleMessage();
  }

  Future<void> _loadMockData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _screenTimeMinutes = prefs.getInt('screen_time_minutes') ?? 45;
      _isUsingRealData = false;
      _dataSource = "Mock Data";
    });
  }

  Future<void> _saveScreenTime() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('screen_time_minutes', _screenTimeMinutes);
  }

  void _generateOracleMessage() {
    String category;
    if (_screenTimeMinutes < 60) {
      category = "enlightened";
    } else if (_screenTimeMinutes <= 180) {
      category = "mortal";
    } else if (_screenTimeMinutes <= 300) {
      category = "overtime";
    } else {
      category = "salvation";
    }

    final messages = oracleMessages[category]!;
    final randomMessage = messages[Random().nextInt(messages.length)];

    setState(() {
      _currentCategory = category;
      _currentMessage = randomMessage;
    });

    _animationController.reset();
    _animationController.forward();
  }

  void _simulateScreenTime() {
    setState(() {
      _screenTimeMinutes += Random().nextInt(30) + 10;
    });
    _saveScreenTime();
    _generateOracleMessage();
  }

  void _resetScreenTime() {
    setState(() {
      _screenTimeMinutes = 0;
    });
    _saveScreenTime();
    _generateOracleMessage();
  }

  String _formatTime(int minutes) {
    final hours = minutes ~/ 60;
    final mins = minutes % 60;
    if (hours > 0) {
      return '${hours}h ${mins}m';
    }
    return '${mins}m';
  }

  Color _getCategoryColor() {
    switch (_currentCategory) {
      case "enlightened":
        return Colors.green;
      case "mortal":
        return Colors.blue;
      case "overtime":
        return Colors.orange;
      case "salvation":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getCategoryIcon() {
    switch (_currentCategory) {
      case "enlightened":
        return Icons.self_improvement;
      case "mortal":
        return Icons.thumb_up;
      case "overtime":
        return Icons.warning;
      case "salvation":
        return Icons.sos;
      default:
        return Icons.phone_android;
    }
  }

  Future<void> _requestPermissions() async {
    bool hasPermission = await ScreenTimeService.requestPermissions();
    if (hasPermission) {
      _loadScreenTime();
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Please enable Usage Access in Settings to get real screen time data',
            ),
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('📱 Screen Time Oracle'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20), // Add some top spacing
              // Screen Time Display
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      'Today\'s Screen Time',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (_isLoading)
                      const CircularProgressIndicator()
                    else
                      Text(
                        _formatTime(_screenTimeMinutes),
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: _getCategoryColor(),
                        ),
                      ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _isUsingRealData ? Icons.smartphone : Icons.science,
                          size: 16,
                          color: _isUsingRealData
                              ? Colors.green
                              : Colors.orange,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _dataSource,
                          style: TextStyle(
                            fontSize: 12,
                            color: _isUsingRealData
                                ? Colors.green
                                : Colors.orange,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Oracle Message
              FadeTransition(
                opacity: _fadeAnimation,
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: _getCategoryColor().withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: _getCategoryColor(), width: 2),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        _getCategoryIcon(),
                        size: 48,
                        color: _getCategoryColor(),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '🔮 The Oracle Speaks:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: _getCategoryColor(),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _currentMessage,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 32), // Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: _generateOracleMessage,
                    icon: const Icon(Icons.refresh),
                    label: const Text('New\nProphecy'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: _loadScreenTime,
                    icon: const Icon(Icons.update),
                    label: const Text('Refresh\nData'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: _simulateScreenTime,
                    icon: const Icon(Icons.add_circle),
                    label: const Text('Add\nTime'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Secondary actions
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: _resetScreenTime,
                    icon: const Icon(Icons.restart_alt),
                    label: const Text('Reset\nDay'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                  ),
                  if (!_isUsingRealData &&
                      ScreenTimeService.isRealScreenTimeSupported)
                    ElevatedButton.icon(
                      onPressed: _requestPermissions,
                      icon: const Icon(Icons.security),
                      label: const Text('Enable\nReal Data'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
