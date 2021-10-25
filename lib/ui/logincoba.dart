import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kanarapemograman/ui/home.dart';
import 'package:kanarapemograman/ui/register.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:kanarapemograman/const/collor.dart';
import 'package:kanarapemograman/server/server.dart';
import 'package:shared_preferences/shared_preferences.dart';

class loginview extends StatefulWidget {
  const loginview({Key? key}) : super(key: key);

  @override
  _loginviewState createState() => _loginviewState();
}

class _loginviewState extends State<loginview> {

  TextEditingController controlleremail = new TextEditingController();
  TextEditingController controllerpassword = new TextEditingController();

  void showSnakbar(BuildContext context, Message, color) {
    final snackBar = SnackBar(content: Text(Message), backgroundColor: color);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
  Future<void> Signin() async {
    String email = controlleremail.text;
    String password = controllerpassword.text;
    var url = UrlServer + "users/sign-in";
    if (email.isEmpty) {
      // Navigator.of(context, rootNavigator: true).pop();
      showSnakbar(context, 'Email Cannot Empty !', ErrorColor);
    } else if (password.isEmpty) {
      showSnakbar(context, 'Password Cannot Empty !', ErrorColor);
    } else {
      final response = await http
          .post(Uri.parse(url), body: {"email": email, "password": password});
      var result = convert.jsonDecode(response.body);
      print(result);
      String Message = result['message'];
      if (result['status']) {
        // Navigator.of(context, rootNavigator: true).pop();
        showSnakbar(context, Message, SuccesColor);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLogin', true);
        await prefs.setString('_id', result['user']['_id']);
        await prefs.setString('nama', result['user']['nama']);
        await prefs.setString('email', result['user']['email']);
        await prefs.setString('telp', result['user']['telp']);
        await prefs.setString('password', result['user']['password']);
        var _duration = const Duration(seconds: 1);
        Timer(_duration, () {
          Navigator.pushReplacement(context,
              MaterialPageRoute(
                  builder: (BuildContext context) => homepage()));
        });
      } else {
        // Navigator.of(context, rootNavigator: true).pop();
        showSnakbar(context, Message, ErrorColor);
        print(Message);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 60.0, bottom: 15),
              child: Center(
                child: SizedBox(
                    width: 200,
                    height: 200,
                    /*decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(50.0)),*/
                    child: Image.asset('assets/profile.png')),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: Center(
                child: Text(
                  'Sign In',
                  style: (TextStyle(
                      color: Colors.blue, fontSize: 30, fontFamily: 'Raleway')),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                controller: controlleremail,
                autofocus: true,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    labelText: 'Email',
                    hintText: 'Type Your Email'),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              //padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 15, bottom: 0),
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                controller: controllerpassword,
                autofocus: true,
                keyboardType: TextInputType.visiblePassword,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                            Radius.circular(10.0))),
                    labelText: 'Password',
                    hintText: 'Enter secure password'),
                obscureText: true,),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              // padding: EdgeInsets.all(10),
              margin: const EdgeInsets.only(top: 20.0),
              height: 50,
              width: 300,
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(23)),
              child: FlatButton(
                onPressed: () {
                  Submit(context);
                },
                child: const Text(
                  'LOG IN',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            FlatButton(
                onPressed: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (_) => registerview()));
                },
                child: const Text(
                  'Anda belum punya akun? Silahkan Daftar disini',
                  style: TextStyle(color: Colors.green, fontSize: 15),
                )),
            // Text('Do not have an account yet? Register')
          ],
        ),
      ),
    );
  }

  Future<void> Submit(BuildContext context) async {
    try {
      Signin();
    } catch (error) {
      print(error);
    }
  }
}