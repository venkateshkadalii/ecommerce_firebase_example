
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ecommerce_firebase/ui/home_screen.dart';
import 'package:flutter_ecommerce_firebase/ui/user_details_screen.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  bool isCodeSent = false;
  bool isLoading =false;
  bool isOtpLoading = false;
  String mVerificationId = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Stack(
        children: <Widget>[
          Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/image1.png'),
                    fit: BoxFit.fitWidth,
                    alignment: Alignment.topCenter
                )
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.only(top: 270),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            child: Padding(
              padding: const EdgeInsets.all(23),
              child: ListView(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                    child: Container(
                      color: const Color(0xfff5f5f5),
                      child: TextFormField(
                        enabled: isCodeSent ? false : true,
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        style: const TextStyle(
                            color: Colors.black
                        ),
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Phone Number',
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
                      onPressed: () {
                        if(!isCodeSent) {
                          if (_phoneController.text.isNotEmpty) {
                            setState(() {
                              isLoading = true;
                            });
                            verifyPhoneNumber();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Phone number required!"),),);
                          }
                        }
                      },
                      color: isCodeSent ? Colors.grey : const Color(0xffff2d55),
                      elevation: 0,
                      minWidth: 400,
                      height: 50,
                      textColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)
                      ),//since this is only a UI app
                      child: isLoading ? const CircularProgressIndicator(color: Colors.white,) : const Text('VERIFY',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  isCodeSent ?
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                    child: Container(
                      color: const Color(0xfff5f5f5),
                      child: TextFormField(
                        controller: _otpController,
                        keyboardType: TextInputType.phone,
                        style: const TextStyle(
                            color: Colors.black
                        ),
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Enter OTP',
                            prefixIcon: Icon(Icons.phone),
                            labelStyle: TextStyle(
                                fontSize: 15
                            )
                        ),
                      ),
                    ),
                  ) : Container(),
                  isCodeSent ?
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: MaterialButton(
                      onPressed: () async {
                        if(_otpController.text.isNotEmpty && _otpController.text.length == 6) {
                          setState(() {
                            isOtpLoading = true;
                          });
                          PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: mVerificationId, smsCode: _otpController.text);
                          await _auth.signInWithCredential(credential).then((value) {
                            setState(() {
                              isOtpLoading = false;
                            });
                            if(value.additionalUserInfo!.isNewUser) {
                              Navigator.push(context, MaterialPageRoute(
                                  builder: (context) =>
                                      UserDetailsScreen(userId: value.user!.uid,
                                        phoneNumber: _phoneController.text,)));
                            } else {
                              Navigator.pushReplacement(context, MaterialPageRoute(
                                  builder: (context) =>
                                      const HomeScreen()));
                            }
                          });

                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please enter OTP")));
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
                      child: isOtpLoading ? const CircularProgressIndicator(color: Colors.white,) : const Text('Login',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )  : Container(),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  verifyPhoneNumber() async {
    await _auth.verifyPhoneNumber(
        phoneNumber: "+91${_phoneController.text}",
        verificationCompleted: (PhoneAuthCredential credential){
          print("=========> verificationCompleted");
        },
        verificationFailed: (FirebaseAuthException ex){
          print("==========> verificationFailed");
        },
        codeSent: (String verificationId, int? resendToken) async {
          setState(() {
            isLoading = false;
            isCodeSent = true;
            mVerificationId = verificationId;
          });
        },
        codeAutoRetrievalTimeout: (String verificationId){
          print("===========> codeAutoRetrievalTimeout");
        },
    );
  }
}