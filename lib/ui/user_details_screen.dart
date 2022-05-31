import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'home_screen.dart';

class UserDetailsScreen extends StatefulWidget {
  UserDetailsScreen({Key? key, required this.userId, required this.phoneNumber}) : super(key: key);
  final String userId;
  final String phoneNumber;

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _addressController = TextEditingController();

  bool isLoading =false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                child: Container(
                  color: const Color(0xfff5f5f5),
                  child: TextFormField(
                    controller: _nameController,
                    keyboardType: TextInputType.text,
                    style: const TextStyle(
                        color: Colors.black
                    ),
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Name',
                        prefixIcon: Icon(Icons.phone),
                        labelStyle: TextStyle(
                            fontSize: 15
                        )
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                child: Container(
                  color: const Color(0xfff5f5f5),
                  child: TextFormField(
                    controller: _addressController,
                    keyboardType: TextInputType.text,
                    style: const TextStyle(
                        color: Colors.black
                    ),
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Address',
                        prefixIcon: Icon(Icons.phone),
                        labelStyle: TextStyle(
                            fontSize: 15
                        )
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: MaterialButton(
                  onPressed: () async {
                    if(_nameController.text.isNotEmpty && _addressController.text.isNotEmpty) {
                      setState(() {
                        isLoading = true;
                      });
                      CollectionReference users = FirebaseFirestore.instance
                          .collection("users");

                      await users.doc(widget.userId).set({
                        "full_name": _nameController.text,
                        "phone": widget.phoneNumber,
                        "address": _addressController.text
                      }).then((value) {
                        setState(() {
                          isLoading = false;
                        });
                        Navigator.pushReplacement(context, MaterialPageRoute(
                            builder: (context) =>
                            const HomeScreen()));
                      }).catchError((
                          error) {
                        setState(() {
                          isLoading = false;
                        });
                        print("user add failed");});
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please fill required fields")));
                    }
                    },
                  color: const Color(0xffff2d55),
                  elevation: 0,
                  minWidth: 400,
                  height: 50,
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)
                  ),//since this is only a UI app
                  child: isLoading ? const CircularProgressIndicator(color: Colors.white,) : const Text('CONTINUE',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
