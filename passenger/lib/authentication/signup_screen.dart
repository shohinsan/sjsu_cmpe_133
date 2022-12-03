import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:passenger/authentication/login_screen.dart';
import 'package:passenger/global/global.dart';
import 'package:passenger/splash/splash_screen.dart';
import 'package:passenger/widgets/progress_dialog.dart';


class SignUpScreen extends StatefulWidget
{
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
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
      saveUserInfoNow();
    }
  }

  saveUserInfoNow() async
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
        Fluttertoast.showToast(msg: "Error: $msg");
      })
    ).user;

    if(firebaseUser != null)
    {
      Map userMap =
      {
        "id": firebaseUser.uid,
        "name": nameTextEditingController.text.trim(),
        "email": emailTextEditingController.text.trim(),
        "phone": phoneTextEditingController.text.trim(),
      };

      DatabaseReference usersRef = FirebaseDatabase.instance.ref().child("users");
      usersRef.child(firebaseUser.uid).set(userMap);

      currentFirebaseUser = firebaseUser;
      Fluttertoast.showToast(msg: "Account has been Created.");
      // ignore: use_build_context_synchronously
      Navigator.push(context, MaterialPageRoute(builder: (c)=> const MySplashScreen()));
    }
    else
    {
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "Account has not been Created.");
    }
  }

  // UI Starts Here

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff095d61),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [


              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Image.asset("images/logo-large.png"),
              ),

              const Text(
                "Register as a User",
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
                  style: TextStyle(color: Colors.white,
                  fontSize: 18,),
                ),
                onPressed: ()
                {
                  Navigator.push(context, MaterialPageRoute(builder: (c)=> const LoginScreen()));
                },
              ),

            ],
          ),
        ),
      ),
    );
  }
}
