import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/models/logged_user.dart';
import 'package:todoapp/widgets/start_app.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var name = '';
  var password = '';
  var email = '';
  var isLoading = false;
  var isSignIn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isSignIn ? 'Sign In' : 'Sign Up'),
        centerTitle: true,
      ),
      body: Form(
          key: _formKey,
          child: SingleChildScrollView(
              child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    children: <Widget>[
                      if (!isSignIn)
                        Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 15),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: TextFormField(
                              decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.person),
                                labelText: 'Name',
                              ),
                              autocorrect: false,
                              onChanged: (value) {
                                name = value;
                              },
                              validator: (value) {
                                if (value != null && value.isEmpty) {
                                  return 'Name is too short';
                                }
                              },
                            )),
                      Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 15),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: TextFormField(
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.mail),
                              labelText: 'Email',
                            ),
                            autocorrect: false,
                            onChanged: (value) {
                              email = value;
                            },
                            validator: (value) {
                              if (value != null && !value.contains("@")) {
                                return 'Email is not valid';
                              }
                            },
                          )),
                      Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 15),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: TextFormField(
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.password),
                              labelText: 'Password',
                            ),
                            autocorrect: false,
                            obscureText: true,
                            onChanged: (value) {
                              password = value;
                            },
                            validator: (value) {
                              if (value != null && value.length < 6) {
                                return 'Password is too short';
                              }
                            }),
                      ),
                      _submitButton(context),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 15),
                        child: Center(
                          child: RichText(
                            text: TextSpan(
                                style: const TextStyle(color: Colors.grey),
                                children: [
                                  TextSpan(
                                    text: isSignIn
                                        ? "I'm new user"
                                        : "I'm already a user",
                                  ),
                                  TextSpan(
                                      text: isSignIn ? "Sign Up" : "Sign In",
                                      style: const TextStyle(
                                        color: Colors.blue,
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          setState(() {
                                            isSignIn = !isSignIn;
                                          });
                                        })
                                ]),
                          ),
                        ),
                      ),
                    ],
                  )))),
    );
  }

  Widget _submitButton(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 35, horizontal: 35),
        child: isLoading
            ? const CircularProgressIndicator()
            : TextButton(
                child: Center(
                  child: ListTile(
                    title: isSignIn
                        ? const Text('Sign In')
                        : const Text('Sign Up'),
                  ),
                ),
                onPressed: () {
                  if (!isLoading) {
                    FocusScope.of(context).requestFocus(FocusNode());
                    if (_formKey.currentState!.validate()) {
                      var snackBar = const SnackBar(content: Text('Sign Up'));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      _saveForm(context);
                    }
                  }
                },
              ));
  }

  Future<void> _saveForm(BuildContext ctx) async {
    final loggedUser = Provider.of<LoggedUser>(context, listen: false);
    final auth = FirebaseAuth.instance;

    UserCredential authResult;

    try {
      setState(() {
        isLoading = true;
      });
      if (isSignIn) {
        authResult = await auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        authResult = await auth.createUserWithEmailAndPassword(
            email: email, password: password);

        await FirebaseFirestore.instance
            .collection('users')
            .doc(authResult.user!.uid)
            .set({
          'name': name,
          'email': email,
          'membership': 'STANDARD',
        }, SetOptions(merge: true));
      }
      await loggedUser.setProfileInfo();
      Navigator.of(context).pushReplacement(
          MaterialPageRoute<void>(builder: (_) => const StartApp()));
    } catch (error) {
      var message = "An error occurred, please check your credentials";
      var snackBar = SnackBar(content: Text(message));
      ScaffoldMessenger.of(ctx).showSnackBar(snackBar);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}
