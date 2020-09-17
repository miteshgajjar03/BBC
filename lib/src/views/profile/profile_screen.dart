import 'package:den_lineicons/den_lineicons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:getgolo/modules/setting/colors.dart';
import 'package:getgolo/modules/setting/fonts.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _facebookController = TextEditingController();
  TextEditingController _instaController = TextEditingController();
  TextEditingController _currentPassController = TextEditingController();
  TextEditingController _newPassController = TextEditingController();
  TextEditingController _confirmPassController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _facebookController.dispose();
    _instaController.dispose();
    _currentPassController.dispose();
    _newPassController.dispose();
    _confirmPassController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Profile Setting',
          style: TextStyle(
            fontFamily: GoloFont,
            fontWeight: FontWeight.w500,
            fontSize: 24,
            color: GoloColors.secondary1,
            letterSpacing: 0,
          ),
        ),
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            DenLineIcons.angle_left,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: ListView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        scrollDirection: Axis.vertical,
        padding: const EdgeInsets.all(16.0),
        children: [
          const SizedBox(
            height: 16.0,
          ),
          Center(
            child: Container(
              height: 160.0,
              width: 160.0,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(80.0),
              ),
              child: Icon(
                DenLineIcons.user,
                size: 50,
                color: Colors.grey,
              ),
            ),
          ),
          const SizedBox(
            height: 16.0,
          ),
          _buildTitleHeader(title: 'BASIC INFO'),
          _buildTextField(
            labelText: 'Full name',
            inputType: TextInputType.name,
            controller: _nameController,
          ),
          _buildTextField(
            labelText: 'Email',
            inputType: TextInputType.emailAddress,
            controller: _emailController,
          ),
          _buildTextField(
            labelText: 'Phone',
            inputType: TextInputType.phone,
            controller: _phoneController,
          ),
          _buildTextField(
            labelText: 'Facebook Link',
            inputType: TextInputType.url,
            controller: _facebookController,
          ),
          _buildTextField(
            labelText: 'Instagram Link',
            inputType: TextInputType.url,
            controller: _instaController,
          ),
          SizedBox(
            height: 22,
          ),
          _buildActionButton(
            title: 'Update',
            onPressed: () {},
          ),
          SizedBox(
            height: 44,
          ),
          _buildTitleHeader(title: 'CHANGE PASSWORD'),
          _buildTextField(
            labelText: 'Old Password',
            obscureText: true,
            controller: _currentPassController,
          ),
          _buildTextField(
            labelText: 'New Password',
            obscureText: true,
            controller: _newPassController,
          ),
          _buildTextField(
            labelText: 'Confirm Password',
            obscureText: true,
            controller: _confirmPassController,
          ),
          SizedBox(
            height: 22,
          ),
          _buildActionButton(title: 'Save', onPressed: () {}),
          SizedBox(
            height: 22,
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    @required String labelText,
    TextInputType inputType = TextInputType.name,
    bool obscureText = false,
    @required TextEditingController controller,
  }) {
    return TextField(
      autocorrect: false,
      keyboardType: inputType,
      obscureText: obscureText,
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        // focusedBorder: UnderlineInputBorder(
        //   borderSide: BorderSide(color: GoloColors.primary),
        // ),
      ),
      style: TextStyle(
        fontFamily: GoloFont,
      ),
    );
  }

  Widget _buildTitleHeader({@required String title}) {
    return Text(
      title,
      style: TextStyle(
        color: Colors.grey[600],
        fontFamily: GoloFont,
        fontSize: 18,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildActionButton({
    @required String title,
    @required Function onPressed,
  }) {
    return ButtonTheme(
      height: 50.0,
      child: RaisedButton(
        textColor: Colors.white,
        color: GoloColors.primary,
        shape: StadiumBorder(),
        onPressed: onPressed,
        child: Text(
          title,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w500,
            fontFamily: GoloFont,
          ),
        ),
      ),
    );
  }
}
