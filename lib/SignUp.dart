import 'package:flutter/material.dart';

import 'dbHelper/mongodb.dart';
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
                onPressed: () async {
                  if (_formKey.currentState!.validate() && _agreeToTerms) {
                    try {
                      await MongoDataBase.signupUser(
                        _nameController.text.trim(),
                        _emailController.text.trim(),
                        _phoneController.text.trim(),
                        _passwordController.text.trim(),
                      );

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("✅ Account created successfully")),
                      );

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => WelcomeScreen()),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("❌ Error: $e")),
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("Please fill all fields & accept Terms")),
                    );
                  }
                },
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

