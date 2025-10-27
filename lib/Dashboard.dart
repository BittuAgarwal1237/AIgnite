import 'package:flutter/material.dart';
import 'dart:async';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  bool _isDarkMode = false;
  String _greeting = '';

  final List<Widget> _pages = const [
    HomePage(),
    CoursesPage(),
    CommunityPage(),
    ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    _updateGreeting();
  }

  void _updateGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      _greeting = "Good Morning ☀️";
    } else if (hour < 17) {
      _greeting = "Good Afternoon 🌤️";
    } else {
      _greeting = "Good Evening 🌙";
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.pop(context); // close drawer when navigating
  }

  @override
  Widget build(BuildContext context) {
    final theme = _isDarkMode ? ThemeData.dark() : ThemeData.light();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('AIgnite', style: TextStyle(fontWeight: FontWeight.w600)),
          centerTitle: true,
          actions: [
            IconButton(
              tooltip: "Toggle Dark Mode",
              icon: Icon(_isDarkMode ? Icons.dark_mode : Icons.light_mode),
              onPressed: () => setState(() => _isDarkMode = !_isDarkMode),
            ),
          ],
        ),
        drawer: _buildDrawer(context),
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          child: _pages[_selectedIndex],
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _selectedIndex,
          onDestinationSelected: _onItemTapped,
          destinations: const [
            NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home'),
            NavigationDestination(icon: Icon(Icons.menu_book_outlined), label: 'Courses'),
            NavigationDestination(icon: Icon(Icons.people_outline), label: 'Community'),
            NavigationDestination(icon: Icon(Icons.person_outline), label: 'Profile'),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.deepPurple,
          onPressed: () => _showChatbot(context),
          child: const Icon(Icons.smart_toy_rounded, size: 28),
        ),
      ),
    );
  }

  // Drawer Widget
  Drawer _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Theme.of(context).colorScheme.primaryContainer),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 35,
                  backgroundImage: AssetImage('assets/images/profile.png'),
                ),
                const SizedBox(height: 10),
                Text(
                  _greeting,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const Text("Welcome to AIgnite!"),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text('Home'),
            onTap: () => _onItemTapped(0),
          ),
          ListTile(
            leading: const Icon(Icons.menu_book_outlined),
            title: const Text('Courses'),
            onTap: () => _onItemTapped(1),
          ),
          ListTile(
            leading: const Icon(Icons.people_outline),
            title: const Text('Community'),
            onTap: () => _onItemTapped(2),
          ),
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: const Text('Profile'),
            onTap: () => _onItemTapped(3),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings_outlined),
            title: const Text('Settings'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('About App'),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'AIgnite',
                applicationVersion: '1.0.0',
                children: const [
                  Text('AIgnite - Your AI-powered Education Platform'),
                ],
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout_outlined),
            title: const Text('Logout'),
            onTap: () {
              Navigator.pop(context);
              _showLogoutDialog(context);
            },
          ),
        ],
      ),
    );
  }

  // Logout confirmation dialog
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Logged out successfully!")),
              );
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  // Chatbot Bottom Sheet
  void _showChatbot(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final TextEditingController controller = TextEditingController();
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                "AIgnite Chatbot 🤖",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text("Ask me anything about learning or courses."),
              const SizedBox(height: 16),
              TextField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: "Type your question...",
                  prefixIcon: const Icon(Icons.chat_bubble_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("AI response coming soon for: '${controller.text}'")),
                  );
                },
                icon: const Icon(Icons.send),
                label: const Text("Ask AI"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// --------------------------- Pages ---------------------------

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Welcome to AIgnite 🚀\nYour AI-powered Learning Hub",
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }
}

class CoursesPage extends StatelessWidget {
  const CoursesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        Text("Your Courses", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
        SizedBox(height: 10),
        CourseCard(title: "AI Basics", subtitle: "Learn how AI is transforming education"),
        CourseCard(title: "Flutter for Beginners", subtitle: "Build mobile apps like AIgnite"),
        CourseCard(title: "Machine Learning 101", subtitle: "Understand ML fundamentals"),
      ],
    );
  }
}

class CourseCard extends StatelessWidget {
  final String title;
  final String subtitle;

  const CourseCard({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: const Icon(Icons.school_outlined),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {},
      ),
    );
  }
}

class CommunityPage extends StatelessWidget {
  const CommunityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "Join AIgnite Community 💬\nAsk questions, share ideas.",
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 18),
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "Your Profile 👤\nManage your account and settings.",
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 18),
      ),
    );
  }
}
