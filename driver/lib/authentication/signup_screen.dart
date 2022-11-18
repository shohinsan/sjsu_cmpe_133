import 'package:driver/authentication/car_info_screen.dart';
import 'package:driver/authentication/login_screen.dart';
import 'package:driver/global/global.dart';
import 'package:driver/widgets/progress_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../global/global.dart';
import '../widgets/progress_dialog.dart';
import 'car_info_screen.dart';
import 'login_screen.dart';


class SignUpScreen extends StatefulWidget
{
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}



class _SignUpScreenState extends State<SignUpScreen>
{
  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController phoneTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();


  validateForm()
  {
    if(nameTextEditingController.text.length < 3)
    {
      Fluttertoast.showToast(msg: "name must be atleast 3 Characters.");
    }
    else if(!emailTextEditingController.text.contains("@"))
    {
      Fluttertoast.showToast(msg: "Email address is not Valid.");
    }
    else if(phoneTextEditingController.text.isEmpty)
    {
      Fluttertoast.showToast(msg: "Phone Number is required.");
    }
    else if(passwordTextEditingController.text.length < 6)
    {
      Fluttertoast.showToast(msg: "Password must be atleast 6 Characters.");
    }
    else
    {
      saveDriverInfoNow();
    }
  }

  saveDriverInfoNow() async
  {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext c)
        {
          return ProgressDialog(message: "Processing, Please wait...",);
        }
    );

    final User? firebaseUser = (
      await fAuth.createUserWithEmailAndPassword(
        email: emailTextEditingController.text.trim(),
        password: passwordTextEditingController.text.trim(),
      ).catchError((msg){
        Navigator.pop(context);
        Fluttertoast.showToast(msg: "Error: " + msg.toString());
      })
    ).user;

    if(firebaseUser != null)
    {
      Map driverMap =
      {
        "id": firebaseUser.uid,
        "name": nameTextEditingController.text.trim(),
        "email": emailTextEditingController.text.trim(),
        "phone": phoneTextEditingController.text.trim(),
      };

      DatabaseReference driversRef = FirebaseDatabase.instance.ref().child("drivers");
      driversRef.child(firebaseUser.uid).set(driverMap);

      currentFirebaseUser = firebaseUser;
      Fluttertoast.showToast(msg: "Account has been Created.");
      Navigator.push(context, MaterialPageRoute(builder: (c)=> CarInfoScreen()));
    }
    else
    {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "Account has not been Created.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff095d61),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [

              const SizedBox(height: 10,),

              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Image.asset("images/logo-large.png"),
              ),

              const SizedBox(height: 10,),

              const Text(
                "Register as a Driver",
                style: TextStyle(
                  fontSize: 26,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20,),


              TextField(
                controller: nameTextEditingController,
                style: const TextStyle(
                    color: Colors.white
                ),
                decoration: const InputDecoration(
                  labelText: "Name",
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  hintStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                  ),
                  labelStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ),

              const SizedBox(height: 20,),


              TextField(
                controller: emailTextEditingController,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(
                    color: Colors.white
                ),
                decoration: const InputDecoration(
                  labelText: "Email",
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  hintStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                  ),
                  labelStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ),

              const SizedBox(height: 20,),


              TextField(
                controller: phoneTextEditingController,
                keyboardType: TextInputType.phone,
                style: const TextStyle(
                    color: Colors.white
                ),
                decoration: const InputDecoration(
                  labelText: "Phone",
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  hintStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                  ),
                  labelStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ),

              const SizedBox(height: 20,),


              TextField(
                controller: passwordTextEditingController,
                keyboardType: TextInputType.text,
                obscureText: true,
                style: const TextStyle(
                    color: Colors.white
                ),
                decoration: const InputDecoration(
                  labelText: "Password",
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  hintStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                  ),
                  labelStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ),

              const SizedBox(height: 20,),

              ElevatedButton(
                onPressed: ()
                {
                  validateForm();
                },
                style: ElevatedButton.styleFrom(
                  primary: const Color(0xFF4FBDB6),
                  minimumSize: const Size.fromHeight(50),
                ),

                child: const Text(
                  "Create Account",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),

              const SizedBox(height: 20,),


              TextButton(
                child: const Text(
                  "Already have an Account? Login Here",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: ()
                {
                  Navigator.push(context, MaterialPageRoute(builder: (c)=> LoginScreen()));
                },
              ),

            ],
          ),
        ),
      ),
    );
  }
}
