import 'dart:io';
import 'package:path/path.dart' as p;

class ComponentGenerator {
  static Future<void> generateLogin({int style = 1}) async {
    print('🎨 Generating Premium Login UI (Style $style)...');
    final path = p.join(Directory.current.path, 'lib', 'features', 'auth', 'presentation', 'pages');
    Directory(path).createSync(recursive: true);

    String content = '';
    if (style == 1) {
      content = _loginStyle1();
    } else if (style == 2) {
      content = _loginStyle2();
    } else {
      content = _loginStyle3();
    }

    File(p.join(path, 'login_page.dart')).writeAsStringSync(content);
    print('✅ Login UI Style $style generated at $path');
  }

  static Future<void> generateRegister({int style = 1}) async {
    print('🎨 Generating Premium Register UI (Style $style)...');
    final path = p.join(Directory.current.path, 'lib', 'features', 'auth', 'presentation', 'pages');
    Directory(path).createSync(recursive: true);

    String content = '';
    if (style == 1) {
      content = _registerStyle1();
    } else if (style == 2) {
      content = _registerStyle2();
    } else {
      content = _registerStyle3();
    }

    File(p.join(path, 'register_page.dart')).writeAsStringSync(content);
    print('✅ Register UI Style $style generated at $path');
  }

  static Future<void> generateDashboard({int style = 1}) async {
    print('🎨 Generating Premium Dashboard UI (Style $style)...');
    final path = p.join(Directory.current.path, 'lib', 'features', 'dashboard', 'presentation', 'pages');
    Directory(path).createSync(recursive: true);

    String content = '';
    if (style == 1) {
      content = _dashboardStyle1();
    } else if (style == 2) {
      content = _dashboardStyle2();
    } else {
      content = _dashboardStyle3();
    }

    File(p.join(path, 'dashboard_page.dart')).writeAsStringSync(content);
    print('✅ Dashboard UI Style $style generated at $path');
  }

  // --- LOGIN STYLES ---

  static String _loginStyle1() => '''
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              elevation: 12,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Welcome Back', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    const Text('Login to your account', style: TextStyle(color: Colors.grey)),
                    const SizedBox(height: 32),
                    TextField(decoration: InputDecoration(labelText: 'Email', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)))),
                    const SizedBox(height: 16),
                    TextField(obscureText: true, decoration: InputDecoration(labelText: 'Password', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)))),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2575FC), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                        child: const Text('LOGIN', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
''';

  static String _loginStyle2() => '''
import 'dart:ui';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned(top: -100, left: -100, child: Container(width: 300, height: 300, decoration: const BoxDecoration(color: Colors.blueAccent, shape: BoxShape.circle))),
          Positioned(bottom: -50, right: -50, child: Container(width: 250, height: 250, decoration: const BoxDecoration(color: Colors.purpleAccent, shape: BoxShape.circle))),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
            child: Container(color: Colors.transparent),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('FEX LUX', style: TextStyle(color: Colors.white, fontSize: 42, fontWeight: FontWeight.w900, letterSpacing: 5)),
                  const SizedBox(height: 50),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                      child: Container(
                        padding: const EdgeInsets.all(25),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(color: Colors.white.withOpacity(0.1)),
                        ),
                        child: Column(
                          children: [
                            TextField(style: const TextStyle(color: Colors.white), decoration: InputDecoration(hintText: 'User ID', hintStyle: const TextStyle(color: Colors.white54), prefixIcon: const Icon(Icons.person, color: Colors.white54), border: InputBorder.none)),
                            const Divider(color: Colors.white24),
                            TextField(obscureText: true, style: const TextStyle(color: Colors.white), decoration: InputDecoration(hintText: 'Passcode', hintStyle: const TextStyle(color: Colors.white54), prefixIcon: const Icon(Icons.lock, color: Colors.white54), border: InputBorder.none)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    width: double.infinity,
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [Colors.blue, Colors.purple]),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [BoxShadow(color: Colors.blue.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10))],
                    ),
                    child: const Center(child: Text('AUTHORIZE', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 2))),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
''';

  static String _loginStyle3() => '''
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50),
              const Text('Hello.', style: TextStyle(fontSize: 48, fontWeight: FontWeight.w800, color: Color(0xFF1D1D1F))),
              const Text('Sign in to continue', style: TextStyle(fontSize: 18, color: Colors.grey)),
              const Spacer(),
              TextField(decoration: InputDecoration(hintText: 'Email address', filled: true, fillColor: Colors.grey[100], border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none))),
              const SizedBox(height: 15),
              TextField(obscureText: true, decoration: InputDecoration(hintText: 'Password', filled: true, fillColor: Colors.grey[100], border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none))),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(backgroundColor: Colors.black, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                  child: const Text('Continue', style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
              ),
              const SizedBox(height: 20),
              Center(child: TextButton(onPressed: () {}, child: const Text('Create an account', style: TextStyle(color: Colors.black54)))),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
''';

  // --- REGISTER STYLES ---

  static String _registerStyle1() => '''
import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Account'), elevation: 0),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const CircleAvatar(radius: 50, backgroundColor: Colors.blue, child: Icon(Icons.person_add, size: 50, color: Colors.white)),
            const SizedBox(height: 32),
            TextField(decoration: const InputDecoration(labelText: 'Full Name', prefixIcon: Icon(Icons.person))),
            const SizedBox(height: 16),
            TextField(decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.email))),
            const SizedBox(height: 16),
            TextField(obscureText: true, decoration: const InputDecoration(labelText: 'Password', prefixIcon: Icon(Icons.lock))),
            const SizedBox(height: 16),
            TextField(obscureText: true, decoration: const InputDecoration(labelText: 'Confirm Password', prefixIcon: Icon(Icons.lock_outline))),
            const SizedBox(height: 32),
            SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () {}, child: const Text('SIGN UP'))),
          ],
        ),
      ),
    );
  }
}
''';

  static String _registerStyle2() => '''
import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(height: 250, width: double.infinity, decoration: const BoxDecoration(color: Colors.black, borderRadius: BorderRadius.only(bottomLeft: Radius.circular(80))), child: const Center(child: Text('JOIN US', style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: 5)))),
          Expanded(child: Padding(padding: const EdgeInsets.all(30), child: Column(children: [
            TextField(decoration: const InputDecoration(labelText: 'Username')),
            TextField(decoration: const InputDecoration(labelText: 'Email Address')),
            TextField(obscureText: true, decoration: const InputDecoration(labelText: 'Secret Password')),
            const Spacer(),
            Container(width: double.infinity, height: 60, decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(10)), child: const Center(child: Text('REGISTER NOW', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)))),
            const SizedBox(height: 20),
          ])))
        ],
      ),
    );
  }
}
''';

  static String _registerStyle3() => '''
import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Container(decoration: const BoxDecoration(image: DecorationImage(image: NetworkImage('https://images.unsplash.com/photo-1557683316-973673baf926'), fit: BoxFit.cover))),
        Container(color: Colors.black45),
        Padding(padding: const EdgeInsets.all(30), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Text('NEW USER', style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold)),
          const SizedBox(height: 40),
          TextField(style: const TextStyle(color: Colors.white), decoration: InputDecoration(enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.white), borderRadius: BorderRadius.circular(15)), focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.blue), borderRadius: BorderRadius.circular(15)), labelText: 'Email', labelStyle: const TextStyle(color: Colors.white))),
          const SizedBox(height: 20),
          TextField(obscureText: true, style: const TextStyle(color: Colors.white), decoration: InputDecoration(enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.white), borderRadius: BorderRadius.circular(15)), focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.blue), borderRadius: BorderRadius.circular(15)), labelText: 'Password', labelStyle: const TextStyle(color: Colors.white))),
          const SizedBox(height: 40),
          Container(width: double.infinity, height: 55, decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(15)), child: const Center(child: Text('CREATE ACCOUNT', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)))),
        ]))
      ]),
    );
  }
}
''';

  // --- DASHBOARD STYLES ---

  static String _dashboardStyle1() => '''
import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Console'), actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.notifications))]),
      body: GridView.count(
        padding: const EdgeInsets.all(20),
        crossAxisCount: 2,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        children: [
          _buildStatCard('Users', '1,240', Icons.people, Colors.blue),
          _buildStatCard('Revenue', '\$42.5k', Icons.attach_money, Colors.green),
          _buildStatCard('Errors', '12', Icons.error, Colors.red),
          _buildStatCard('Uptime', '99.9%', Icons.check_circle, Colors.orange),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String val, IconData icon, Color color) {
    return Card(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Icon(icon, color: color, size: 40),
      const SizedBox(height: 10),
      Text(val, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
      Text(title, style: const TextStyle(color: Colors.grey)),
    ]));
  }
}
''';

  static String _dashboardStyle2() => '''
import 'package:flutter/material.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});
  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _index = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: [
        _page('Feed', Icons.home),
        _page('Search', Icons.search),
        _page('Profile', Icons.person),
      ]),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
  Widget _page(String t, IconData i) => Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(i, size: 100, color: Colors.blue), Text(t, style: const TextStyle(fontSize: 32))]));
}
''';

  static String _dashboardStyle3() => '''
import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Enterprise Manager')),
      drawer: Drawer(
        child: ListView(children: [
          const DrawerHeader(decoration: BoxDecoration(color: Colors.blue), child: Text('FEX MENU', style: TextStyle(color: Colors.white, fontSize: 24))),
          ListTile(leading: const Icon(Icons.dashboard), title: const Text('Dashboard'), onTap: () {}),
          ListTile(leading: const Icon(Icons.settings), title: const Text('Settings'), onTap: () {}),
          ListTile(leading: const Icon(Icons.logout), title: const Text('Logout'), onTap: () {}),
        ]),
      ),
      body: const Center(child: Text('Content Area')),
    );
  }
}
''';
}
