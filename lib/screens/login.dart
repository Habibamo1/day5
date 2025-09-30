// import 'package:day5/screens/home_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:dio/dio.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});

//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _usernameController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();

//   bool _isLoading = false;
//   final Dio _dio = Dio();

//   Future<void> _login() async {
//     if (!_formKey.currentState!.validate()) return;

//     setState(() => _isLoading = true);

//     try {
//       final response = await _dio.post(
//         "https://dummyjson.com/auth/login",
//         data: {
//           "username": _usernameController.text,
//           "password": _passwordController.text,
//         },
//         options: Options(headers: {"Content-Type": "application/json"}),
//       );

//       if (response.statusCode == 200) {
//         final data = response.data;

//         final prefs = await SharedPreferences.getInstance();
//         await prefs.setString("token", data["token"]);

//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => const HomePage()),
//         );
//       }
//     } on DioException catch (e) {
//       String errorMessage = "Login failed";
//       if (e.response != null) {
//         errorMessage = e.response?.data["message"] ?? "Invalid";
//       }
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text(errorMessage)));
//     } catch (e) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text("Error: $e")));
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           Container(
//             color: Colors.deepOrange,
//             width: double.infinity,
//             height: 300,
//             child: Column(
//               children: [
//                 Icon(Icons.ice_skating_outlined, color: Colors.black),
//                 Text("Login "),
//               ],
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Form(
//               key: _formKey,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   // Username
//                   TextFormField(
//                     controller: _usernameController,
//                     decoration: const InputDecoration(labelText: "Username"),
//                     validator: (value) => value == null || value.isEmpty
//                         ? "Enter username"
//                         : null,
//                   ),
//                   const SizedBox(height: 16),

//                   // Password
//                   TextFormField(
//                     controller: _passwordController,
//                     decoration: const InputDecoration(labelText: "Password"),
//                     obscureText: true,
//                     validator: (value) => value == null || value.length < 6
//                         ? "Password must be at least 6 characters"
//                         : null,
//                   ),
//                   const SizedBox(height: 24),

//                   // Login Button
//                   _isLoading
//                       ? const CircularProgressIndicator()
//                       : ElevatedButton(
//                           onPressed: _login,
//                           child: const Text("Login"),
//                         ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:day5/screens/api_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_screen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  final ApiService _api = ApiService();
  final TextEditingController _usernameController = TextEditingController(
    text: 'kminchelle',
  ); // example
  final TextEditingController _passwordController = TextEditingController(
    text: '0lelplR',
  ); // example
  bool _isLoading = false;

  void _login(String username, String password) async {
    // if (!_formKey.currentState!.validate()) return;
    // setState(() => _isLoading = true);

    try {
      Response data = await _api.login("/auth/login", {
        "username": username,
        "password": password,
      }, {});
      // final token = data['accessToken'] as String?;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (c) => const HomePage()),
      );
      // if (token != null) {
      //   final prefs = await SharedPreferences.getInstance();
      //   await prefs.setString('token', token);
      //   print()
      //   Navigator.pushReplacement(
      //     context,
      //     MaterialPageRoute(builder: (c) => const HomePage()),
      //   );
      // } else {
      //   ScaffoldMessenger.of(
      //     context,
      //   ).showSnackBar(const SnackBar(content: Text('Login failed')));
      // }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FormBuilder(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FormBuilderTextField(
                name: "username",
                controller: _usernameController,
                decoration: const InputDecoration(labelText: 'Username'),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Enter username' : null,
              ),
              const SizedBox(height: 12),
              FormBuilderTextField(
                name: "pass",
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                // obscureText: true,
                validator: (v) => v == null || v.length < 6
                    ? 'Password at least 6 chars'
                    : null,
              ),
              const SizedBox(height: 20),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.isValid) {
                          _login(
                            _formKey.currentState?.value["username"] ?? "",
                            _formKey.currentState?.value["pass"] ?? "",
                          );
                        }
                      },
                      child: const Text('Login'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
