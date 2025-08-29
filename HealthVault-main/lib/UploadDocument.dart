import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'document_model.dart';
import 'MyVault.dart';

class UploadDocument extends StatefulWidget {
  const UploadDocument({super.key});

  @override
  State<UploadDocument> createState() => _UploadDocumentState();
}

class _UploadDocumentState extends State<UploadDocument> {
  final _titleController = TextEditingController();
  final _notesController = TextEditingController();
  String? _selectedCategory;
  DateTime _selectedDate = DateTime.now();
  File? _selectedFile;

  // pick file
  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      File file = File(result.files.single.path!);
      setState(() {
        _selectedFile = file;
        _titleController.text = result.files.single.name;
      });
    }
  }

  // save document → MyVault
  void _saveDocument() {
    if (_selectedFile == null || _selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select file & category")),
      );
      return;
    }

    final newDoc = Document(
      type: _selectedCategory!,
      title: _titleController.text.isNotEmpty
          ? _titleController.text
          : _selectedFile!.path.split('/').last,
      date: DateFormat('yyyy-MM-dd').format(DateTime.now()), // ✅ today’s date
      path: _selectedFile!.path,
    );

    MyVault.addDocument(newDoc);
    Navigator.pop(context);
  }

  // pick date (optional override)
  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Upload Document"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: "Document Title",
                prefixIcon: const Icon(Icons.title),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Category
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              items: ["Bills", "Prescription", "Reports"].map((cat) {
                return DropdownMenuItem(value: cat, child: Text(cat));
              }).toList(),
              onChanged: (val) => setState(() => _selectedCategory = val),
              decoration: InputDecoration(
                labelText: "Category",
                prefixIcon: const Icon(Icons.category),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Date (pre-filled as today)
            GestureDetector(
              onTap: _pickDate,
              child: AbsorbPointer(
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: "Date",
                    prefixIcon: const Icon(Icons.calendar_today),
                    hintText: DateFormat('yyyy-MM-dd').format(DateTime.now()), // ✅ always today
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Notes
            TextField(
              controller: _notesController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: "Notes (optional)",
                alignLabelWithHint: true,
                prefixIcon: const Icon(Icons.notes),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // File Preview
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.attach_file, color: Colors.blue),
                  onPressed: _pickFile,
                ),
                Expanded(
                  child: Text(
                    _selectedFile != null
                        ? _selectedFile!.path.split('/').last
                        : "No file selected",
                    style: const TextStyle(
                      color: Colors.black87,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),

            // Save button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _saveDocument,
                icon: const Icon(Icons.save),
                label: const Text("Save Document"),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  textStyle: const TextStyle(fontSize: 16),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
