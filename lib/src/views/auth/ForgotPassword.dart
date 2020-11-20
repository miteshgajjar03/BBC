import 'package:flutter/material.dart';
import 'package:getgolo/GeneralMethods/general_method.dart';
import 'package:getgolo/modules/setting/colors.dart';
import 'package:getgolo/src/views/app_bar/bbc_app_bar.dart';
import 'package:getgolo/src/views/auth/LoginPage.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController _emailController = TextEditingController();

  //
  // Validate Input
  //
  _validateInput({@required BuildContext context}) {
    if (_emailController.text.isEmpty) {
      showSnackBar(
        'Please enter email id',
        context,
      );
    } else if (!isValidEmail(_emailController.text)) {
      showSnackBar(
        'Please enter valid email id',
        context,
      );
    } else {
      // API CALL
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(
          title: 'Forgot Password',
          showBackButton: true,
          backOnPressed: () {
            Navigator.of(context).pop();
          }),
      body: Builder(
        builder: (ctx) => Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                child: TextField(
                  style: TextStyle(color: Colors.black),
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'Email ID',
                    hintStyle: CustomTextStyle.formField(ctx),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
                        width: 1.0,
                      ),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
                        width: 1.0,
                      ),
                    ),
                  ),
                  obscureText: false,
                ),
              ),
              const SizedBox(
                height: 28,
              ),
              ButtonTheme(
                height: 50.0,
                child: RaisedButton(
                  textColor: Colors.white,
                  color: GoloColors.primary,
                  shape: StadiumBorder(),
                  onPressed: () {
                    hideKeyboard(context);
                    _validateInput(context: ctx);
                  },
                  child: Text(
                    "Submit",
                    style: TextStyle(
                      fontSize: 18,
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
