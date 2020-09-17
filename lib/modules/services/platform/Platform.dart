
import 'package:getgolo/modules/services/platform/PlatformBase.dart';
import 'package:getgolo/modules/services/platform/lara/lara.dart';

enum PlatformType {
  lara
}

class Platform {
  static final Platform _instance = Platform._internal();

  factory Platform() {
    return _instance;
  }

  // Properties
  var type = PlatformType.lara;
  PlatformBase shared;
  
  Platform._internal() {
    switch (type) {
      case PlatformType.lara:
        shared = Lara();
        break;
    }
  }

  


}