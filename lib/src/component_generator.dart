import 'dart:io';
import 'package:path/path.dart' as p;

class ComponentGenerator {
  static Future<void> generateLogin() async {
    print('🎨 Generating Premium Login UI...');
    final path = p.join(Directory.current.path, 'lib', 'app', 'modules', 'login');
    Directory(p.join(path, 'views')).createSync(recursive: true);

    File(p.join(path, 'views', 'login_view.dart')).writeAsStringSync('''
import 'package:flutter/material.dart';

class PremiumLoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            colors: [Colors.blue[900]!, Colors.blue[600]!, Colors.blue[400]!]
          )
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 80),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Login", style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Text("Welcome Back", style: TextStyle(color: Colors.white, fontSize: 18)),
                ],
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(60), topRight: Radius.circular(60))
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(30),
                    child: Column(
                      children: [
                        SizedBox(height: 60),
                        _buildInputField("Email or Phone"),
                        SizedBox(height: 20),
                        _buildInputField("Password", isPassword: true),
                        SizedBox(height: 40),
                        Text("Forgot Password?", style: TextStyle(color: Colors.grey)),
                        SizedBox(height: 40),
                        _buildLoginButton(),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(String hint, {bool isPassword = false}) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [BoxShadow(color: Color.fromRGBO(225, 95, 27, .3), blurRadius: 20, offset: Offset(0, 10))]
      ),
      child: TextField(
        obscureText: isPassword,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey),
          border: InputBorder.none
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return Container(
      height: 50,
      margin: EdgeInsets.symmetric(horizontal: 50),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: Colors.blue[900]
      ),
      child: Center(
        child: Text("Login", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
''');
  }

  static Future<void> generateSplash() async {
    print('🎨 Generating Beautiful Splash Screen...');
    final path = p.join(Directory.current.path, 'lib', 'app', 'modules', 'splash');
    Directory(p.join(path, 'views')).createSync(recursive: true);

    File(p.join(path, 'views', 'splash_view.dart')).writeAsStringSync('''
import 'package:flutter/material.dart';

class PremiumSplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Placeholder for Lottie or Logo
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [Colors.blue[100]!, Colors.white])
              ),
              child: Icon(Icons.flash_on, size: 100, color: Colors.blue[900]),
            ),
            SizedBox(height: 30),
            Text(
              "MY AWESOME APP",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: 4,
                color: Colors.blue[900]
              ),
            ),
            SizedBox(height: 10),
            CircularProgressIndicator(color: Colors.blue[900]),
          ],
        ),
      ),
    );
  }
}
''');
  }
}
