import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:getgolo/localization/Localized.dart';
import 'package:getgolo/localization/LocalizedKey.dart';
import 'package:getgolo/modules/setting/colors.dart';
import 'package:getgolo/modules/setting/fonts.dart';
import 'package:getgolo/src/views/app_bar/bbc_app_bar.dart';

class OpeningHour {
  String title;
  String hintText;
  String errorText;
  String value;

  OpeningHour({
    this.title,
    this.hintText,
    this.errorText,
    this.value,
  });
}

class SocialNetwork {
  String selectNetworkHintText;
  String selectedNetwork;
  String networkURLHintText;
  String networkURL;

  SocialNetwork({
    this.selectNetworkHintText,
    this.networkURLHintText,
    this.selectedNetwork,
    this.networkURL,
  });
}

class AddPlaceScreen extends StatefulWidget {
  @override
  _AddPlaceScreenState createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends State<AddPlaceScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  List<OpeningHour> openingHours = [];
  List<SocialNetwork> socialNetwork = [];

  @override
  void initState() {
    super.initState();
    _setupOpeningHour();
    _initSocialNetwork();
  }

  //
  // SETUP SOCIAL NETWORK
  //
  _initSocialNetwork() {
    final network = _getSocialNetworkConst();
    socialNetwork.add(network);
  }

  SocialNetwork _getSocialNetworkConst() {
    return SocialNetwork(
      networkURL: '',
      networkURLHintText: 'Enter url with http or www',
      selectNetworkHintText: 'Select Network',
      selectedNetwork: '',
    );
  }

  //
  // SETUP OPENING HOUR
  //
  _setupOpeningHour() {
    final monday = OpeningHour(
      title: 'Monday',
      hintText: 'Ex. 9:00 AM - 5:00 PM',
      errorText: '',
      value: '',
    );
    final tuesday = OpeningHour(
      title: 'Tuesday',
      hintText: 'Ex. 9:00 AM - 5:00 PM',
      errorText: '',
      value: '',
    );
    final wednesday = OpeningHour(
      title: 'Wednesday',
      hintText: 'Ex. 9:00 AM - 5:00 PM',
      errorText: '',
      value: '',
    );
    final thursday = OpeningHour(
      title: 'Thursday',
      hintText: 'Ex. 9:00 AM - 5:00 PM',
      errorText: '',
      value: '',
    );
    final friday = OpeningHour(
      title: 'Friday',
      hintText: 'Ex. 9:00 AM - 5:00 PM',
      errorText: '',
      value: '',
    );
    final saturday = OpeningHour(
      title: 'Saturday',
      hintText: 'Ex. 9:00 AM - 5:00 PM',
      errorText: '',
      value: '',
    );
    final sunday = OpeningHour(
      title: 'Sunday',
      hintText: 'Ex. 9:00 AM - 5:00 PM',
      errorText: '',
      value: '',
    );

    openingHours.add(monday);
    openingHours.add(tuesday);
    openingHours.add(wednesday);
    openingHours.add(thursday);
    openingHours.add(friday);
    openingHours.add(saturday);
    openingHours.add(sunday);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(
        title: Localized.of(context).trans(LocalizedKey.addPlace) ?? "",
        showBackButton: true,
        backOnPressed: () {
          Navigator.of(context).pop();
        },
      ),
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: const EdgeInsets.all(
              12.0,
            ),
            children: [
              _buildContainer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(text: 'GENERAL'),
                    const SizedBox(
                      height: 8.0,
                    ),
                    // Place Name
                    _buildTextField(
                      labelText: 'Place Name (en)*',
                      hintText: 'Enter your business name',
                      validator: (text) {},
                      onSaved: (text) {},
                    ),
                    // Price Range
                    _buildTextField(
                      labelText: 'Price Range',
                      hintText: 'Enter your price range',
                      validator: (text) {},
                      onSaved: (text) {},
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    // Description
                    Text(
                      'Description (en)*',
                      style: TextStyle(
                        fontSize: 12.0,
                        fontFamily: GoloFont,
                      ),
                    ),
                    Container(
                      height: 120,
                      margin: const EdgeInsets.only(top: 12.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4.0),
                        border: Border.all(
                          width: 0.5,
                          color: Colors.grey,
                        ),
                      ),
                      child: TextField(
                        keyboardType: TextInputType.multiline,
                        cursorColor: Colors.black,
                        maxLines: null,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    // Select Category
                    _buildTextField(
                      labelText: 'Category *',
                      hintText: 'Select Category',
                      validator: (text) {},
                      onSaved: (text) {},
                    ),
                    // Place Type
                    _buildTextField(
                      labelText: 'Place Type *',
                      hintText: 'Select Place Type in Your Category',
                      validator: (text) {},
                      onSaved: (text) {},
                    ),
                  ],
                ),
              ),

              const SizedBox(
                height: 12.0,
              ),

              // CONTACT INFO
              _buildContainer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(
                      text: 'CONTACT INFO',
                    ),
                    // Email
                    _buildTextField(
                      labelText: 'Email',
                      hintText: 'Your email address',
                      inputType: TextInputType.emailAddress,
                      validator: (text) {},
                      onSaved: (text) {},
                    ),
                    // Phone
                    _buildTextField(
                      labelText: 'Phone Number',
                      hintText: 'Your phone number',
                      inputType: TextInputType.phone,
                      validator: (text) {},
                      onSaved: (text) {},
                    ),
                    // Email
                    _buildTextField(
                      labelText: 'Website',
                      hintText: 'Your website url',
                      inputType: TextInputType.url,
                      validator: (text) {},
                      onSaved: (text) {},
                    ),
                  ],
                ),
              ),

              const SizedBox(
                height: 12.0,
              ),

              // SOCIAL NETWORK
              _buildContainer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(text: 'SOCIAL NETWORK'),
                    SizedBox(
                      height: 8.0,
                    ),
                    Text(
                      'Social Network',
                      style: TextStyle(
                        fontFamily: GoloFont,
                        fontSize: 16,
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: socialNetwork.length,
                      itemBuilder: (lbCtx, index) {
                        final network = socialNetwork[index];
                        return _buildSocialNetworkRow(
                          socialNetwork: network,
                          onPressed: () {
                            setState(() {
                              socialNetwork.removeAt(index);
                            });
                          },
                        );
                      },
                    ),
                    SizedBox(
                      height: 12.0,
                    ),
                    InkWell(
                      onTap: () {
                        final socialRow = _getSocialNetworkConst();
                        socialNetwork.add(socialRow);
                        setState(() {});
                      },
                      child: Chip(
                        backgroundColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            50,
                          ),
                          side: BorderSide(
                            color: Colors.black,
                            width: 1.0,
                          ),
                        ),
                        avatar: Icon(
                          Icons.add,
                        ),
                        label: Text(
                          'Add More',
                          style: TextStyle(
                            fontFamily: GoloFont,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(
                height: 12.0,
              ),

              // OPENING HOURS
              _buildContainer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(text: 'OPENING HOUR'),
                    ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: openingHours.length,
                      itemBuilder: (lbCtx, index) {
                        final hour = openingHours[index];
                        return _buildOpeningHourRow(
                          openingHour: hour,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //
  // CONTAINER
  //
  Container _buildContainer({
    @required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(
        12.0,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          width: 0.5,
          color: Colors.grey[400],
        ),
      ),
      child: child,
    );
  }

  //
  // HEADER STYLE
  //
  Text _buildHeader({
    @required text,
  }) {
    return Text(
      text,
      style: TextStyle(
        color: Colors.grey[700],
        fontFamily: GoloFont,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  //
  // TEXTFIELD
  //
  Widget _buildTextField({
    @required String labelText,
    String hintText,
    String initialValue,
    TextInputType inputType = TextInputType.name,
    IconData shuffixIcon,
    @required Function(String) validator,
    @required Function(String) onSaved,
  }) {
    return TextFormField(
      initialValue: initialValue,
      autocorrect: false,
      keyboardType: inputType,
      cursorColor: Colors.black,
      decoration: InputDecoration(
        suffixIcon: (shuffixIcon != null)
            ? Icon(
                shuffixIcon,
                color: Colors.grey,
              )
            : null,
        labelText: labelText,
        labelStyle: TextStyle(
          color: Colors.black,
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: GoloColors.primary,
          ),
        ),
        hintText: hintText,
        hintStyle: TextStyle(
          fontSize: 12.0,
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      style: TextStyle(
        fontFamily: GoloFont,
      ),
      validator: validator,
      onSaved: onSaved,
    );
  }

  //
  // BUILD OPENINIG HOUR ROW
  //
  Widget _buildOpeningHourRow({
    @required OpeningHour openingHour,
  }) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Text(
            openingHour.title,
            style: TextStyle(
              fontFamily: GoloFont,
              fontSize: 16.0,
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: _buildTextField(
            labelText: null,
            hintText: openingHour.hintText,
            validator: (text) {},
            onSaved: (text) {},
          ),
        )
      ],
    );
  }

  //
  // BUILD SOCIAL NETWORK ROW
  //
  Widget _buildSocialNetworkRow({
    @required SocialNetwork socialNetwork,
    @required Function onPressed,
  }) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: _buildTextField(
            shuffixIcon: Icons.keyboard_arrow_down,
            labelText: null,
            hintText: socialNetwork.selectNetworkHintText,
            validator: (text) {},
            onSaved: (text) {},
          ),
        ),
        SizedBox(
          width: 8.0,
        ),
        Expanded(
          flex: 1,
          child: _buildTextField(
            labelText: null,
            hintText: socialNetwork.networkURLHintText,
            validator: (text) {},
            onSaved: (text) {},
          ),
        ),
        IconButton(
          icon: Icon(
            Icons.delete,
            color: Colors.grey,
          ),
          onPressed: onPressed,
        ),
      ],
    );
  }
}
