import 'dart:typed_data';
import 'dart:io';
import 'package:mongo_dart/mongo_dart.dart';
import 'constant.dart';

class MongoDataBase {
  static late Db db;
  static late DbCollection userCollection;
  static late DbCollection docCollection;

  static Future<void> connect() async {
    try {
      db = await Db.create(MONGO_URL);
      await db.open();
      userCollection = db.collection(COLLECTION_NAME);
      docCollection = db.collection(DOC_COLLECTION);
      print("✅ MongoDB Connected");
    } catch (e) {
      print("❌ MongoDB connection failed: $e");
    }
  }

  // Signup
  static Future<void> signupUser(
      String name, String email, String phone, String password) async {
    try {
      var result = await userCollection.insertOne({
        "_id": ObjectId(),
        "name": name,
        "email": email.trim().toLowerCase(),
        "phone": phone,
        "password": password,
      });

      print(result.isSuccess
          ? "✅ User inserted successfully"
          : "❌ Failed to insert user");
    } catch (e) {
      print("❌ Error in signup: $e");
    }
  }

  // Login
  static Future<bool> loginUser(String email, String password) async {
    try {
      final user = await userCollection.findOne({
        "email": email.trim().toLowerCase(),
        "password": password.trim(),
      });
      return user != null;
    } catch (e) {
      print("❌ Error in login: $e");
      return false;
    }
  }

  // ✅ Upload Document
  static Future<void> uploadDocument(
      String userEmail, String fileName, String fileType, Uint8List fileBytes) async {
    try {
      var result = await docCollection.insertOne({
        "_id": ObjectId(),
        "email": userEmail,
        "fileName": fileName,
        "fileType": fileType,
        "fileBytes": fileBytes.toList(), // stored as List<int>
        "uploadedAt": DateTime.now().toUtc(),
      });

      print(result.isSuccess
          ? "✅ Document uploaded"
          : "❌ Document upload failed");
    } catch (e) {
      print("❌ Error uploading document: $e");
    }
  }

  // ✅ Get Documents
  static Future<List<Map<String, dynamic>>> getUserDocuments(String email) async {
    try {
      final docs = await docCollection.find({"email": email}).toList();

      print("📂 Found ${docs.length} documents for $email");

      // clean map for flutter (remove _id ObjectId format)
      return docs.map((doc) {
        return {
          "fileName": doc["fileName"],
          "fileType": doc["fileType"],
          "fileBytes": doc["fileBytes"],
          "uploadedAt": doc["uploadedAt"].toString(),
        };
      }).toList();
    } catch (e) {
      print("❌ Error fetching documents: $e");
      return [];
    }
  }

  // ✅ Download Document
  static Future<void> downloadDocument(
      Map<String, dynamic> document, String savePath) async {
    try {
      final fileBytes = document["fileBytes"] != null
          ? List<int>.from(document["fileBytes"])
          : null;

      if (fileBytes == null) {
        print("❌ No file data found");
        return;
      }

      File file = File(savePath);
      await file.writeAsBytes(fileBytes);

      print("✅ File saved at $savePath");
    } catch (e) {
      print("❌ Error saving file: $e");
    }
  }
}
