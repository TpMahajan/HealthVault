import 'package:flutter/material.dart';
import 'package:hello/Dashboard1.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Upload Document',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFFF9FAFC),
      ),
      home: const UploadDocument(),
    );
  }
}

class UploadDocument extends StatefulWidget {
  const UploadDocument({super.key});

  @override
  State<UploadDocument> createState() => _UploadDocumentState();
}

class _UploadDocumentState extends State<UploadDocument> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Dashboard1(userData: {},)),
            );
          },
        ),
        title: const Text('Upload'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'How would you like to upload?',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),

            // Scan from Camera (Clickable)
            GestureDetector(
              onTap: () async {
                final ImagePicker picker = ImagePicker();
                final XFile? photo = await picker.pickImage(source: ImageSource.camera);
                if (photo != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Photo taken: ${photo.path}')),
                  );
                  // TODO: Add upload or further handling logic here
                }
              },
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Scan from Camera',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Scan your document',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Use your camera to scan your document',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Color(0xFFE0F7FA),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Placeholder(
                      color: Colors.teal,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Pick from Files/Photos (Clickable)
            GestureDetector(
              onTap: () async {
                FilePickerResult? result = await FilePicker.platform.pickFiles(
                  type: FileType.any,
                );
                if (result != null) {
                  PlatformFile file = result.files.first;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('File picked: ${file.name}')),
                  );
                  // TODO: Add upload or further handling logic here
                }
              },
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Pick from Files/Photos',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Upload from your device',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Select a file or photo from your device',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: const Color(0xFF4CAF50).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Placeholder(
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),

            // Continue Button (Already present - just make it clickable)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Dashboard1(userData: {},)),
                  );
                  // TODO: Handle continue logic, e.g., upload selected file if any
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Continue',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}