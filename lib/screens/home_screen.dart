// // import 'package:flutter/material.dart';

// // class HomeScreen extends StatefulWidget {
// //   const HomeScreen({super.key});

// //   @override
// //   State<HomeScreen> createState() => _HomeScreenState();
// // }

// // class _HomeScreenState extends State<HomeScreen> {
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(title: Text("Home Screen ")),
// //       body: Drawer(
// //         child: Column(
// //           children: [
// //             SizedBox(child: Container(width: 100, height: 100)),
// //             SizedBox(child: Container(width: 100, height: 100)),
// //             SizedBox(child: Container(width: 100, height: 100)),
// //             SizedBox(child: Container(width: 100, height: 100)),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }

// import 'package:flutter/material.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   int _currentIndex = 0;

//   final List<Widget> _screens = const [
//     Center(child: Text(" Home Screen", style: TextStyle(fontSize: 24))),
//     Center(child: Text(" Search Screen", style: TextStyle(fontSize: 24))),
//     Center(child: Text(" Profile Screen", style: TextStyle(fontSize: 24))),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Products"),bottom: TabBar(isScrollable: true,
//         tabs:
//       [

//       ]

//       ),),

//       // Drawer
//       drawer: Drawer(
//         child: ListView(
//           padding: EdgeInsets.zero,
//           children: const [
//             DrawerHeader(
//               decoration: BoxDecoration(color: Colors.blue),
//               child: Text(
//                 "Profile",
//                 style: TextStyle(color: Colors.white, fontSize: 24),
//               ),
//             ),
//             ListTile(leading: Icon(Icons.person), title: Text("Profile")),
//             ListTile(leading: Icon(Icons.settings), title: Text("Settings")),
//             ListTile(leading: Icon(Icons.logout), title: Text("Logout")),
//           ],
//         ),
//       ),

//       body: _screens[_currentIndex],

//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _currentIndex,
//         onTap: (index) {
//           setState(() {
//             _currentIndex = index;
//           });
//         },
//         items: const [
//           BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
//           BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
//           BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
//         ],
//       ),
//     );
//   }
// }

import 'package:day5/screens/api_service.dart';
import 'package:day5/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ApiService _api = ApiService();
  late Future<List<String>> _categoriesFuture;
  late Future<List<dynamic>> _allProductsFuture;
  final Map<String, Future<List<dynamic>>> _categoryProductsFutures = {};

  @override
  void initState() {
    super.initState();
    _categoriesFuture = _api.getCategories();
    _allProductsFuture = _api.getAllProducts();
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (c) => const LoginPage()),
    );
  }

  Widget _productGrid(List<dynamic> products) {
    if (products.isEmpty) {
      return const Center(child: Text('No products'));
    }
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.72,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: products.length,
      itemBuilder: (context, i) {
        final p = products[i];
        final image =
            (p['thumbnail'] ??
                    (p['images'] != null && p['images'].isNotEmpty
                        ? p['images'][0]
                        : null))
                as String?;
        return Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: image != null
                    ? Image.network(image, fit: BoxFit.cover)
                    : Container(color: Colors.grey[300]),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  p['title'] ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 4,
                ),
                child: Text(
                  '\$${p['price']}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: _categoriesFuture,
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snap.hasError) {
          return Scaffold(body: Center(child: Text('Error: ${snap.error}')));
        }

        final categories = snap.data ?? [];
        final tabs = ['All Products', ...categories];

        return DefaultTabController(
          length: tabs.length,
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Products'),
              bottom: TabBar(
                isScrollable: true,
                tabs: tabs.map((t) => Tab(text: t)).toList(),
              ),
            ),
            drawer: Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  DrawerHeader(
                    decoration: const BoxDecoration(color: Colors.blue),
                    child: const Text(
                      'Menu',
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    ),
                  ),
                  const ListTile(
                    leading: Icon(Icons.person),
                    title: Text('Profile'),
                  ),
                  const ListTile(
                    leading: Icon(Icons.settings),
                    title: Text('Settings'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.logout),
                    title: const Text('Logout'),
                    onTap: _logout,
                  ),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                // All Products
                FutureBuilder<List<dynamic>>(
                  future: _allProductsFuture,
                  builder: (c, s) {
                    if (s.connectionState != ConnectionState.done) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (s.hasError)
                      return Center(child: Text('Error: ${s.error}'));
                    return _productGrid(s.data ?? []);
                  },
                ),
                // One FutureBuilder per category
                for (final cat in categories)
                  FutureBuilder<List<dynamic>>(
                    future: _categoryProductsFutures.putIfAbsent(
                      cat,
                      () => _api.getProductsByCategory(cat),
                    ),
                    builder: (c, s) {
                      if (s.connectionState != ConnectionState.done) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (s.hasError)
                        return Center(child: Text('Error: ${s.error}'));
                      return _productGrid(s.data ?? []);
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
