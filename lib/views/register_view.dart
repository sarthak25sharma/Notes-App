import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:notes/firebase_options.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});
  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  
  late final TextEditingController _email ;
  late final TextEditingController _password ;

  @override
  void initState() {
    
    _email=TextEditingController();
    _password=TextEditingController();
    super.initState();
  }
  @override
  void dispose() {
    
    _email.dispose();
    _password.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar :AppBar(title: const Text('Register'),),
      body: Column(
            children: [
              TextField( 
                controller: _email,
                decoration: const InputDecoration(
                  hintText: "Enter Email"
                   ),
                ),
              TextField( 
                controller: _password,
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  hintText: "Enter Password"
                ),
                ),
              TextButton(
                onPressed: () async {
                  await Firebase.initializeApp(
                    options:DefaultFirebaseOptions.currentPlatform,
                  );
                  final email=_email.text;
                  final password=_password.text;
                  try{
                  final UserCredential= FirebaseAuth.instance.createUserWithEmailAndPassword(
                    email: email, 
                    password: password,
                    );
                    //print(UserCredential);
                  }
                  on FirebaseAuthException catch(e){
                    print(e.code);
                  }
                }, 
                child: const Text('Register')),
                TextButton(onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil('/login', (route)=>false);
                }, child: const Text('Already Registered ? Login here'))
            ],
          ),
    );
  }
}