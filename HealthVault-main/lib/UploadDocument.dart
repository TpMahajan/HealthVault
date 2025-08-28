import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:hello/Dashboard1.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:open_file/open_file.dart';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart'; // 👈 new import

import 'dbHelper/mongodb.dart';

class UploadDocument extends StatefulWidget {
  const UploadDocument({super.key});

  @override
  State<UploadDocument> createState() => _UploadDocumentState();
}

class _UploadDocumentState extends State<UploadDocument> {
  List<Map<String, dynamic>> uploadedDocs = [];
  final String userEmail = "testuser@gmail.com"; // TODO: replace after login

  // 📸 Camera se capture
  Future<void> _scanFromCamera() async {
    final ImagePicker picker = ImagePicker();
    final XFile? photo = await picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      File file = File(photo.path);
      String extension = file.path.split(".").last;

      // ✅ save to MongoDB
      await MongoDataBase.uploadDocument(
        userEmail,
        p.basename(file.path),
        extension,
        await file.readAsBytes(),
      );

      setState(() {
        uploadedDocs.add({
          "name": "Captured_${uploadedDocs.length + 1}.$extension",
          "file": file,
        });
      });
    }
  }

  // 📂 Files/Photos se pick
  Future<void> _pickFromFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      File file = File(result.files.single.path!);
      String extension = file.path.split(".").last;

      // ✅ save to MongoDB
      await MongoDataBase.uploadDocument(
        userEmail,
        result.files.single.name,
        extension,
        await file.readAsBytes(),
      );

      setState(() {
        uploadedDocs.add({
          "name": result.files.single.name,
          "file": file,
        });
      });
    }
  }

  // 👁 Preview screen
  void _previewDocument(File file) {
    final extension = file.path.split(".").last.toLowerCase();

    if (["jpg", "jpeg", "png"].contains(extension)) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(title: const Text("Image Preview")),
            body: Center(child: Image.file(file)),
          ),
        ),
      );
    } else if (extension == "pdf") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(title: const Text("PDF Preview")),
            body: SfPdfViewer.file(file), // 👈 syncfusion viewer
          ),
        ),
      );
    } else {
      OpenFile.open(file.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Dashboard1(userData: {}),
              ),
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

            // Scan from Camera
            GestureDetector(
              onTap: _scanFromCamera,
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Scan from Camera',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        SizedBox(height: 4),
                        Text('Scan your document',
                            style: TextStyle(fontSize: 16)),
                        SizedBox(height: 4),
                        Text('Use your camera to scan your document',
                            style:
                            TextStyle(fontSize: 14, color: Colors.grey)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Color(0xFFE0F7FA),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        "assets/PickFromCamera.png", // 👈 camera asset
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Pick from Files/Photos
            GestureDetector(
              onTap: _pickFromFiles,
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Pick from Files/Photos',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        SizedBox(height: 4),
                        Text('Upload from your device',
                            style: TextStyle(fontSize: 16)),
                        SizedBox(height: 4),
                        Text('Select a file or photo from your device',
                            style:
                            TextStyle(fontSize: 14, color: Colors.grey)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Color(0xFF4CAF50).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        "assets/UploadDocument.png", // 👈 file upload asset
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Uploaded documents list
            Expanded(
              child: uploadedDocs.isEmpty
                  ? const Center(
                child: Text("No documents uploaded yet"),
              )
                  : ListView.builder(
                itemCount: uploadedDocs.length,
                itemBuilder: (context, index) {
                  final doc = uploadedDocs[index];
                  final file = doc["file"] as File;
                  final fileName = doc["name"];
                  final fileExtension = fileName.split(".").last;

                  return ListTile(
                    leading: const Icon(Icons.insert_drive_file),
                    title: Text(fileName),
                    subtitle: Text("Type: $fileExtension"),
                    trailing: IconButton(
                      icon: const Icon(Icons.remove_red_eye,
                          color: Colors.blue),
                      onPressed: () => _previewDocument(file),
                    ),
                  );
                },
              ),
            ),

            // Continue Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Dashboard1(userData: {})),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 17),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
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
