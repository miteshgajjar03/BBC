import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:getgolo/GeneralMethods/general_method.dart';
import 'package:google_maps_webservice/places.dart';

class PlacePickerResponse {
  double latitude = 0;
  double longitude = 0;
  String address = '';

  PlacePickerResponse();
}

class PlacePicker {
  static Future<void> showPlacePicker({
    @required BuildContext context,
    Function(PlacesAutocompleteResponse) onError,
    Function(PlacePickerResponse) response,
  }) async {
    Prediction predication = await PlacesAutocomplete.show(
      context: context,
      apiKey: googleApiKey,
      onError: onError,
      mode: Mode.fullscreen,
      language: "en",
      //components: [Component(Component.country, "fr")],
    );

    final res = await _getLatLong(predication);
    response(res);
  }

  static Future<PlacePickerResponse> _getLatLong(Prediction prediction) async {
    PlacePickerResponse response = PlacePickerResponse();
    if (prediction == null) {
      return response;
    }
    GoogleMapsPlaces _places = GoogleMapsPlaces(
      apiKey: googleApiKey,
    );
    PlacesDetailsResponse detail = await _places.getDetailsByPlaceId(
      prediction.placeId,
    );
    response.latitude = detail.result.geometry.location.lat;
    response.longitude = detail.result.geometry.location.lng;
    response.address = prediction.description;
    return response;
  }
}
