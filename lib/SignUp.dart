import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'main.dart'; // For WelcomeScreen

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool _agreeToTerms = false;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate() || !_agreeToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields & accept terms")),
      );
      return;
    }

    try {
      // Create user in Firebase Auth
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      User? user = userCredential.user;

      if (user != null) {
        // Save extra details in Firestore
        await _firestore.collection("users").doc(user.uid).set({
          "name": _nameController.text.trim(),
          "email": _emailController.text.trim(),
          "phone": _phoneController.text.trim(),
          "createdAt": FieldValue.serverTimestamp(),
        });

        // Navigate to Welcome Screen
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Account created successfully")),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => WelcomeScreen()),
        );
      }
    } on FirebaseAuthException catch (e) {
      String message = "Error occurred";
      if (e.code == "email-already-in-use") {
        message = "This email is already registered.";
      } else if (e.code == "weak-password") {
        message = "Password should be at least 6 characters.";
      }
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Something went wrong: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => WelcomeScreen()),
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  hintText: 'Enter your name',
                  filled: true,
                  fillColor: Color(0xFFE8F0FE),
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Name is required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  hintText: 'Enter an email',
                  filled: true,
                  fillColor: Color(0xFFE8F0FE),
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return 'Email is required';
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone',
                  hintText: 'Enter phone number',
                  filled: true,
                  fillColor: Color(0xFFE8F0FE),
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Phone number is required';
                  }
                  if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                    return 'Enter a valid 10-digit phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  hintText: 'Enter password',
                  filled: true,
                  fillColor: Color(0xFFE8F0FE),
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                ),
                obscureText: true,
                validator: (value) => value == null || value.length < 6
                    ? 'Password must be at least 6 characters'
                    : null,
              ),
              const SizedBox(height: 16),
              CheckboxListTile(
                title: const Text('I agree to Terms & Privacy'),
                value: _agreeToTerms,
                onChanged: (val) {
                  setState(() {
                    _agreeToTerms = val ?? false;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _signUp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Create account',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
