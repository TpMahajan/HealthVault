import 'package:flutter/material.dart';

import 'UploadDocument.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Vault',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const MyVault(),
    );
  }
}

class Document {
  final String type;
  final String title;
  final String date;
  final IconData icon;
  final Color iconColor;
  final Color bgColor;

  Document({
    required this.type,
    required this.title,
    required this.date,
    required this.icon,
    required this.iconColor,
    required this.bgColor,
  });
}

class MyVault extends StatefulWidget {
  const MyVault({super.key});

  @override
  State<MyVault> createState() => _MyVaultState();
}

class _MyVaultState extends State<MyVault> {
  final TextEditingController _searchController = TextEditingController();
  String _sortBy = 'Date'; // Default sort by Date
  List<Document> _allDocuments = [
    Document(
      type: 'Report',
      title: 'Blood Test Results',
      date: '2024-01-15',
      icon: Icons.description,
      iconColor: Colors.red,
      bgColor: Colors.grey[200]!,
    ),
    Document(
      type: 'Prescription',
      title: 'Medication for Allergies',
      date: '2023-12-20',
      icon: Icons.playlist_add_check,
      iconColor: Colors.white,
      bgColor: Colors.blueGrey[800]!,
    ),
    Document(
      type: 'Bill',
      title: 'Hospital Bill - Consultation',
      date: '2023-11-05',
      icon: Icons.attach_money,
      iconColor: Colors.green,
      bgColor: Colors.teal[100]!,
    ),
    // Add more documents here if needed
  ];
  late List<Document> _displayedDocuments;

  @override
  void initState() {
    super.initState();
    _displayedDocuments = List.from(_allDocuments);
    _sortDocuments(); // Initial sort
    _searchController.addListener(() {
      _filterDocuments(_searchController.text);
    });
  }

  void _filterDocuments(String query) {
    setState(() {
      _displayedDocuments = _allDocuments.where((doc) {
        final lowerQuery = query.toLowerCase();
        return doc.title.toLowerCase().contains(lowerQuery) ||
            doc.type.toLowerCase().contains(lowerQuery);
      }).toList();
      _sortDocuments(); // Re-sort after filtering
    });
  }

  void _sortDocuments() {
    setState(() {
      if (_sortBy == 'Date') {
        _displayedDocuments.sort((a, b) => a.date.compareTo(b.date));
      } else if (_sortBy == 'Category') {
        _displayedDocuments.sort((a, b) => a.type.compareTo(b.type));
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: const Icon(Icons.search),
                fillColor: const Color(0xFFE8F0FE),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Chip(
                    label: const Text('All'),
                    backgroundColor: const Color(0xFFE8F0FE),
                  ),
                  const SizedBox(width: 8),
                  Chip(
                    label: const Text('Reports'),
                    backgroundColor: const Color(0xFFE8F0FE),
                  ),
                  const SizedBox(width: 8),
                  Chip(
                    label: const Text('Prescriptions'),
                    backgroundColor: const Color(0xFFE8F0FE),
                  ),
                  const SizedBox(width: 8),
                  Chip(
                    label: const Text('Bills'),
                    backgroundColor: const Color(0xFFE8F0FE),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: DropdownButton<String>(
              value: _sortBy,
              icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
              underline: const SizedBox(), // Remove underline
              items: ['Date', 'Category'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    'Sort by $value',
                    style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _sortBy = newValue;
                    _sortDocuments();
                  });
                }
              },
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              children: _displayedDocuments.map((doc) {
                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              doc.type,
                              style: const TextStyle(color: Colors.blue, fontSize: 12),
                            ),
                            Text(
                              doc.title,
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Uploaded on ${doc.date}',
                              style: const TextStyle(color: Colors.grey, fontSize: 12),
                            ),
                          ],
                        ),
                        Container(
                          width: 80,
                          height: 60,
                          decoration: BoxDecoration(
                            color: doc.bgColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            doc.icon,
                            color: doc.iconColor,
                            size: 40,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                );
              }).toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UploadDocument()),
                );
              },
              icon: const Icon(Icons.upload),
              label: const Text('Upload Document'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}