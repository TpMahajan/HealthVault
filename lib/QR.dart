import 'package:flutter/material.dart';

class QRPage extends StatelessWidget {
  const QRPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("QR Code", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          // QR Image Container
          Center(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.orange[100],
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(16),
              child: Image.network(
                "https://api.qrserver.com/v1/create-qr-code/?size=150x150&data=DoctorAccess",
                height: 200,
                width: 200,
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            "Doctor will scan to request access",
            style: TextStyle(fontSize: 14, color: Colors.black),
          ),
          const SizedBox(height: 20),

          // Buttons Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Share QR logic here
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text("Share QR" , style: TextStyle(color: Colors.white)),

                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      // Regenerate QR logic
                    },
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      side: const BorderSide(color: Colors.blue),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text("Regenerate QR", style: TextStyle(color: Colors.blue)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // "How QR access works?"
          GestureDetector(
            onTap: () {
              // Navigate to help page
            },
            child: const Text(
              "How QR access works?",
              style: TextStyle(
                fontSize: 14,
                color: Colors.blue,
                decoration: TextDecoration.underline,
              ),
            ),
          ),

          const Spacer(),
        ],
      ),


    );
  }
}
