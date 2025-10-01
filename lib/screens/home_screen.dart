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

import 'package:day5/provider/product_provider.dart';
import 'package:day5/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: const Text(
          'Home',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        elevation: 5,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              final SharedPreferences prefs =
                  await SharedPreferences.getInstance();

              prefs.clear();
              // TODO: Implement logout logic
              // Navigator.of(context).pushReplacementNamed('/login');
            },
          ),
        ],
      ),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome to Your App! ${userProvider.userModel?.username}',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(12),
                  ),
                  elevation: 4,
                  margin: EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    leading: const Icon(Icons.person),
                    title: const Text(
                      'Profile',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: const Text('View and edit your profile'),
                    trailing: Icon(
                      Icons.arrow_back_ios,
                      size: 16,
                      color: Colors.grey,
                    ),
                    onTap: () {
                      // TODO: Navigate to profile screen
                      // userProvider.updateUsername();
                    },
                  ),
                ),
                // Card(
                //   child: ListTile(
                //     leading: const Icon(Icons.settings),
                //     title: const Text('Settings'),
                //     subtitle: const Text('App preferences and settings'),
                //     onTap: () {
                //       // TODO: Navigate to settings screen
                //     },
                //   ),
                // ),
                const SizedBox(height: 20),
                const Text(
                  'Recent Activity',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
                Expanded(
                  child: productProvider.isLoding
                      ? Center(child: CircularProgressIndicator())
                      : ListView.builder(
                          itemCount:
                              productProvider.list.length, // Example count
                          itemBuilder: (context, index) {
                            return Card(
                              color: Colors.pinkAccent,
                              child: ListTile(
                                title: Text(
                                  '${productProvider.list[index].title}',
                                  style: TextStyle(color: Colors.white),
                                ),
                                subtitle: Text(
                                  '${productProvider.list[index].description}',
                                ),
                                trailing: const Icon(Icons.arrow_forward_ios),
                                onTap: () {
                                  // TODO: Handle item tap
                                },
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Add new item
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
