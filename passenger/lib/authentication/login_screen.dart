import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:passenger/authentication/signup_screen.dart';
import 'package:passenger/global/global.dart';
import 'package:passenger/splash/splash_screen.dart';
import 'package:passenger/widgets/progress_dialog.dart';


class LoginScreen extends StatefulWidget
{
  const LoginScreen({Key? key}) : super(key: key);


  @override
  // ignore: library_private_types_in_public_api
  _LoginScreenState createState() => _LoginScreenState();
}




class _LoginScreenState extends State<LoginScreen>
{
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();


  validateForm()
  {
    if(!emailTextEditingController.text.contains("@"))
    {
      Fluttertoast.showToast(msg: "Email address is not Valid.");
    }
    else if(passwordTextEditingController.text.isEmpty)
    {
      Fluttertoast.showToast(msg: "Password is required.");
    }
    else
    {
      loginUserNow();
    }
  }

  loginUserNow() async
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
        await fAuth.signInWithEmailAndPassword(
          email: emailTextEditingController.text.trim(),
          password: passwordTextEditingController.text.trim(),
        ).catchError((msg){
          Navigator.pop(context);
          Fluttertoast.showToast(msg: "Error: $msg");
        })
    ).user;

    if(firebaseUser != null)
    {
      DatabaseReference driversRef = FirebaseDatabase.instance.ref().child("users");
      driversRef.child(firebaseUser.uid).once().then((driverKey) {
        final snap = driverKey.snapshot;
        if (snap.value != null) {
          currentFirebaseUser = firebaseUser;
          Fluttertoast.showToast(msg: "Login Successful.");
          Navigator.push(context, MaterialPageRoute(builder: (c)=> const MySplashScreen()));
        }
        else {
          Fluttertoast.showToast(msg: "No record exists for this user. Please create new account.");
          fAuth.signOut();
          Navigator.push(context, MaterialPageRoute(builder: (c)=> const MySplashScreen()));
        }
      });

    }
    else
    {
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "Error Occurred during Login.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff095d61),
    body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [

              const SizedBox(height: 10,),

              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Image.asset("images/logo-large.png"),
              ),

              const SizedBox(height: 10,),

              const Text(
                "Login as a User",
                style: TextStyle(
                  fontSize: 26,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),

              // Email Field
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

              // Password Field
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
                  minimumSize: const Size.fromHeight(50), // NEW

                ),

                child: const Text("Login",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),

                ),
              ),

              const SizedBox(height: 20,),

              TextButton(
                child: const Text(
                  "Do not have an account? Sign up here",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,

                  ),
                ),
                onPressed: ()
                {
                  Navigator.push(context, MaterialPageRoute(builder: (c)=> const SignUpScreen()));
                },
              ),

            ],
          ),
        ),
      ),
    );
  }
}
