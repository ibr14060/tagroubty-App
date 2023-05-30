import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'CreateNewAccount.dart';
import 'GuestPage.dart';
import 'HomePage.dart';

//void main() => runApp(LoginScreen());

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginScreenapp(),
    );
  }
}

class LoginScreenapp extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreenapp> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  Future<bool> authenticateUser(String username, String password) async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://our-first-tagrouba-project-default-rtdb.firebaseio.com/create_new_account.json',
        ),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);

        if (jsonData.containsKey(username)) {
          final String dbPassword = jsonData[username]['password'];

          if (dbPassword == password) {
            return true; // Username and password are correct
          }
        }
      }

      return false; // Username or password is incorrect
    } catch (error) {
      print('Error authenticating user: $error');
      return false;
    }
  }

  void _login() async {
    String username = _usernameController.text;
    String password = _passwordController.text;

    bool isAuthenticated = await authenticateUser(username, password);

    if (isAuthenticated) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Success'),
            content: Text('Login successful'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );

      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => HomePage(
                title: 'Home Page',
                username: username // Pass the post['name'] as an attribute
                )),
      );

      //
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Username or password is incorrect'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  void _signup() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CreateNewAccount()),
    );
  }

  void _loginAsGuest() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => const GuestPage(title: 'Home page')),
    );
    print('Login as Guest button pressed');
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Page'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
              ),
            ),
            SizedBox(height: 16.0),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _login,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.login),
                        SizedBox(width: 8.0),
                        Text('Log In'),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 16.0),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _signup,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.new_label),
                        SizedBox(width: 8.0),
                        Text('Sign Up'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _loginAsGuest,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.person),
                  SizedBox(width: 8.0),
                  Text('Login As Guest'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
