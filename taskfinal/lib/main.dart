import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Authentication Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green, // Custom button color
          ),
        ),
      ),
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _passwordVisible = false;

  // Dummy user credentials stored locally
  final Map<String, String> userCredentials = {
    'soni': 'soni1234',
    // Add more username-password pairs as needed
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Welcome', style: TextStyle(fontSize: 24)),
            SizedBox(height: 20),
            TextField(
              controller: usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: passwordController,
              obscureText: !_passwordVisible,
              decoration: InputDecoration(
                labelText: 'Password',
                suffixIcon: IconButton(
                  icon: Icon(
                    _passwordVisible ? Icons.visibility : Icons.visibility_off,
                    color: Theme.of(context).primaryColorDark,
                  ),
                  onPressed: () {
                    setState(() {
                      // Toggle the password visibility state
                      _passwordVisible = !_passwordVisible;
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Implement login functionality
                String username = usernameController.text;
                String password = passwordController.text;

                // Check if username exists and password matches
                if (userCredentials.containsKey(username) &&
                    userCredentials[username] == password) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DashboardScreen(username, usernameController, passwordController),
                    ),
                  );
                } else {
                  // Show error message for invalid credentials
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Error'),
                        content: Text('Invalid username or password.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: Text('Login'),
            ),
            SizedBox(height: 10),
            TextButton(
              onPressed: () async {
                final controllers = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterScreen(userCredentials)),
                );
                // Set the controllers to the local controllers
                setState(() {
                  usernameController = controllers[0];
                  passwordController = controllers[1];
                });
              },
              child: Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}

class RegisterScreen extends StatefulWidget {
  final Map<String, String> userCredentials;

  RegisterScreen(this.userCredentials);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              obscureText: !_passwordVisible,
              decoration: InputDecoration(
                labelText: 'Password',
                suffixIcon: IconButton(
                  icon: Icon(
                    _passwordVisible ? Icons.visibility : Icons.visibility_off,
                    color: Theme.of(context).primaryColorDark,
                  ),
                  onPressed: () {
                    setState(() {
                      // Toggle the password visibility state
                      _passwordVisible = !_passwordVisible;
                    });
                  },
                ),
              ),
            ),
            TextField(
              controller: confirmPasswordController,
              obscureText: !_passwordVisible,
              decoration: InputDecoration(
                labelText: 'Confirm Password',
                suffixIcon: IconButton(
                  icon: Icon(
                    _passwordVisible ? Icons.visibility : Icons.visibility_off,
                    color: Theme.of(context).primaryColorDark,
                  ),
                  onPressed: () {
                    setState(() {
                      // Toggle the password visibility state
                      _passwordVisible = !_passwordVisible;
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Implement registration functionality
                String username = usernameController.text;
                String email = emailController.text;
                String password = passwordController.text;
                String confirmPassword = confirmPasswordController.text;

                // Validate email format
                RegExp emailRegex =
                RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                if (!emailRegex.hasMatch(email)) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Error'),
                        content: Text('Please enter a valid email address.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                  return; // Exit registration process if email is invalid
                }

                // Validate password strength
                RegExp passwordRegex = RegExp(
                    r'^(?=.[A-Z])(?=.[!@#$&])(?=.[0-9])(?=.*[a-z]).{6,}$');
                if (!passwordRegex.hasMatch(password)) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Error'),
                        content: Text(
                            'Password must contain at least one uppercase letter, one special character, one number, and be at least 6 characters long.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                  return; // Exit registration process if password is invalid
                }

                // Here you should implement the logic for actual registration
                // For demonstration purposes, let's assume a successful registration
                if (username.isNotEmpty &&
                    email.isNotEmpty &&
                    password.isNotEmpty &&
                    confirmPassword.isNotEmpty) {
                  // Check if username already exists
                  if (widget.userCredentials.containsKey(username)) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Error'),
                          content: Text('Username already exists.'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  } else if (password != confirmPassword) {
                    // Show error message for password mismatch
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Error'),
                          content: Text('Password and Confirm Password do not match.'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    // Add new user credentials
                    widget.userCredentials[username] = password;
                    print('Registration successful');
                    // Navigate back to login screen
                    Navigator.pop(context, [usernameController, passwordController]);
                  }
                } else {
                  // Show error message for invalid registration details
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Error'),
                        content: Text('Please enter valid username, email, password, and confirm password.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}

class DashboardScreen extends StatelessWidget {
  final String username;
  final TextEditingController usernameController;
  final TextEditingController passwordController;

  DashboardScreen(this.username, this.usernameController, this.passwordController);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Fresher Bot')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Welcome, $username!', style: TextStyle(fontSize: 24)),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Clear the text fields
                  usernameController.clear();
                  passwordController.clear();
                  // Navigate back to login screen
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red, // Red color for logout button
                ),
                child: Text('Logout'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}