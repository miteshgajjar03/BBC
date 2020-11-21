import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:getgolo/localization/Localized.dart';
import 'package:getgolo/localization/LocalizedKey.dart';
import 'package:getgolo/modules/setting/colors.dart';
import 'package:getgolo/modules/setting/fonts.dart';
import 'package:getgolo/modules/state/AppState.dart';
import 'package:getgolo/src/entity/Amenity.dart';
import 'package:getgolo/src/entity/Category.dart';
import 'package:getgolo/src/entity/PlaceInitialData.dart';
import 'package:getgolo/src/views/app_bar/bbc_app_bar.dart';
import 'package:getgolo/src/views/myPlaces/selection_screen.dart';

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
  PlaceInitialData objInitialData = PlaceInitialData();
  Future<bool> _future;

  // Text Editing Controllers
  TextEditingController _categoryController = TextEditingController();

  TextEditingController _countryController = TextEditingController();
  TextEditingController _cityController = TextEditingController();

  Country _selectedCountry;
  City _selectedCity;
  List<Category> _selectedCategory = [];

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
        child: FutureBuilder(
          future: _future,
          builder: (fbCtx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Text(
                  'Please wait...',
                  style: TextStyle(
                    fontSize: 22.0,
                    fontFamily: GoloFont,
                  ),
                ),
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
                      onPressed: () {},
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
          onTap: () {},
          child: Container(
            height: 120,
            width: 120,
            decoration: BoxDecoration(
              color: Colors.grey[400],
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Icon(Icons.cloud_upload),
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
            return Container(
              height: oneFourth,
              child: GridView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                //physics: NeverScrollableScrollPhysics(),
                itemCount: 5,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  crossAxisSpacing: 12.0,
                  mainAxisSpacing: 12.0,
                ),
                itemBuilder: (ctx, index) {
                  return Container(
                    height: oneFourth,
                    width: oneFourth,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4.0),
                      child: Stack(
                        children: [
                          Image(
                            image: AssetImage('assets/photos/paris.jpg'),
                            fit: BoxFit.cover,
                            height: oneFourth,
                            width: oneFourth,
                          ),
                          Positioned(
                            top: -8,
                            right: -8,
                            child: IconButton(
                              icon: Icon(
                                Icons.delete,
                                color: Colors.black,
                              ),
                              onPressed: () {
                                print('Delete');
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
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
              onPressed: () {},
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
}
