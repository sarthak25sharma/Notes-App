import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:notes/constants/routes.dart';
import 'package:notes/firebase_options.dart';
import 'package:notes/utilities/show_error_dialog.dart';
class LoginView extends StatefulWidget {
  const LoginView({super.key});
  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  
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
      appBar: AppBar(title: const Text('Login')),
      body: FutureBuilder(
        future: Firebase.initializeApp(
                  options:DefaultFirebaseOptions.currentPlatform,
                ),
        builder: (context, snapshot) {
          // switch(snapshot.connectionState){

          //   case ConnectionState.done:
              
          //     // TODO: Handle this case
          // }
           return Column(
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
                  await FirebaseAuth.instance.signInWithEmailAndPassword(
                  email: email, 
                  password: password,
                  );
                  Navigator.of(context).pushNamedAndRemoveUntil(notesRoute, (route)=>false);
                } 
                on FirebaseAuthException catch(e){
                  if(e.code =='user-not-found'){
                    await showErrorDialog(
                    context, 
                    'User not found',
                    );
                  }
                  else if(e.code =='wrong-password'){
                    await showErrorDialog(
                    context, 
                    'Wrong password',
                    );
                  }
                  else{
                    await showErrorDialog(
                    context, 
                    'Error: ${e.code}',
                    );
                  }
                }
                catch (e){
                  await showErrorDialog(
                    context, 
                    e.toString(),
                    );
                }
                

              }, 
              child: const Text('Login')),
              TextButton(onPressed: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(registerRoute, (route)=>false);
                }, child: const Text("Register Here"))
          ],
        );
        },
        
      ),
    );
  }

  
  
}
