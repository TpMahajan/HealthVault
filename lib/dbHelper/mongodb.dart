import 'package:mongo_dart/mongo_dart.dart';
import 'constant.dart';

class MongoDataBase {
  static var db, userCollection;

  static connect() async {
    db = await Db.create(MONGO_URL);
    await db.open();
    userCollection = db.collection(COLLECTION_NAME);
  }

  // 👇 Signup function with 4 fields
  static Future<void> signupUser(
      String name, String email, String phone, String password) async {
    var result = await userCollection.insertOne({
      "_id": ObjectId(), // MongoDB will generate unique ID
      "name": name,
      "email": email,
      "phone": phone,
      "password": password,
    });

    if (result.isSuccess) {
      print("✅ User inserted successfully");
    } else {
      print("❌ Failed to insert user");
    }
  }

// 👇 Login function (with trim & lowercase handling)
  static Future<bool> loginUser(String email, String password) async {
    final user = await userCollection.findOne({
      "email": email.trim().toLowerCase(),
      "password": password.trim(),
    });

    return user != null;
  }
}
