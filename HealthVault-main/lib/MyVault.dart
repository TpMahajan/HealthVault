import 'package:flutter/material.dart';
import 'UploadDocument.dart';

// Document Detail Page
class DocumentDetailPage extends StatelessWidget {
  final String title;
  final String type;
  final String date;

  const DocumentDetailPage({
    super.key,
    required this.title,
    required this.type,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Type: $type", style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text("Uploaded on: $date", style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            const Text("Here you can show the document preview or details.",
                style: TextStyle(fontSize: 14, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}

class Document {
  final String type;
  final String title;
  final String date;
  final String image; // Asset image

  Document({
    required this.type,
    required this.title,
    required this.date,
    required this.image,
  });
}

class MyVault extends StatefulWidget {
  const MyVault({super.key});

  @override
  State<MyVault> createState() => _MyVaultState();
}

class _MyVaultState extends State<MyVault> {
  final TextEditingController _searchController = TextEditingController();
  String _sortBy = 'Date'; // Default sort
  List<Document> _allDocuments = [
    Document(
      type: 'Report',
      title: 'Blood Test Results',
      date: '2024-01-15',
      image: 'assets/BloodReport.png',
    ),
    Document(
      type: 'Prescription',
      title: 'Medication for Allergies',
      date: '2023-12-20',
      image: 'assets/Prescription.png',
    ),
    Document(
      type: 'Bill',
      title: 'Hospital Bill - Consultation',
      date: '2023-11-05',
      image: 'assets/HospitalBill.png',
    ),
  ];
  late List<Document> _displayedDocuments;

  @override
  void initState() {
    super.initState();
    _displayedDocuments = List.from(_allDocuments);
    _sortDocuments();
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
      _sortDocuments();
    });
  }

  void _sortDocuments() {
    setState(() {
      if (_sortBy == 'Date') {
        _displayedDocuments.sort((a, b) => a.date.compareTo(b.date));
      } else if (_sortBy == 'Category') {
        _displayedDocuments.sort((a, b) => a.type.compareTo(b.type));
      } else if (_sortBy == 'Title') {
        _displayedDocuments.sort((a, b) => a.title.compareTo(b.title));
      } else if (_sortBy == 'Size') {
        // Placeholder (add file size property later)
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
          // Search bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
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
          const SizedBox(height: 8),

          // Filter chips
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 16.0),
          //   child: SingleChildScrollView(
          //     scrollDirection: Axis.horizontal,
          //     child: Row(
          //       children: const [
          //         Chip(label: Text('All'), backgroundColor: Color(0xFFE8F0FE)),
          //         SizedBox(width: 8),
          //         Chip(label: Text('Reports'), backgroundColor: Color(0xFFE8F0FE)),
          //         SizedBox(width: 8),
          //         Chip(label: Text('Prescriptions'), backgroundColor: Color(0xFFE8F0FE)),
          //         SizedBox(width: 8),
          //         Chip(label: Text('Bills'), backgroundColor: Color(0xFFE8F0FE)),
          //       ],
          //     ),
          //   ),
          // ),

          const SizedBox(height: 12),

          // Sort by dropdown aligned left
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: DropdownButton<String>(
                value: _sortBy,
                underline: const SizedBox(),
                items: ['Date', 'Category', 'Title', 'Size'].map((String value) {
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
          ),

          const SizedBox(height: 12),

          // Document list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemCount: _displayedDocuments.length,
              itemBuilder: (context, index) {
                final doc = _displayedDocuments[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DocumentDetailPage(
                          title: doc.title,
                          type: doc.type,
                          date: doc.date,
                        ),
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Texts
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(doc.type, style: const TextStyle(color: Colors.blue, fontSize: 12)),
                              Text(doc.title,
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                              Text('Uploaded on ${doc.date}',
                                  style: const TextStyle(color: Colors.grey, fontSize: 12)),
                            ],
                          ),
                          // Image asset instead of icon
                          Container(
                            width: 80,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Image.asset(doc.image, fit: BoxFit.contain),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                );
              },
            ),
          ),

          // Upload Button
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
