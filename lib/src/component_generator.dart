import 'dart:io';
import 'package:path/path.dart' as p;

class ComponentGenerator {
  static Future<void> generateLogin({int style = 1}) async {
    print('🚀 Overhauling Login UI with High-Fidelity Style $style...');
    final path = p.join(Directory.current.path, 'lib', 'features', 'auth', 'presentation', 'pages');
    Directory(path).createSync(recursive: true);

    String content = '';
    switch (style) {
      case 1: content = _loginStyle1(); break;
      case 2: content = _loginStyle2(); break;
      case 3: content = _loginStyle3(); break;
      default: content = _loginStyle1();
    }

    File(p.join(path, 'login_page.dart')).writeAsStringSync(content);
    print('✅ Solid Login UI Style $style generated at $path');
  }

  static Future<void> generateForgotPassword() async {
    print('🚀 Generating Premium Forgot Password UI...');
    final path = p.join(Directory.current.path, 'lib', 'features', 'auth', 'presentation', 'pages');
    Directory(path).createSync(recursive: true);

    File(p.join(path, 'forgot_password_page.dart')).writeAsStringSync(_forgotPasswordTemplate());
    print('✅ Forgot Password UI generated at $path');
  }

  static Future<void> generateRegister({int style = 1}) async {
    print('🚀 Overhauling Register UI with High-Fidelity Style $style...');
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
    print('✅ Solid Register UI Style $style generated at $path');
  }

  static Future<void> generateDashboard({int style = 1}) async {
    print('🚀 Overhauling Dashboard UI with High-Fidelity Style $style...');
    final path = p.join(Directory.current.path, 'lib', 'features', 'dashboard', 'presentation', 'pages');
    Directory(path).createSync(recursive: true);

    String content = '';
    switch (style) {
      case 1: content = _dashboardStyle1(); break;
      case 2: content = _dashboardStyle2(); break;
      case 3: content = _dashboardStyle3(); break;
      default: content = _dashboardStyle1();
    }

    File(p.join(path, 'dashboard_page.dart')).writeAsStringSync(content);
    print('✅ Solid Dashboard UI Style $style generated at $path');
  }

  // ===========================================================================
  // LOGIN STYLES
  // ===========================================================================

  static String _loginStyle1() => '''
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500));
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Container(
              height: constraints.maxHeight,
              width: constraints.maxWidth,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Theme.of(context).primaryColor, const Color(0xFF2575FC)],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
              ),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  children: [
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40),
                        ),
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Welcome Back', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black87)),
                            const Text('Please sign in to continue', style: TextStyle(color: Colors.grey, fontSize: 16)),
                            const SizedBox(height: 40),
                            _buildTextField('Email', Icons.email_outlined, false),
                            const SizedBox(height: 20),
                            _buildTextField('Password', Icons.lock_outline, true),
                            const SizedBox(height: 12),
                            Align(alignment: Alignment.centerRight, child: TextButton(onPressed: () {}, child: const Text('Forgot Password?'))),
                            const SizedBox(height: 32),
                            _buildSubmitButton(),
                            const SizedBox(height: 24),
                            const Center(child: Text('OR JOIN WITH', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 12))),
                            const SizedBox(height: 24),
                            _buildSocialButtons(),
                            const SizedBox(height: 32),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      ),
    );
  }

  Widget _buildTextField(String label, IconData icon, bool isPassword) {
    return TextFormField(
      obscureText: isPassword,
      validator: (val) => val!.isEmpty ? 'Field cannot be empty' : null,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Theme.of(context).primaryColor),
        filled: true,
        fillColor: Colors.grey[50],
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: () => _formKey.currentState!.validate(),
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 5,
        ),
        child: const Text('SIGN IN', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
      ),
    );
  }

  Widget _buildSocialButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _socialIcon(Icons.g_mobiledata, Colors.redAccent),
        const SizedBox(width: 20),
        _socialIcon(Icons.apple, Colors.black),
        const SizedBox(width: 20),
        _socialIcon(Icons.facebook, Colors.blue[800]!),
      ],
    );
  }

  Widget _socialIcon(IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[200]!),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Icon(icon, color: color, size: 32),
    );
  }
}
''';

  static String _loginStyle2() => '''
import 'dart:ui';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F1A),
      body: Stack(
        children: [
          // Background Glows
          Positioned(top: -150, left: -50, child: _glowCircle(300, Colors.deepPurple.withOpacity(0.5))),
          Positioned(bottom: -100, right: -50, child: _glowCircle(250, Colors.blueAccent.withOpacity(0.4))),
          
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(30),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.white.withOpacity(0.1)),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.security, size: 80, color: Colors.cyanAccent),
                        const SizedBox(height: 24),
                        const Text('NEURAL ACCESS', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 4)),
                        const SizedBox(height: 40),
                        _neonInput('Encrypted ID', Icons.fingerprint),
                        const SizedBox(height: 20),
                        _neonInput('Security Code', Icons.vibration, isPass: true),
                        const SizedBox(height: 40),
                        _neonButton(),
                        const SizedBox(height: 30),
                        const Row(children: [Expanded(child: Divider(color: Colors.white10)), Padding(padding: EdgeInsets.symmetric(horizontal: 10), child: Text('BYPASS WITH', style: TextStyle(color: Colors.white30, fontSize: 10))), Expanded(child: Divider(color: Colors.white10))]),
                        const SizedBox(height: 24),
                        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                          _miniNeonBtn(Icons.alternate_email),
                          const SizedBox(width: 15),
                          _miniNeonBtn(Icons.hub),
                          const SizedBox(width: 15),
                          _miniNeonBtn(Icons.terminal),
                        ]),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _glowCircle(double size, Color color) => Container(width: size, height: size, decoration: BoxDecoration(color: color, shape: BoxShape.circle, boxShadow: [BoxShadow(color: color, blurRadius: 100, spreadRadius: 50)]));

  Widget _neonInput(String hint, IconData icon, {bool isPass = false}) {
    return Container(
      decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(15)),
      child: TextField(
        obscureText: isPass,
        style: const TextStyle(color: Colors.cyanAccent),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white24),
          prefixIcon: Icon(icon, color: Colors.cyanAccent.withOpacity(0.7)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(20),
        ),
      ),
    );
  }

  Widget _neonButton() {
    return InkWell(
      onTap: () {},
      onHover: (v) => setState(() => _isHovered = v),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(
          color: _isHovered ? Colors.cyanAccent : Colors.transparent,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.cyanAccent, width: 2),
          boxShadow: _isHovered ? [const BoxShadow(color: Colors.cyanAccent, blurRadius: 20, spreadRadius: 2)] : [],
        ),
        child: Center(child: Text('INITIALIZE', style: TextStyle(color: _isHovered ? Colors.black : Colors.cyanAccent, fontWeight: FontWeight.bold, letterSpacing: 2))),
      ),
    );
  }

  Widget _miniNeonBtn(IconData i) => Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.white10)), child: Icon(i, color: Colors.white, size: 20));
}
''';

  static String _loginStyle3() => '''
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 60),
              _appLogo(),
              const SizedBox(height: 40),
              const Text('Hello.', style: TextStyle(fontSize: 48, fontWeight: FontWeight.w900, color: Color(0xFF1D1D1F))),
              const Text('Enter your credentials to continue.', style: TextStyle(fontSize: 18, color: Colors.black45)),
              const Spacer(),
              _minimalInput('Username'),
              const SizedBox(height: 15),
              _minimalInput('Password', isPass: true),
              const SizedBox(height: 40),
              _minimalButton(context),
              const SizedBox(height: 20),
              _socialRow(),
              const Spacer(),
              Center(child: TextButton(onPressed: () {}, child: const Text('New here? Create Account', style: TextStyle(color: Colors.blueAccent)))),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _appLogo() => Container(width: 60, height: 60, decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(18)), child: const Icon(Icons.apple, color: Colors.white, size: 35));

  Widget _minimalInput(String label, {bool isPass = false}) {
    return TextField(
      obscureText: isPass,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.black38),
        floatingLabelStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.black12, width: 2)),
        focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.black, width: 2)),
      ),
    );
  }

  Widget _minimalButton(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
        child: const Text('Login', style: TextStyle(color: Colors.white, fontSize: 18)),
      ),
    );
  }

  Widget _socialRow() {
    return Row(
      children: [
        Expanded(child: _socialBtn('Google', Icons.g_mobiledata)),
        const SizedBox(width: 15),
        Expanded(child: _socialBtn('Github', Icons.hub)),
      ],
    );
  }

  Widget _socialBtn(String t, IconData i) => OutlinedButton.icon(
    onPressed: () {},
    icon: Icon(i, color: Colors.black),
    label: Text(t, style: const TextStyle(color: Colors.black)),
    style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 15), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
  );
}
''';

  // ===========================================================================
  // REGISTER STYLES
  // ===========================================================================

  static String _registerStyle1() => '''
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [Color(0xFF6A11CB), Color(0xFF2575FC)], begin: Alignment.topLeft, end: Alignment.bottomRight),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Create Account', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 32),
                      _field('Full Name', Icons.person_outline),
                      const SizedBox(height: 16),
                      _field('Email', Icons.email_outlined),
                      const SizedBox(height: 16),
                      _field('Password', Icons.lock_outline, isPass: true),
                      const SizedBox(height: 32),
                      _submitBtn(),
                      const SizedBox(height: 20),
                      _socialRow(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _field(String l, IconData i, {bool isPass = false}) => TextFormField(obscureText: isPass, decoration: InputDecoration(labelText: l, prefixIcon: Icon(i), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))));
  Widget _submitBtn() => SizedBox(width: double.infinity, height: 55, child: ElevatedButton(onPressed: () => _formKey.currentState!.validate(), style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), child: const Text('REGISTER')));
  Widget _socialRow() => Row(mainAxisAlignment: MainAxisAlignment.center, children: [const Icon(Icons.g_mobiledata, size: 40, color: Colors.red), const SizedBox(width: 20), const Icon(Icons.apple, size: 40)]);
}
''';

  static String _registerStyle2() => '''
import 'dart:ui';
import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F1A),
      body: Stack(
        children: [
          Positioned(top: -50, right: -50, child: Container(width: 200, height: 200, decoration: const BoxDecoration(color: Colors.cyanAccent, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.cyanAccent, blurRadius: 100)]))),
          BackdropFilter(filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50), child: Container(color: Colors.transparent)),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(30),
              child: Container(
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(30), border: Border.all(color: Colors.white.withOpacity(0.1))),
                child: Column(
                  children: [
                    const Text('JOIN MATRIX', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 4)),
                    const SizedBox(height: 40),
                    _neonInp('User Alias', Icons.face),
                    const SizedBox(height: 20),
                    _neonInp('Neural Link (Email)', Icons.alternate_email),
                    const SizedBox(height: 20),
                    _neonInp('Access Key', Icons.key, isPass: true),
                    const SizedBox(height: 40),
                    _btn(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _neonInp(String h, IconData i, {bool isPass = false}) => TextField(obscureText: isPass, style: const TextStyle(color: Colors.cyanAccent), decoration: InputDecoration(hintText: h, hintStyle: const TextStyle(color: Colors.white24), prefixIcon: Icon(i, color: Colors.cyanAccent), border: InputBorder.none, filled: true, fillColor: Colors.black26));
  Widget _btn() => Container(width: double.infinity, height: 60, decoration: BoxDecoration(border: Border.all(color: Colors.cyanAccent), borderRadius: BorderRadius.circular(15)), child: const Center(child: Text('REGISTER', style: TextStyle(color: Colors.cyanAccent, fontWeight: FontWeight.bold))));
}
''';

  static String _registerStyle3() => '''
import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Join Us.', style: TextStyle(fontSize: 48, fontWeight: FontWeight.w900)),
              const Text('Create a new account', style: TextStyle(color: Colors.grey, fontSize: 18)),
              const Spacer(),
              _inp('Full Name'),
              const SizedBox(height: 15),
              _inp('Email Address'),
              const SizedBox(height: 15),
              _inp('Password', isPass: true),
              const SizedBox(height: 40),
              _btn(),
              const SizedBox(height: 20),
              _socials(),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
  Widget _inp(String l, {bool isPass = false}) => TextField(obscureText: isPass, decoration: InputDecoration(labelText: l, border: const UnderlineInputBorder()));
  Widget _btn() => SizedBox(width: double.infinity, height: 60, child: ElevatedButton(onPressed: () {}, style: ElevatedButton.styleFrom(backgroundColor: Colors.black, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))), child: const Text('Continue', style: TextStyle(color: Colors.white))));
  Widget _socials() => Row(children: [Expanded(child: OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.g_mobiledata, color: Colors.black), label: const Text('Google', style: TextStyle(color: Colors.black)))), const SizedBox(width: 15), Expanded(child: OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.apple, color: Colors.black), label: const Text('Apple', style: TextStyle(color: Colors.black))))]);
}
''';

  static String _forgotPasswordTemplate() => '''
import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0, backgroundColor: Colors.transparent, foregroundColor: Colors.black),
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Reset Password', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            const Text('Enter your email and we will send you a reset link.', style: TextStyle(color: Colors.grey, fontSize: 16)),
            const SizedBox(height: 40),
            TextField(decoration: InputDecoration(labelText: 'Email Address', border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)))),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                child: const Text('SEND RESET LINK'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
''';

  // ===========================================================================
  // DASHBOARD STYLES
  // ===========================================================================

  static String _dashboardStyle1() => '''
import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      appBar: _appBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Morning, Commander', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            _statsRow(),
            const SizedBox(height: 30),
            const Text('Recent Operations', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            _operationCard('Neural Scan', 'Completed', Icons.auto_awesome, Colors.purple),
            _operationCard('Security Audit', 'In Progress', Icons.shield, Colors.blue),
            _operationCard('Dependency Fix', 'Pending', Icons.healing, Colors.orange),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _appBar() => AppBar(elevation: 0, backgroundColor: Colors.transparent, foregroundColor: Colors.black, title: const Text('FEX Console', style: TextStyle(fontWeight: FontWeight.bold)), actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.grid_view_rounded))]);
  
  Widget _statsRow() => Row(children: [
    _stat('UPTIME', '99.9%', Colors.green),
    const SizedBox(width: 15),
    _stat('LOAD', '42%', Colors.blue),
  ]);

  Widget _stat(String l, String v, Color c) => Expanded(child: Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: c.withOpacity(0.3))), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(l, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey)), Text(v, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: c))])));

  Widget _operationCard(String t, String s, IconData i, Color c) => Card(margin: const EdgeInsets.only(bottom: 15), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)), child: ListTile(leading: CircleAvatar(backgroundColor: c.withOpacity(0.1), child: Icon(i, color: c)), title: Text(t, style: const TextStyle(fontWeight: FontWeight.bold)), subtitle: Text(s), trailing: const Icon(Icons.chevron_right)));
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
  int _idx = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF1A1A2E), Color(0xFF16213E)], begin: Alignment.topLeft, end: Alignment.bottomRight)),
        child: SafeArea(
          child: Column(
            children: [
              const Padding(padding: EdgeInsets.all(30), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Discovery', style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)), Text('Explore the matrix', style: TextStyle(color: Colors.white54))]), CircleAvatar(radius: 25, backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=fex'))])),
              Expanded(child: ListView(padding: const EdgeInsets.symmetric(horizontal: 30), children: [
                _card('Security Hub', 'Active Scan', Icons.security, Colors.cyanAccent),
                _card('Performance', '92% Score', Icons.speed, Colors.pinkAccent),
                _card('AI Assistant', 'Ready', Icons.smart_toy, Colors.greenAccent),
              ])),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF1A1A2E),
        selectedItemColor: Colors.cyanAccent,
        unselectedItemColor: Colors.white24,
        currentIndex: _idx,
        onTap: (i) => setState(() => _idx = i),
        items: const [BottomNavigationBarItem(icon: Icon(Icons.grid_view), label: 'Core'), BottomNavigationBarItem(icon: Icon(Icons.flash_on), label: 'Active'), BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Config')],
      ),
    );
  }
  Widget _card(String t, String d, IconData i, Color c) => Container(margin: const EdgeInsets.only(bottom: 20), padding: const EdgeInsets.all(25), decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(30), border: Border.all(color: c.withOpacity(0.3))), child: Row(children: [Icon(i, color: c, size: 40), const SizedBox(width: 20), Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(t, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)), Text(d, style: const TextStyle(color: Colors.white54))])]));
}
''';

  static String _dashboardStyle3() => '''
import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: Drawer(
        child: Column(children: [
          const UserAccountsDrawerHeader(accountName: Text('Royhan'), accountEmail: Text('admin@fex.ai'), currentAccountPicture: CircleAvatar(backgroundColor: Colors.white, child: Text('R'))),
          ListTile(leading: const Icon(Icons.analytics), title: const Text('Analytics'), onTap: () {}),
          ListTile(leading: const Icon(Icons.storage), title: const Text('Database'), onTap: () {}),
          ListTile(leading: const Icon(Icons.cloud), title: const Text('Cloud Sync'), onTap: () {}),
          const Spacer(),
          const Divider(),
          ListTile(leading: const Icon(Icons.logout, color: Colors.red), title: const Text('Logout', style: TextStyle(color: Colors.red)), onTap: () {}),
        ]),
      ),
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(expandedHeight: 200, floating: false, pinned: true, flexibleSpace: FlexibleSpaceBar(title: Text('ENTREPRISE HUB'), background: Image(image: NetworkImage('https://images.unsplash.com/photo-1460925895917-afdab827c52f?auto=format&fit=crop&w=800&q=80'), fit: BoxFit.cover))),
          SliverList(delegate: SliverChildBuilderDelegate((c, i) => ListTile(title: Text('Project Item #\$i'), subtitle: Text('Updated 2 hours ago'), trailing: const Icon(Icons.more_vert)), childCount: 20)),
        ],
      ),
    );
  }
}
''';
}
