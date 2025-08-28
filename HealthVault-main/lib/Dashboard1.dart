import 'package:flutter/material.dart';

import 'AppFooter.dart';
import 'MyVault.dart';
import 'QR.dart';
import 'Requests.dart';
import 'Settings.dart';
import 'UploadDocument.dart';

class Dashboard1 extends StatefulWidget {
  final Map<String, dynamic> userData; // 👈 MongoDB se data aayega

  const Dashboard1({super.key, required this.userData});

  @override
  State<Dashboard1> createState() => _Dashboard1State();
}

class _Dashboard1State extends State<Dashboard1> {
  String appbarTitle = "Dashboard";
  int _currentIndex = 0;
  final tabs = ["Dashboard", "My Vault", "Qr", "Requests", "Settings"];
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 👇 userData se name nikaal lo (agar null ho to "Patient")
    final userName = widget.userData['name'] ?? "Patient";

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(appbarTitle, style: const TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            appbarTitle = tabs[index];
            _currentIndex = index;
          });
        },
        children: [
          // Home/Dashboard tab
          ListView(
            padding: const EdgeInsets.all(30.0),
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(
                        'https://cdn-icons-png.flaticon.com/512/9203/9203764.png'),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Hello, $userName 👋',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                'Quick Actions',
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFFE0E0E0),
                  child: Icon(Icons.qr_code, color: Colors.black),
                ),
                title: const Text('Generate QR'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => QRPage()),
                  );
                },
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFFE0E0E0),
                  child: Icon(Icons.share, color: Colors.black),
                ),
                title: const Text('Share QR'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => QRPage()),
                  );
                },
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFFE0E0E0),
                  child: Icon(Icons.list_alt, color: Colors.black),
                ),
                title: const Text('Access Requests'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RequestsPage()),
                  );
                },
              ),
              const SizedBox(height: 24),
              const Text(
                'My Documents',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.2,
                children: [
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 80,
                          width: double.infinity,
                          child: Image.asset("assets/Reports.png", fit: BoxFit.contain),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Reports',
                          style: TextStyle(color: Colors.blueGrey),
                        ),
                      ],
                    ),
                  ),
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 80,
                          width: double.infinity,
                          child: Image.asset("assets/Prescription.png", fit: BoxFit.contain),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Prescriptions',
                          style: TextStyle(color: Colors.blueGrey),
                        ),
                      ],
                    ),
                  ),
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 80,
                          width: double.infinity,
                          child: Image.asset("assets/2851468.png", fit: BoxFit.contain),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Insurance Details',
                          style: TextStyle(color: Colors.blueGrey),
                        ),
                      ],
                    ),
                  ),
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 80,
                          width: double.infinity,
                          child: Image.asset("assets/Insurance12.png", fit: BoxFit.contain),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Insurance Details',
                          style: TextStyle(color: Colors.blueGrey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                'Recent Activity',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ListTile(
                leading: const Icon(Icons.description, color: Colors.grey),
                title: const Text('Uploaded Report'),
                subtitle: const Text('10/29/23, 10:30 AM'),
                contentPadding: EdgeInsets.zero,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => QRPage()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.description, color: Colors.grey),
                title: const Text('Uploaded Prescription'),
                subtitle: const Text('10/29/23, 2:15 PM'),
                contentPadding: EdgeInsets.zero,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => QRPage()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.description, color: Colors.grey),
                title: const Text('Uploaded Bill'),
                subtitle: const Text('10/29/23, 9:45 AM'),
                contentPadding: EdgeInsets.zero,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => QRPage()),
                  );
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UploadDocument()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text(
                  '+ Upload Document',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ],
          ),
          // Vault tab
          MyVault(),

          // QR tab
          QRPage(),

          // Requests tab
          RequestsPage(),

          // Settings tab
          SettingsPage(),
        ],
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
              _pageController.animateToPage(
                index,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.lock),
                label: 'Vault',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.qr_code),
                label: 'QR',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.list_alt),
                label: 'Requests',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: 'Settings',
              ),
            ],
            selectedItemColor: Colors.blue,
            unselectedItemColor: Colors.grey,
          ),
          const AppFooter(), // 👈 Footer added here
        ],
      ),
    );
  }
}
