import 'package:flutter/material.dart';
import 'package:animations/animations.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with TickerProviderStateMixin {
  late AnimationController _listController;
  late List<Animation<Offset>> _listAnimations;

  @override
  void initState() {
    super.initState();
    _listController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _listAnimations = List.generate(
      _settingsItems.length,
          (index) => Tween<Offset>(
        begin: const Offset(1.0, 0.0),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _listController,
        curve: Interval(
          index * 0.1,
          1.0,
          curve: Curves.easeOutBack,
        ),
      )),
    );

    _listController.forward();
  }

  @override
  void dispose() {
    _listController.dispose();
    super.dispose();
  }

  static final List<Map<String, dynamic>> _settingsItems = [
    {
      'title': 'Profile',
      'subtitle': 'Manage your personal information',
      'icon': Icons.person,
      'onTap': 'profile',
    },
    {
      'title': 'Goals',
      'subtitle': 'Set your fitness and nutrition goals',
      'icon': Icons.flag,
      'onTap': 'goals',
    },
    {
      'title': 'Notifications',
      'subtitle': 'Configure app notifications',
      'icon': Icons.notifications,
      'onTap': 'notifications',
    },
    {
      'title': 'Connect Wearable',
      'subtitle': 'Sync with fitness trackers',
      'icon': Icons.watch,
      'onTap': 'wearable',
    },
    {
      'title': 'Units',
      'subtitle': 'Metric or Imperial measurements',
      'icon': Icons.straighten,
      'onTap': 'units',
    },
    {
      'title': 'Data Export',
      'subtitle': 'Export your fitness data',
      'icon': Icons.download,
      'onTap': 'export',
    },
    {
      'title': 'Privacy',
      'subtitle': 'Privacy settings and data usage',
      'icon': Icons.privacy_tip,
      'onTap': 'privacy',
    },
    {
      'title': 'About',
      'subtitle': 'App version and information',
      'icon': Icons.info,
      'onTap': 'about',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: _settingsItems.length,
        itemBuilder: (context, index) {
          final item = _settingsItems[index];
          return SlideTransition(
            position: _listAnimations[index],
            child: OpenContainer(
              closedElevation: 0,
              transitionType: ContainerTransitionType.fadeThrough,
              openBuilder: (context, action) => _buildSettingDetail(item),
              closedBuilder: (context, action) => Card(
                margin: const EdgeInsets.symmetric(vertical: 4),
                child: ListTile(
                  leading: Icon(item['icon']),
                  title: Text(item['title']),
                  subtitle: Text(item['subtitle']),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: action,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSettingDetail(Map<String, dynamic> item) {
    return Scaffold(
      appBar: AppBar(
        title: Text(item['title']),
      ),
      body: _buildSettingContent(item['onTap']),
    );
  }

  Widget _buildSettingContent(String type) {
    switch (type) {
      case 'profile':
        return _buildProfileSettings();
      case 'goals':
        return _buildGoalsSettings();
      case 'notifications':
        return _buildNotificationSettings();
      case 'wearable':
        return _buildWearableSettings();
      case 'units':
        return _buildUnitsSettings();
      case 'export':
        return _buildExportSettings();
      case 'privacy':
        return _buildPrivacySettings();
      case 'about':
        return _buildAboutSettings();
      default:
        return const Center(child: Text('Coming soon'));
    }
  }

  Widget _buildProfileSettings() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 50,
            child: Icon(Icons.person, size: 50),
          ),
          const SizedBox(height: 24),
          const TextField(
            decoration: InputDecoration(
              labelText: 'Name',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          const TextField(
            decoration: InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          const TextField(
            decoration: InputDecoration(
              labelText: 'Age',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {},
            child: const Text('Save Changes'),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalsSettings() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Daily Goals',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          _buildGoalSlider('Steps Goal', 10000, 5000, 20000),
          _buildGoalSlider('Calories Goal', 2000, 1200, 3000),
          _buildGoalSlider('Protein Goal (g)', 150, 50, 300),
          _buildGoalSlider('Workout Minutes', 60, 15, 180),
        ],
      ),
    );
  }

  Widget _buildGoalSlider(String label, double value, double min, double max) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: ((max - min) / 50).round(),
          label: value.round().toString(),
          onChanged: (val) {},
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildNotificationSettings() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          SwitchListTile(
            title: const Text('Workout Reminders'),
            subtitle: const Text('Get reminded to work out'),
            value: true,
            onChanged: (value) {},
          ),
          SwitchListTile(
            title: const Text('Meal Logging'),
            subtitle: const Text('Reminders to log your meals'),
            value: true,
            onChanged: (value) {},
          ),
          SwitchListTile(
            title: const Text('Step Goal'),
            subtitle: const Text('Notifications for step goals'),
            value: false,
            onChanged: (value) {},
          ),
          SwitchListTile(
            title: const Text('Achievement Badges'),
            subtitle: const Text('Celebrate your progress'),
            value: true,
            onChanged: (value) {},
          ),
        ],
      ),
    );
  }

  Widget _buildWearableSettings() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Icon(Icons.watch, size: 80),
          const SizedBox(height: 24),
          const Text(
            'Connect your fitness tracker or smartwatch to automatically sync your data.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.bluetooth),
            label: const Text('Scan for Devices'),
          ),
          const SizedBox(height: 16),
          const Text('Supported devices:'),
          const SizedBox(height: 8),
          const Text('• Apple Watch\n• Fitbit\n• Garmin\n• Samsung Galaxy Watch'),
        ],
      ),
    );
  }

  Widget _buildUnitsSettings() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          RadioListTile<String>(
            title: const Text('Metric (kg, cm, km)'),
            value: 'metric',
            groupValue: 'metric',
            onChanged: (value) {},
          ),
          RadioListTile<String>(
            title: const Text('Imperial (lbs, ft, miles)'),
            value: 'imperial',
            groupValue: 'metric',
            onChanged: (value) {},
          ),
        ],
      ),
    );
  }

  Widget _buildExportSettings() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Icon(Icons.download, size: 80),
          const SizedBox(height: 24),
          const Text(
            'Export your fitness data in various formats for backup or analysis.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.file_download),
            label: const Text('Export as CSV'),
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.file_download),
            label: const Text('Export as JSON'),
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacySettings() {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Privacy Policy',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Text(
            'TrackFactor takes your privacy seriously. Your health and fitness data is stored locally on your device and only shared with third-party services when explicitly authorized by you.',
          ),
          SizedBox(height: 16),
          Text(
            'Data Collection',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            '• Workout data is stored locally\n'
                '• Nutrition data from API calls\n'
                '• Step data from device sensors\n'
                '• No personal data is shared without consent',
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSettings() {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Icon(Icons.fitness_center, size: 80),
          SizedBox(height: 24),
          Text(
            'TrackFactor',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text('Version 1.0.0'),
          SizedBox(height: 24),
          Text(
            'A comprehensive fitness tracking app that combines workout logging, nutrition tracking, and step counting with beautiful animations.',
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24),
          Text('Made with ❤️ using Flutter'),
        ],
      ),
    );
  }
}
