import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:getgolo/main.dart';
import 'package:getgolo/modules/setting/colors.dart';
import 'package:getgolo/src/providers/request_services/Api+auth.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

bool _signUpActive = false;
bool _signInActive = true;
bool _forgotPassActive = false;
//Login
TextEditingController _emailController = TextEditingController();
TextEditingController _passwordController = TextEditingController();

//SingUp
TextEditingController _registerFullNameController = TextEditingController();
TextEditingController _registerEmailController = TextEditingController();
TextEditingController _registerPasswordController = TextEditingController();
TextEditingController _registerConfirmPasswordController =
    TextEditingController();

class _LogInPageState extends StateMVC<LogInPage> {
  _LogInPageState() : super(Controller());
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    ScreenUtil.instance = ScreenUtil.getInstance()..init(context);
    ScreenUtil.instance =
        ScreenUtil(width: 750, height: 1304, allowFontScaling: true)
          ..init(context);
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: ScreenUtil.getInstance().setHeight(100),
          ),
          Container(
            child: Padding(
              padding: EdgeInsets.only(left: 25.0, right: 25.0),
              child: IntrinsicWidth(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    OutlineButton(
                      onPressed: () =>
                          setState(() => Controller.changeToSignIn()),
                      borderSide: new BorderSide(
                        style: BorderStyle.none,
                      ),
                      child: new Text(
                        Controller.displaySignInMenuButton,
                        style: _signInActive
                            ? TextStyle(
                                fontSize: 22,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              )
                            : TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                                fontWeight: FontWeight.normal,
                              ),
                      ),
                    ),
                    OutlineButton(
                      onPressed: () => setState(
                        () => Controller.changeToSignUp(),
                      ),
                      borderSide: BorderSide(
                        style: BorderStyle.none,
                      ),
                      child: Text(
                        Controller.displaySignUpMenuButton,
                        style: _signUpActive
                            ? TextStyle(
                                fontSize: 22,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              )
                            : TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                                fontWeight: FontWeight.normal,
                              ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            height: ScreenUtil.getInstance().setHeight(170),
          ),
          SizedBox(
            height: ScreenUtil.getInstance().setHeight(10),
          ),
          Container(
            child: Padding(
              padding: EdgeInsets.only(left: 30.0, right: 30.0),
              child: _signInActive
                  ? _showSignIn(context)
                  : _forgotPassActive
                      ? _showForgotPassword(context)
                      : _showSignUp(),
            ),
          ),
        ],
      ),
    );
  }

  //
  // Snackbar
  //
  _showSnackBar(
    String message,
    BuildContext buildContext,
  ) {
    Scaffold.of(buildContext).hideCurrentSnackBar();
    Scaffold.of(buildContext).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  //
  // Validate Login Input
  //
  _validateLoginInput(
    BuildContext buildContext,
  ) {
    if (_emailController.text.isEmpty) {
      _showSnackBar(
        'Please enter email id',
        buildContext,
      );
    } else if (!_isValidEmail(_emailController.text)) {
      _showSnackBar(
        'Please enter valid email id',
        buildContext,
      );
    } else if (_passwordController.text.isEmpty) {
      _showSnackBar(
        'Please enter your password',
        buildContext,
      );
    } else {
      _login(
        email: _emailController.text,
        password: _passwordController.text,
        buildContext: context,
      );
    }
  }

  //
  // Login user
  //
  _login({
    @required String email,
    @required String password,
    @required BuildContext buildContext,
  }) async {
    setState(() {
      _isLoading = true;
    });
    Map<String, String> param = {
      "email": email,
      "password": password,
    };
    final response = await ApiAuth.loginUsing(
      query: param,
    );
    setState(() {
      _isLoading = false;
    });
    if (response.isSuccess) {
      final BottomNavigationBar bottomBar = globalKey.currentWidget;
      bottomBar.onTap(3);
    } else {
      Scaffold.of(context).hideCurrentSnackBar();
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${response.message}',
          ),
        ),
      );
    }
  }

  //
  // Validate Register Input
  //
  _validateRegisterInput(
    BuildContext buildContext,
  ) {
    if (_registerFullNameController.text.isEmpty) {
      _showSnackBar(
        'Please enter your full name',
        buildContext,
      );
    } else if (_registerEmailController.text.isEmpty) {
      _showSnackBar(
        'Please enter email id',
        buildContext,
      );
    } else if (!_isValidEmail(_registerEmailController.text)) {
      _showSnackBar(
        'Please enter valid email id',
        buildContext,
      );
    } else if (_registerPasswordController.text.isEmpty) {
      _showSnackBar(
        'Please enter your password',
        buildContext,
      );
    } else if (_registerPasswordController.text.length < 8) {
      _showSnackBar(
        'Password must be 8 characters long!',
        buildContext,
      );
    } else if (_registerConfirmPasswordController.text.isEmpty) {
      _showSnackBar(
        'Please enter your confirm password',
        buildContext,
      );
    } else if (_registerPasswordController.text !=
        _registerConfirmPasswordController.text) {
      _showSnackBar(
        'Password and confirm does not matched!',
        buildContext,
      );
    } else {
      _register(
        buildContext: context,
        email: _registerEmailController.text,
        name: _registerFullNameController.text,
        pass1: _registerPasswordController.text,
        pass2: _registerConfirmPasswordController.text,
      );
    }
  }

  bool _isValidEmail(String em) {
    String p =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(p);
    return regExp.hasMatch(em);
  }

  //
  // Register user
  //
  _register({
    String email,
    String pass1,
    String pass2,
    String name,
    BuildContext buildContext,
  }) async {
    setState(() {
      _isLoading = true;
    });
    Map<String, String> param = {
      "name": name,
      "email": email,
      "password": pass1,
      "c_password": pass2
    };
    final response = await ApiAuth.registerUsing(
      query: param,
    );
    setState(() {
      _isLoading = false;
    });
    if (response.isSuccess) {
    } else {
      Scaffold.of(context).hideCurrentSnackBar();
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${response.message}',
          ),
        ),
      );
    }
  }

  //
  // Hide Keyboard
  //
  _hideKeyboard(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      FocusManager.instance.primaryFocus.unfocus();
    }
  }

  Widget _showSignIn(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        SizedBox(
          height: ScreenUtil.getInstance().setHeight(30),
        ),
        Container(
          child: Padding(
            padding: EdgeInsets.only(),
            child: TextField(
              style: TextStyle(color: Colors.black),
              controller: _emailController,
              decoration: InputDecoration(
                hintText: Controller.displayHintTextEmail,
                hintStyle: CustomTextStyle.formField(context),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 1.0)),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 1.0)),
              ),
              obscureText: false,
            ),
          ),
        ),
        SizedBox(
          height: ScreenUtil.getInstance().setHeight(20),
        ),
        Container(
          child: Padding(
            padding: EdgeInsets.only(),
            child: TextField(
              obscureText: true,
              style: TextStyle(color: Colors.black),
              controller: _passwordController,
              decoration: InputDecoration(
                //Add th Hint text here.
                hintText: Controller.displayHintTextPassword,
                hintStyle: CustomTextStyle.formField(context),
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
            ),
          ),
        ),
        SizedBox(
          height: ScreenUtil.getInstance().setHeight(30),
        ),
        Container(
          child: Padding(
            padding: EdgeInsets.only(),
            child: InkWell(
              onTap: () {
                //------- Forgot Password event-----
                setState(() => Controller.changeToForgotPassword());
                //_handleForgotPasswordTap(buildContext: context);
              },
              child: Text(
                'Forgot Password',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                  color: GoloColors.primary,
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: ScreenUtil.getInstance().setHeight(80),
        ),
        Container(
          child: Padding(
            padding: EdgeInsets.only(),
            child: _isLoading
                ? Center(child: CircularProgressIndicator(strokeWidth: 3))
                : ButtonTheme(
                    height: 50.0,
                    child: RaisedButton(
                      textColor: Colors.white,
                      color: GoloColors.primary,
                      shape: StadiumBorder(),
                      onPressed: () {
                        _hideKeyboard(context);
                        _validateLoginInput(context);
                      },
                      child: Text(
                        "Sign In",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
          ),
        ),
        SizedBox(
          height: ScreenUtil.getInstance().setHeight(30),
        ),
        /*Container(
          child: Padding(
            padding: EdgeInsets.only(),
            child: ButtonTheme(
              height: 50.0,
              child: RaisedButton(
                textColor: Colors.white,
                color: Color(0xFF3C5A99),
                shape: StadiumBorder(),
                onPressed: () {},
                child: Text(
                  Controller.displaySignInFacebookButton,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: ScreenUtil.getInstance().setHeight(30),
        ),
        Container(
          child: Padding(
            padding: EdgeInsets.only(),
            child: ButtonTheme(
              height: 50.0,
              child: RaisedButton(
                textColor: Colors.white,
                color: Color(0xFFFF0000),
                shape: StadiumBorder(),
                onPressed: () {},
                child: Text("Sing in with Google",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        ),*/
      ],
    );
  }

  Widget _showSignUp() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        SizedBox(
          height: ScreenUtil.getInstance().setHeight(30),
        ),
        Container(
          child: Padding(
            padding: EdgeInsets.only(),
            child: TextField(
              style: TextStyle(color: Colors.black),
              controller: _registerFullNameController,
              decoration: InputDecoration(
                hintText: "Full Name",
                hintStyle: CustomTextStyle.formField(context),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 1.0)),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 1.0)),
              ),
              obscureText: false,
            ),
          ),
        ),
        SizedBox(
          height: ScreenUtil.getInstance().setHeight(20),
        ),
        Container(
          child: Padding(
            padding: EdgeInsets.only(),
            child: TextField(
              style: TextStyle(color: Colors.black),
              controller: _registerEmailController,
              decoration: InputDecoration(
                hintText: Controller.displayHintTextEmail,
                hintStyle: CustomTextStyle.formField(context),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 1.0)),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 1.0)),
              ),
              obscureText: false,
            ),
          ),
        ),
        SizedBox(
          height: ScreenUtil.getInstance().setHeight(20),
        ),
        Container(
          child: Padding(
            padding: EdgeInsets.only(),
            child: TextField(
              obscureText: true,
              style: TextStyle(color: Colors.black),
              controller: _registerPasswordController,
              decoration: InputDecoration(
                //Add th Hint text here.
                hintText: Controller.displayHintTextPassword,
                hintStyle: CustomTextStyle.formField(context),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 1.0)),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 1.0)),
              ),
            ),
          ),
        ),
        SizedBox(
          height: ScreenUtil.getInstance().setHeight(20),
        ),
        Container(
          child: Padding(
            padding: EdgeInsets.only(),
            child: TextField(
              obscureText: true,
              style: TextStyle(color: Colors.black),
              controller: _registerConfirmPasswordController,
              decoration: InputDecoration(
                //Add th Hint text here.
                hintText: "Confirm Password",
                hintStyle: CustomTextStyle.formField(context),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 1.0)),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 1.0)),
              ),
            ),
          ),
        ),
        SizedBox(
          height: ScreenUtil.getInstance().setHeight(40),
        ),
        Container(
          child: Padding(
            padding: EdgeInsets.only(),
            child: _isLoading
                ? Center(child: CircularProgressIndicator(strokeWidth: 3))
                : ButtonTheme(
                    height: 50.0,
                    child: RaisedButton(
                      textColor: Colors.white,
                      color: GoloColors.primary,
                      shape: StadiumBorder(),
                      onPressed: () {
                        _hideKeyboard(context);
                        _validateRegisterInput(context);
                      },
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
          ),
        ),
        SizedBox(
          height: ScreenUtil.getInstance().setHeight(20),
        ),
        /*Container(
          child: Padding(
            padding: EdgeInsets.only(),
            child: ButtonTheme(
              height: 50.0,
              child: RaisedButton(
                textColor: Colors.white,
                color: Color(0xFF3C5A99),
                shape: StadiumBorder(),
                onPressed: () {},
                child: Text("Sing up with Facebook",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        ),
        SizedBox(
          height: ScreenUtil.getInstance().setHeight(20),
        ),
        Container(
          child: Padding(
            padding: EdgeInsets.only(),
            child: ButtonTheme(
              height: 50.0,
              child: RaisedButton(
                textColor: Colors.white,
                color: Color(0xFFFF0000),
                shape: StadiumBorder(),
                onPressed: () {},
                child: Text("Sing up with Google",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        ),*/
      ],
    );
  }

  Widget _showForgotPassword(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          height: 30,
          color: Colors.amber,
        ),
      ],
    );
  }

  Widget horizontalLine() => Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Container(
          width: ScreenUtil.getInstance().setWidth(120),
          height: 1.0,
          color: Colors.white.withOpacity(0.6),
        ),
      );
}

class LogInPage extends StatefulWidget {
  LogInPage({Key key}) : super(key: key);

  @protected
  @override
  State<StatefulWidget> createState() => _LogInPageState();
}

class Controller extends ControllerMVC {
  /// Singleton Factory
  factory Controller() {
    if (_this == null) _this = Controller._();
    return _this;
  }

  static Controller _this;

  Controller._();

  /// Allow for easy access to 'the Controller' throughout the application.
  static Controller get con => _this;

  /// The Controller doesn't know any values or methods. It simply handles the communication between the view and the model.

  static String get displaySignUpMenuButton => Model._signUpMenuButton;

  static String get displaySignInMenuButton => Model._signInMenuButton;

  static String get displayHintTextEmail => Model._hintTextEmail;

  static String get displayHintTextPassword => Model._hintTextPassword;

  static String get displayHintTextNewEmail => Model._hintTextNewEmail;

  static String get displayHintTextNewPassword => Model._hintTextNewPassword;

  static String get displaySignUpButtonTest => Model._signUpButtonText;

  static String get displaySignInEmailButton =>
      Model._signInWithEmailButtonText;

  static String get displaySignInFacebookButton =>
      Model._signInWithFacebookButtonText;

  static String get displaySeparatorText =>
      Model._alternativeLogInSeparatorText;

  static String get displayErrorEmailLogIn => Model._emailLogInFailed;

  static void changeToSignUp() => Model._changeToSignUp();

  static void changeToSignIn() => Model._changeToSignIn();

  static void changeToForgotPassword() => Model._changeToForgotPass();

  /*static Future<ResponseData> signInWithEmail(context, email, password) async {
    Map<String, String> param = {"email": email, "password": password};
    final response = await ApiAuth.loginUsing(query: param);
    return response;
  }*/

  /*static Future<ResponseData> tryToLogInUserViaEmail(
      context, email, password) async {
    final responseData = await signInWithEmail(context, email, password);
    return responseData;
  }*/

  static Future tryToSignUpWithEmail(email, password) async {
    if (await tryToSignUpWithEmail(email, password) == true) {
    } else {}
  }
}

class Model {
  static String _signInMenuButton = "SIGN IN";
  static String _signUpMenuButton = "SIGN UP";
  static String _hintTextEmail = "Email";
  static String _hintTextPassword = "Password";
  static String _hintTextNewEmail = "Enter your Email";
  static String _hintTextNewPassword = "Enter a Password";
  static String _signUpButtonText = "SIGN UP";
  static String _signInWithEmailButtonText = "Login";
  static String _signInWithFacebookButtonText = "Sign in with Facebook";
  static String _alternativeLogInSeparatorText = "or";
  static String _emailLogInFailed =
      "Email or Password was incorrect. Please try again";

  static void _changeToSignUp() {
    _signUpActive = true;
    _signInActive = false;
    _forgotPassActive = false;
  }

  static void _changeToSignIn() {
    _signUpActive = false;
    _signInActive = true;
    _forgotPassActive = false;
  }

  static void _changeToForgotPass() {
    _forgotPassActive = true;
    _signUpActive = false;
    _signInActive = false;
  }
}

class CustomTextStyle {
  static TextStyle formField(BuildContext context) {
    return Theme.of(context).textTheme.headline6.copyWith(
        fontSize: 18.0, fontWeight: FontWeight.normal, color: Colors.grey);
  }

  static TextStyle title(BuildContext context) {
    return Theme.of(context).textTheme.headline6.copyWith(
        fontSize: 34, fontWeight: FontWeight.bold, color: Colors.white);
  }

  static TextStyle subTitle(BuildContext context) {
    return Theme.of(context).textTheme.headline6.copyWith(
        fontSize: 14, fontWeight: FontWeight.normal, color: Colors.white);
  }

  static TextStyle button(BuildContext context) {
    return Theme.of(context).textTheme.headline6.copyWith(
        fontSize: 20, fontWeight: FontWeight.normal, color: Colors.white);
  }

  static TextStyle body(BuildContext context) {
    return Theme.of(context).textTheme.headline6.copyWith(
        fontSize: 14, fontWeight: FontWeight.normal, color: Colors.white);
  }
}
