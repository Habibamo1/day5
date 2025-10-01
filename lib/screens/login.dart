// import 'package:day5/provider/user_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_form_builder/flutter_form_builder.dart';
// import 'package:provider/provider.dart';
// import 'home_screen.dart';

// class LoginPage extends StatelessWidget {
//   const LoginPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final userProvider = context.watch<UserProvider>();

//     final _formKey = GlobalKey<FormBuilderState>();

//     return Scaffold(
//       appBar: AppBar(title: const Text('Login')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: FormBuilder(
//           key: _formKey,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               FormBuilderTextField(
//                 name: "username",
//                 controller: userProvider.usernameController,
//                 decoration: const InputDecoration(labelText: 'Username'),
//                 validator: (v) =>
//                     v == null || v.isEmpty ? 'Enter username' : null,
//               ),
//               const SizedBox(height: 12),
//               FormBuilderTextField(
//                 name: "pass",
//                 controller: userProvider.passwordController,
//                 decoration: const InputDecoration(labelText: 'Password'),
//                 obscureText: true,
//                 validator: (v) => v == null || v.length < 6
//                     ? 'Password at least 6 chars'
//                     : null,
//               ),
//               const SizedBox(height: 20),
//               userProvider.isLoading
//                   ? const CircularProgressIndicator()
//                   : ElevatedButton(
//                       onPressed: () async {
//                         _formKey.currentState?.saveAndValidate();
//                         if (_formKey.currentState!.isValid) {
//                           final success = await userProvider.login();

//                           if (success) {
//                             Navigator.pushReplacement(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (c) => const HomePage(),
//                               ),
//                             );
//                           } else {
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               const SnackBar(content: Text('Login failed')),
//                             );
//                           }
//                         }
//                       },
//                       child: const Text('Login'),
//                     ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:day5/main.dart';
import 'package:day5/screens/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/user_provider.dart';
import 'home_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: userProvider.formkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Login',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 40),

                // username
                TextFormField(
                  controller: userProvider.usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Username',
                    border: OutlineInputBorder(),
                  ),
                  validator: (val) =>
                      val == null || val.isEmpty ? 'Enter username' : null,
                ),
                const SizedBox(height: 16),

                // password
                TextFormField(
                  controller: userProvider.passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  validator: (val) =>
                      val == null || val.length < 6 ? 'Invalid password' : null,
                ),
                const SizedBox(height: 24),

                userProvider.isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: () async {
                          if (userProvider.formkey.currentState!.validate()) {
                            final success = await userProvider.login();
                            if (success && context.mounted) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const HomeScreen(),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Login failed, try again"),
                                ),
                              );
                            }
                          }
                        },
                        child: const Text('Login'),
                      ),
                const SizedBox(height: 16),

                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SignupPage()),
                    );
                  },
                  child: const Text("Don't have an account? Register"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
