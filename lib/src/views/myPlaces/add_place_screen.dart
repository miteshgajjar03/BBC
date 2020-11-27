import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:getgolo/GeneralMethods/general_method.dart';
import 'package:getgolo/localization/Localized.dart';
import 'package:getgolo/localization/LocalizedKey.dart';
import 'package:getgolo/modules/services/http/Api.dart';
import 'package:getgolo/modules/setting/colors.dart';
import 'package:getgolo/modules/setting/fonts.dart';
import 'package:getgolo/modules/state/AppState.dart';
import 'package:getgolo/src/entity/Amenity.dart';
import 'package:getgolo/src/entity/Category.dart';
import 'package:getgolo/src/entity/PlaceInitialData.dart';
import 'package:getgolo/src/views/app_bar/bbc_app_bar.dart';
import 'package:getgolo/src/views/myPlaces/selection_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:getgolo/modules/services/platform/Platform.dart';
import 'package:progress_dialog/progress_dialog.dart';

class OpeningHour {
  String title;
  String hintText;
  String errorText;
  TextEditingController valueController = TextEditingController();

  OpeningHour({
    this.title,
    this.hintText,
    this.errorText,
  });
}

class SocialNetwork {
  String selectNetworkHintText;
  String networkURLHintText;
  TextEditingController networkController = TextEditingController();
  TextEditingController urlController = TextEditingController();

  SocialNetwork({
    this.selectNetworkHintText,
    this.networkURLHintText,
  });
}

class GalleryImages {
  String imageURL = '';
  File pickedImage;
  GalleryImages({
    this.imageURL,
    this.pickedImage,
  });
}

class AddPlaceScreen extends StatefulWidget {
  @override
  _AddPlaceScreenState createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends State<AddPlaceScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  List<OpeningHour> _openingHours = [];
  List<SocialNetwork> _arrSocialNetwork = [];
  PlaceInitialData objInitialData = PlaceInitialData();

  Future<bool> _future;
  final _imagePicker = ImagePicker();
  File _thumbImage;
  List<GalleryImages> _arrGalleryImages = [];

  Country _selectedCountry;
  City _selectedCity;
  List<Category> _selectedCategory = [];
  List<int> _selectedPlaceType = [];

  // Text Editing Controllers
  TextEditingController _placeNameController = TextEditingController();
  TextEditingController _priceRangeController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  TextEditingController _categoryController = TextEditingController();
  TextEditingController _placeTypeController = TextEditingController();

  TextEditingController _countryController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _addressController = TextEditingController();

  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _websiteController = TextEditingController();

  TextEditingController _videoURLController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Init Arrays
    _setupOpeningHour();
    _initSocialNetwork();

    _future = getDefaultDataFromAPI();
  }

  Future<bool> getDefaultDataFromAPI() async {
    await objInitialData.getInitialAPIData();
    return true;
  }

  //
  // SETUP SOCIAL NETWORK
  //
  _initSocialNetwork() {
    final network = _getSocialNetworkConst();
    _arrSocialNetwork.add(network);
  }

  SocialNetwork _getSocialNetworkConst() {
    return SocialNetwork(
      networkURLHintText: 'Enter url with http or www',
      selectNetworkHintText: 'Select Network',
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
    );
    final tuesday = OpeningHour(
      title: 'Tuesday',
      hintText: 'Ex. 9:00 AM - 5:00 PM',
      errorText: '',
    );
    final wednesday = OpeningHour(
      title: 'Wednesday',
      hintText: 'Ex. 9:00 AM - 5:00 PM',
      errorText: '',
    );
    final thursday = OpeningHour(
      title: 'Thursday',
      hintText: 'Ex. 9:00 AM - 5:00 PM',
      errorText: '',
    );
    final friday = OpeningHour(
      title: 'Friday',
      hintText: 'Ex. 9:00 AM - 5:00 PM',
      errorText: '',
    );
    final saturday = OpeningHour(
      title: 'Saturday',
      hintText: 'Ex. 9:00 AM - 5:00 PM',
      errorText: '',
    );
    final sunday = OpeningHour(
      title: 'Sunday',
      hintText: 'Ex. 9:00 AM - 5:00 PM',
      errorText: '',
    );

    _openingHours.add(monday);
    _openingHours.add(tuesday);
    _openingHours.add(wednesday);
    _openingHours.add(thursday);
    _openingHours.add(friday);
    _openingHours.add(saturday);
    _openingHours.add(sunday);
  }

  //
  // ValidateInput
  //
  _addPlace() async {
    final ctx = _formKey.currentContext;
    if (_placeNameController.text.trim().isEmpty) {
      showSnackBar('Please enter place name', ctx);
    } else if (_descriptionController.text.trim().isEmpty) {
      showSnackBar('Please enter description about your place', ctx);
    } else if (_selectedCategory.length == 0) {
      showSnackBar('Please select category of your place', ctx);
    } else if (_selectedPlaceType.length != 0) {
      showSnackBar('Please select your place type', ctx);
    } else if (_selectedCountry == null || _selectedCountry.id == 0) {
      showSnackBar('Please select country', ctx);
    } else if (_selectedCity == null || _selectedCity.id == 0) {
      showSnackBar('Please select city', ctx);
    } else if (_addressController.text.trim().length == 0) {
      showSnackBar('Please enter your place address', ctx);
    } else if (_emailController.text.trim().length > 0 &&
        !isValidEmail(_emailController.text)) {
      showSnackBar('Please enter valid email id', ctx);
    } else {
      Map<String, dynamic> requestDict = {};
      requestDict['name'] = _placeNameController.text;
      requestDict['slug'] = _placeNameController.text;
      requestDict['description'] = _descriptionController.text;
      requestDict['category'] =
          _selectedCategory.map((e) => e.id).toList().toString();
      requestDict['place_type'] = [123].toString();

      requestDict['country_id'] = _selectedCountry.id;
      requestDict['city_id'] = _selectedCity.id;
      requestDict['address'] = _addressController.text;

      if (_priceRangeController.text.contains('\$')) {
        requestDict['price_range'] = _priceRangeController.text.length;
      } else {
        requestDict['price_range'] = _priceRangeController.text;
      }

      final selectedAmenityIDs = objInitialData.arrAmenity
          .where((amenity) => amenity.isSelected)
          .map((e) => e.id)
          .toList();
      requestDict['amenities'] = selectedAmenityIDs.toString();

      requestDict['lat'] = _selectedCity.latitude;
      requestDict['lng'] = _selectedCity.longitude;

      requestDict['email'] = _emailController.text;
      requestDict['phone_number'] = _phoneController.text;
      requestDict['website'] = _websiteController.text;

      List<Map<String, dynamic>> social = [];
      _arrSocialNetwork.forEach((element) {
        if (element.urlController.text.length > 0) {
          Map<String, dynamic> dictSocial = {};
          dictSocial['name'] = element.networkController.text;
          dictSocial['url'] = element.urlController.text;
          social.add(dictSocial);
        }
      });
      requestDict['social'] = social;

      List<Map<String, dynamic>> opening = [];
      _openingHours.forEach((element) {
        if (element.valueController.text.length > 0) {
          Map<String, dynamic> dictHour = {};
          dictHour['title'] = element.title;
          dictHour['value'] = element.valueController.text;
          opening.add(dictHour);
        }
      });

      requestDict['opening_hour'] = opening;
      requestDict['video'] = _videoURLController.text.trim();

      final progress = ProgressDialog(
        ctx,
        isDismissible: false,
      );

      final arrPickedImages =
          _arrGalleryImages.map((e) => e.pickedImage).toList();
      if (arrPickedImages.length > 0) {
        await progress.show();
        final arrURLs = await _uploadGalleryImage(images: arrPickedImages);
        requestDict['gallery'] = arrURLs;
        print('IMAGE UPLOADED');
      }

      final api = Platform().shared.baseUrl + "app/places/createPlace";

      parseResponse({
        @required ResponseData response,
      }) async {
        await progress.hide();
        try {
          final res = json.decode(response.json) as Map<String, dynamic>;
          if (res['code'] as int == 200) {
            final dictData = res['data'] as Map<String, dynamic>;
            final message = dictData['data'] as String;
            showSnackBar(message, ctx);
            Future.delayed(Duration(seconds: 2)).then(
              (value) {
                _resetCategorySelection();
                Navigator.of(ctx).pop();
              },
            );
          }
        } catch (error) {
          showSnackBar(error.toString(), ctx);
        }
      }

      if (!progress.isShowing()) {
        await progress.show();
      }
      if (_thumbImage != null) {
        print('REQUEST DICT WITH THUMB :: $requestDict');
        final res = await Api.requestPostUploadImage(
          api,
          _thumbImage,
          'thumb',
          requestDict,
        );
        parseResponse(response: res);
      } else {
        print('REQUEST DICT WITHOUT THUMB:: $requestDict');
        requestDict['thumb'] = '';
        final res = await Api.requestPost(
          api,
          requestDict,
          null,
        );
        parseResponse(response: res);
      }
    }
  }

  //
  // Show Social Network Options
  //
  _showSocialNetworkOptions({
    bool showPriceRange = false,
    @required Function(String) selectedNetwork,
  }) {
    final ctx = _formKey.currentContext;
    List<String> arrOptions = [];
    if (showPriceRange) {
      arrOptions = [
        'None',
        'Free',
        '\$',
        '\$\$',
        '\$\$\$',
        '\$\$\$\$',
      ];
    } else {
      arrOptions = [
        'Facebook',
        'Instagram',
        'Twitter',
        'Youtube',
        'Pinterest',
        'Snapchat',
      ];
    }
    showDialog(
      context: ctx,
      barrierDismissible: true,
      builder: (ctx) {
        return GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Material(
            type: MaterialType.card,
            color: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Container(
                      color: Colors.white,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: arrOptions.length,
                        itemBuilder: (lvBuilder, index) {
                          final network = arrOptions[index];
                          return ListTile(
                            title: Text(network),
                            onTap: () {
                              selectedNetwork(network);
                              Navigator.of(context).pop();
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  //
  // RESET CATEGORY SELECTION
  //
  _resetCategorySelection() {
    AppState().categories.forEach((element) {
      element.isSelected = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: buildAppBar(
        title: Localized.of(context).trans(LocalizedKey.addPlace) ?? "",
        showBackButton: true,
        backOnPressed: () {
          _resetCategorySelection();
          Navigator.of(context).pop();
        },
      ),
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: FutureBuilder(
          future: _future,
          builder: (fbCtx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return getCenterInfoWidget(
                message: 'Please wait...',
              );
            }
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Error while fetching resource.\nPlease Try again later!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22.0,
                    fontFamily: GoloFont,
                  ),
                ),
              );
            }
            return Form(
              key: _formKey,
              child: ListView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.all(
                  12.0,
                ),
                children: [
                  // GENERAL
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
                          controller: _placeNameController,
                          labelText: 'Place Name (en)*',
                          hintText: 'Enter your business name',
                          validator: (text) {},
                          onSaved: (text) {},
                        ),
                        // Price Range
                        _buildTextField(
                          isReadOnly: true,
                          controller: _priceRangeController,
                          labelText: 'Price Range',
                          shuffixIcon: Icons.keyboard_arrow_down,
                          hintText: 'Enter your price range',
                          validator: (text) {},
                          onSaved: (text) {},
                          onTap: () {
                            _showSocialNetworkOptions(
                              showPriceRange: true,
                              selectedNetwork: (selectedValue) {
                                setState(() {
                                  _priceRangeController.text = selectedValue;
                                });
                              },
                            );
                          },
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
                          margin: const EdgeInsets.only(top: 8.0),
                          padding: const EdgeInsets.only(
                            top: 0,
                            left: 8.0,
                            right: 8.0,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4.0),
                            border: Border.all(
                              width: 0.5,
                              color: Colors.grey,
                            ),
                          ),
                          child: TextField(
                            controller: _descriptionController,
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
                          controller: _categoryController,
                          labelText: 'Category *',
                          hintText: 'Select Category',
                          isReadOnly: true,
                          validator: (text) {},
                          onSaved: (text) {},
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (ctx) {
                                  return SelectionScreen(
                                    selectionType: SelectionType.category,
                                    objInitialData: objInitialData,
                                    onSelectValue: (arrSelected) {
                                      _setSelectedCategory(
                                        arrSelected: arrSelected,
                                      );
                                    },
                                  );
                                },
                                fullscreenDialog: true,
                              ),
                            );
                          },
                        ),
                        // Place Type
                        _buildTextField(
                          controller: _placeTypeController,
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

                  // AMENITIES
                  _buildContainer(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeader(text: 'AMENITIES'),
                        SizedBox(
                          height: 8.0,
                        ),
                        ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: objInitialData.arrAmenity.length,
                          itemBuilder: (lbCtx, index) {
                            final amenity = objInitialData.arrAmenity[index];
                            return _buildAmenitiesRow(
                              amenity: amenity,
                              onPressed: () {
                                setState(() {
                                  amenity.isSelected = !amenity.isSelected;
                                });
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(
                    height: 12.0,
                  ),

                  // LOCATION
                  _buildContainer(
                    child: _buildLocation(),
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
                          controller: _emailController,
                          labelText: 'Email',
                          hintText: 'Your email address',
                          inputType: TextInputType.emailAddress,
                          validator: (text) {},
                          onSaved: (text) {},
                        ),
                        // Phone
                        _buildTextField(
                          controller: _phoneController,
                          labelText: 'Phone Number',
                          hintText: 'Your phone number',
                          inputType: TextInputType.phone,
                          validator: (text) {},
                          onSaved: (text) {},
                        ),
                        // Website
                        _buildTextField(
                          controller: _websiteController,
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
                          itemCount: _arrSocialNetwork.length,
                          itemBuilder: (lbCtx, index) {
                            final network = _arrSocialNetwork[index];
                            return _buildSocialNetworkRow(
                              socialNetwork: network,
                              onPressed: () {
                                setState(() {
                                  _arrSocialNetwork.removeAt(index);
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
                            _arrSocialNetwork.add(socialRow);
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
                          itemCount: _openingHours.length,
                          itemBuilder: (lbCtx, index) {
                            final hour = _openingHours[index];
                            return _buildOpeningHourRow(
                              openingHour: hour,
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(
                    height: 12.0,
                  ),

                  _buildContainer(
                    child: _buildMedia(),
                  ),

                  const SizedBox(
                    height: 12.0,
                  ),

                  ButtonTheme(
                    height: 50.0,
                    child: RaisedButton(
                      textColor: Colors.white,
                      color: GoloColors.primary,
                      shape: StadiumBorder(),
                      onPressed: () {
                        _addPlace();
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
            );
          },
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
    TextEditingController controller,
    String hintText,
    String initialValue,
    TextInputType inputType = TextInputType.name,
    IconData shuffixIcon,
    bool isReadOnly = false,
    Function() onTap,
    @required Function(String) validator,
    @required Function(String) onSaved,
  }) {
    return TextFormField(
      controller: controller,
      initialValue: initialValue,
      autocorrect: false,
      keyboardType: inputType,
      cursorColor: Colors.black,
      readOnly: isReadOnly,
      onTap: onTap,
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
            color: isReadOnly ? Colors.grey : GoloColors.primary,
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
            controller: openingHour.valueController,
            labelText: null,
            hintText: openingHour.hintText,
            validator: (text) {},
            onSaved: (text) {
              openingHour.valueController.text = text;
            },
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
            controller: socialNetwork.networkController,
            isReadOnly: true,
            shuffixIcon: Icons.keyboard_arrow_down,
            labelText: null,
            hintText: socialNetwork.selectNetworkHintText,
            validator: (text) {},
            onSaved: (text) {},
            onTap: () {
              _showSocialNetworkOptions(selectedNetwork: (selectedValue) {
                setState(() {
                  socialNetwork.networkController.text = selectedValue;
                });
              });
            },
          ),
        ),
        SizedBox(
          width: 8.0,
        ),
        Expanded(
          flex: 1,
          child: _buildTextField(
            controller: socialNetwork.urlController,
            labelText: null,
            hintText: socialNetwork.networkURLHintText,
            validator: (text) {},
            onSaved: (text) {
              socialNetwork.urlController.text = text;
            },
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

  //
  // BUILD AMENITIES
  //
  Widget _buildAmenitiesRow({
    @required Amenity amenity,
    @required Function onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              amenity.isSelected
                  ? Icons.check_box
                  : Icons.check_box_outline_blank,
            ),
            onPressed: onPressed,
          ),
          const SizedBox(
            width: 8.0,
          ),
          Expanded(
            child: Text(
              amenity.name,
              style: TextStyle(
                fontFamily: GoloFont,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  //
  // BUILD LOCATION
  //
  Widget _buildLocation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(text: 'LOCATION'),
        const SizedBox(
          height: 12.0,
        ),
        Text(
          'Place Address *',
          style: TextStyle(
            fontFamily: GoloFont,
            fontSize: 16,
          ),
        ),
        Column(
          children: [
            _buildTextField(
              controller: _countryController,
              labelText: 'Country',
              hintText: 'Select Country',
              shuffixIcon: Icons.keyboard_arrow_down,
              isReadOnly: true,
              validator: (text) {},
              onSaved: (text) {},
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (ctx) {
                      return SelectionScreen(
                        selectionType: SelectionType.country,
                        objInitialData: objInitialData,
                        onSelectValue: (arrSelected) {
                          _setCountrySelected(arrSelected: arrSelected);
                        },
                      );
                    },
                    fullscreenDialog: true,
                  ),
                );
              },
            ),
            _buildTextField(
              controller: _cityController,
              labelText: 'City',
              hintText: 'Select City',
              shuffixIcon: Icons.keyboard_arrow_down,
              isReadOnly: true,
              validator: (text) {},
              onSaved: (text) {},
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (ctx) {
                      return SelectionScreen(
                        selectionType: SelectionType.city,
                        objInitialData: objInitialData,
                        onSelectValue: (arrSelected) {
                          _setCitySelected(arrSelected: arrSelected);
                        },
                      );
                    },
                    fullscreenDialog: true,
                  ),
                );
              },
            ),
            _buildTextField(
              controller: _addressController,
              labelText: 'Full Address',
              hintText: 'Address',
              validator: (text) {},
              onSaved: (text) {},
            ),
          ],
        ),
      ],
    );
  }

  //
  // UPLOAD MEDIA
  //
  Widget _buildMedia() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(text: 'MEDIA'),
        const SizedBox(
          height: 8.0,
        ),
        Text(
          'Thumb image',
          style: TextStyle(
            fontFamily: GoloFont,
            fontSize: 16,
          ),
        ),
        const SizedBox(
          height: 8.0,
        ),
        GestureDetector(
          onTap: () {
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
              },
            );
          },
          child: Container(
            height: 120,
            width: 120,
            decoration: BoxDecoration(
              color: Colors.grey[400],
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: (_thumbImage == null)
                ? Icon(Icons.cloud_upload)
                : ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.file(
                      _thumbImage,
                      fit: BoxFit.cover,
                    ),
                  ),
          ),
        ),
        const SizedBox(
          height: 12.0,
        ),
        Text(
          'Gallery images',
          style: TextStyle(
            fontFamily: GoloFont,
            fontSize: 16,
          ),
        ),
        const SizedBox(
          height: 12.0,
        ),
        LayoutBuilder(
          builder: (lbCtx, constraint) {
            final oneFourth = constraint.maxWidth / 4;
            return (_arrGalleryImages.length > 0)
                ? Container(
                    height: oneFourth,
                    child: GridView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      //physics: NeverScrollableScrollPhysics(),
                      itemCount: _arrGalleryImages.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1,
                        crossAxisSpacing: 12.0,
                        mainAxisSpacing: 12.0,
                      ),
                      itemBuilder: (ctx, index) {
                        final objImage = _arrGalleryImages[index];
                        return Container(
                          height: oneFourth,
                          width: oneFourth,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4.0),
                            child: Stack(
                              children: [
                                (objImage.imageURL.length > 0)
                                    ? Image.network(
                                        objImage.imageURL,
                                        fit: BoxFit.fill,
                                        height: oneFourth,
                                        width: oneFourth,
                                      )
                                    : (objImage.pickedImage != null)
                                        ? Image.file(
                                            objImage.pickedImage,
                                            fit: BoxFit.fill,
                                            height: oneFourth,
                                            width: oneFourth,
                                          )
                                        : null,
                                // Image(
                                //   image: AssetImage('assets/photos/paris.jpg'),
                                //   fit: BoxFit.cover,
                                //   height: oneFourth,
                                //   width: oneFourth,
                                // ),
                                Positioned(
                                  top: -8,
                                  right: -8,
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.close,
                                      color: Colors.black,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _arrGalleryImages.removeAt(index);
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  )
                : Container();
          },
        ),
        const SizedBox(
          height: 8.0,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FlatButton.icon(
              color: Colors.grey[400],
              onPressed: () {
                showImagePickerActionSheet(
                  context: context,
                  selectedOption: (option) {
                    switch (option) {
                      case PhotoPickerOption.camera:
                        _showImagePicker(
                          source: ImageSource.camera,
                          isGalleryImage: true,
                        );
                        break;
                      case PhotoPickerOption.photoLibrary:
                        _showImagePicker(
                          source: ImageSource.gallery,
                          isGalleryImage: true,
                        );
                        break;
                      case PhotoPickerOption.cancel:
                        break;
                    }
                  },
                );
              },
              icon: Icon(Icons.cloud_upload),
              label: Text(
                'Upload Images',
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 12.0,
        ),
        Text(
          'Video',
          style: TextStyle(
            fontFamily: GoloFont,
            fontSize: 16,
          ),
        ),
        const SizedBox(
          width: 8.0,
        ),
        _buildTextField(
          controller: _videoURLController,
          labelText: null,
          hintText: 'Youtube, Vimeo video url',
          validator: (text) {},
          onSaved: (text) {},
        ),
      ],
    );
  }

  //
  // SET SELECTED DATA
  //
  _setCountrySelected({
    @required List<SelectionData> arrSelected,
  }) {
    objInitialData.arrCountries.forEach((element) {
      element.isSelected = false;
    });
    objInitialData.arrCity.forEach((element) {
      element.isSelected = false;
    });

    final selected = arrSelected.firstWhere((element) => element.isSelected);
    final country = objInitialData.arrCountries.firstWhere(
      (ele) => ele.id == selected.id,
    );
    country.isSelected = true;
    _countryController.text = country.name;
    _selectedCountry = country;
  }

  _setCitySelected({
    @required List<SelectionData> arrSelected,
  }) {
    objInitialData.arrCity.forEach((element) {
      element.isSelected = false;
    });
    final selected = arrSelected.firstWhere((element) => element.isSelected);
    final city = objInitialData.arrCity.firstWhere(
      (ele) => ele.id == selected.id,
    );
    city.isSelected = true;
    _selectedCity = city;
    _cityController.text = city.name;
  }

  _setSelectedCategory({
    @required List<SelectionData> arrSelected,
  }) {
    AppState().categories.forEach((element) {
      element.isSelected = false;
    });

    arrSelected.forEach(
      (element) {
        final category =
            AppState().categories.firstWhere((ele) => ele.id == element.id);
        if (category != null) {
          category.isSelected = true;
        }
      },
    );

    final selectedCat =
        AppState().categories.where((e) => e.isSelected).toList();
    _selectedCategory = selectedCat;
    _categoryController.text = _selectedCategory.map((e) => e.name).join(', ');
  }

  //
  // ShowImagePicker
  //
  _showImagePicker({
    @required ImageSource source,
    bool isGalleryImage = false,
  }) async {
    final image = await _imagePicker.getImage(
      source: source,
    );
    if (image != null) {
      setState(() {
        if (isGalleryImage) {
          _arrGalleryImages.add(
            GalleryImages(
              pickedImage: File(image.path),
              imageURL: '',
            ),
          );
        } else {
          _thumbImage = File(image.path);
        }
      });
    }
  }

  //
  // Upload Gallery Image
  //
  Future<List<String>> _uploadGalleryImage({
    @required List<File> images,
  }) async {
    List<String> urls = [];
    final api = Platform().shared.baseUrl + "app/upload-image";

    await Future.forEach(images, (element) async {
      final galleryImg = element as File;
      final response = await Api.requestPostUploadImage(
        api,
        galleryImg,
        'image',
        null,
      );
      try {
        final res = json.decode(response.json) as Map<String, dynamic>;
        print('RES :: $res');
        final resData = res['data'] as Map<String, dynamic>;
        final uploadedURL = resData['data'] as String;
        urls.add(uploadedURL);
      } catch (error) {
        print('ERROR WHILE UPLOADING GALLERY IMAGE :: ${error.toString()}');
      }
    });
    return urls;
  }
}
