import 'package:flutter/material.dart';

class RequestsPage extends StatelessWidget {
  const RequestsPage({super.key});

  final List<Map<String, String>> doctors = const [
    {"name": "Dr. Emily Carter", "clinic": "Clinic A", "city": "New York", "photoUrl": "https://via.placeholder.com/150"},
    {"name": "Dr. David Lee", "clinic": "Clinic B", "city": "Los Angeles", "photoUrl": "https://via.placeholder.com/150"},
    {"name": "Dr. Sarah Jones", "clinic": "Clinic C", "city": "Chicago", "photoUrl": "https://via.placeholder.com/150"},
    {"name": "Dr. Michael Brown", "clinic": "Clinic D", "city": "Houston", "photoUrl": "https://via.placeholder.com/150"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Requests", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView.separated(
        itemCount: doctors.length,
        separatorBuilder: (_, __) => const Divider(height: 1, color: Colors.grey, thickness: 0.2),
        itemBuilder: (context, index) {
          final doctor = doctors[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DoctorProfilePage(doctor: doctor),
                ),
              );
            },
            child: ListTile(
              title: Text(
                doctor["name"]!,
                style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
              ),
              subtitle: Text(
                doctor["clinic"]!,
                style: const TextStyle(color: Colors.blue),
              ),
              trailing: const Icon(Icons.circle, color: Colors.green, size: 14),
            ),
          );
        },
      ),

      // Bottom Navigation

    );
  }
}

class DoctorProfilePage extends StatelessWidget {
  final Map<String, String> doctor;

  const DoctorProfilePage({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(doctor['name']!),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 40),
            Center(
              child: CircleAvatar(
                radius: 60,
                backgroundImage: NetworkImage(doctor['photoUrl']!),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Text(
                doctor['name']!,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.location_on, color: Colors.blue),
                      title: const Text('Request from'),
                      subtitle: Text(doctor['city']!),
                    ),
                    const Divider(height: 20, thickness: 1),
                    ListTile(
                      leading: const Icon(Icons.local_hospital, color: Colors.red),
                      title: const Text('Clinic/Hospital'),
                      subtitle: Text(doctor['clinic']!),
                    ),
                    // Add more profile details here as needed
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}