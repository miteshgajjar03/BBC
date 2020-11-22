import 'dart:io';

import 'package:den_lineicons/den_lineicons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:getgolo/GeneralMethods/general_method.dart';
import 'package:getgolo/modules/setting/colors.dart';
import 'package:getgolo/modules/setting/fonts.dart';
import 'package:getgolo/src/entity/User.dart';
import 'package:getgolo/src/providers/request_services/Api+auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';

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

  User objUser;
  File _pickedImage;
  final _imagePicker = ImagePicker();
  Future<void> _future;

  @override
  void initState() {
    super.initState();

    _future = _getProfile(context: context);
  }

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

  //
  // GetUserProfile
  //
  Future<void> _getProfile({
    @required BuildContext context,
  }) async {
    // final progress = ProgressDialog(context, isDismissible: true);
    // await progress.show();
    final user = await ApiAuth.getProfile();
    // await progress.hide();
    if (user != null) {
      objUser = user;
      _setupUserData();
    } else {
      showConfirmationAlert(
        context: context,
        actionButtonTitle: 'Ok',
        title: 'Message',
        message: 'Error while getting details. Please try again later!',
        confirmAction: () {
          Navigator.of(context).pop();
        },
      );
    }
  }

  //
  // SetupData
  //
  _setupUserData() {
    _nameController.text = objUser.name;
    _emailController.text = objUser.email;
    _phoneController.text = objUser.phoneNumber;
    _facebookController.text = objUser.facebook;
    _instaController.text = objUser.instagram;
    print(objUser.avatarUrl);
  }

  //
  // ShowImagePicker
  //
  _showImagePicker({
    @required ImageSource source,
  }) async {
    final image = await _imagePicker.getImage(
      source: source,
    );
    if (image != null) {
      setState(() {
        _pickedImage = File(image.path);
      });
    }
  }

  //
  // UpdateProfile
  //
  _updateProfile({
    @required BuildContext buildContext,
  }) async {
    hideKeyboard(buildContext);
    final progress = ProgressDialog(buildContext);
    await progress.show();
    final response = await ApiAuth.updateProfile(
      dict: {
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'instagram': _instaController.text.trim(),
        'facebook': _facebookController.text.trim(),
        'phone_number': _phoneController.text.trim(),
        'avatar': ''
      },
      imageFile: _pickedImage,
      imageFieldName: 'avatar',
    );
    await progress.hide();
    showSnackBar(
      response.message,
      buildContext,
    );
    print(response.message);
  }

  //
  // ChangePassword
  //
  _validateChangePassword({
    @required BuildContext ctx,
  }) async {
    hideKeyboard(ctx);
    if (_currentPassController.text.isEmpty) {
      showSnackBar(
        'Please enter your old password!',
        ctx,
      );
    } else if (_newPassController.text.length < 8) {
      showSnackBar(
        'New password should be 8 characters long!',
        ctx,
      );
    } else if (_confirmPassController.text.length < 8) {
      showSnackBar(
        'Confirm password should be 8 characters long!',
        ctx,
      );
    } else if (_newPassController.text != _confirmPassController.text) {
      showSnackBar(
        'New password and confirm password does not matched!',
        ctx,
      );
    } else {
      final progress = ProgressDialog(ctx);
      await progress.show();
      final response = await ApiAuth.changePassword(
        dict: {
          'old_password': _currentPassController.text,
          'new_password': _newPassController.text,
        },
      );
      await progress.hide();
      showSnackBar(response.message, ctx);
      if (response.isSuccess) {
        _currentPassController.text = '';
        _newPassController.text = '';
        _confirmPassController.text = '';
      }
    }
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
      body: FutureBuilder(
        future: _future,
        builder: (fbContext, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Text(
                'Fetchig user data...',
                style: TextStyle(
                  fontSize: 22.0,
                  fontFamily: GoloFont,
                ),
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return ListView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              scrollDirection: Axis.vertical,
              padding: const EdgeInsets.all(16.0),
              children: [
                const SizedBox(
                  height: 16.0,
                ),
                Center(
                  child: GestureDetector(
                    onTap: () async {
                      showImagePickerActionSheet(
                          context: context,
                          selectedOption: (option) {
                            switch (option) {
                              case PhotoPickerOption.camera:
                                _showImagePicker(source: ImageSource.camera);
                                break;
                              case PhotoPickerOption.photoLibrary:
                                _showImagePicker(source: ImageSource.gallery);
                                break;
                              case PhotoPickerOption.cancel:
                                break;
                            }
                          });
                    },
                    child: Container(
                      height: 160.0,
                      width: 160.0,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(80.0),
                      ),
                      child: _pickedImage != null
                          ? CircleAvatar(
                              backgroundImage: FileImage(
                                _pickedImage,
                              ),
                              backgroundColor: Colors.transparent,
                            )
                          : objUser != null
                              ? objUser.avatarUrl.isNotEmpty
                                  ? CircleAvatar(
                                      backgroundImage: NetworkImage(
                                        objUser.avatarUrl,
                                      ),
                                      backgroundColor: Colors.transparent,
                                    )
                                  : Icon(
                                      DenLineIcons.user,
                                      size: 50,
                                      color: Colors.grey,
                                    )
                              : null,
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
                  onPressed: () async {
                    _updateProfile(
                      buildContext: fbContext,
                    );
                  },
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
                _buildActionButton(
                    title: 'Save',
                    onPressed: () {
                      _validateChangePassword(ctx: fbContext);
                    }),
                SizedBox(
                  height: 22,
                ),
              ],
            );
          }
          return Container();
        },
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
