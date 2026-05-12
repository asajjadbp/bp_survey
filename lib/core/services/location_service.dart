import 'package:location/location.dart' as loc;
import 'package:bpsurveys/core/utils/result.dart';
import 'package:get/get.dart';

class LocationService {
  static final loc.Location _location = loc.Location();

  static Future<Result<String>> getCurrentLocation() async {
    bool serviceEnabled;
    loc.PermissionStatus permissionGranted;

    // 1. Handle Location Service
    serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) {
        return Failure("Location services are disabled. Please enable GPS to continue.".tr);
      }
    }

    // 2. Handle Permissions
    permissionGranted = await _location.hasPermission();
    if (permissionGranted == loc.PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != loc.PermissionStatus.granted) {
        return Failure("Location permission denied.".tr);
      }
    }

    if (permissionGranted == loc.PermissionStatus.deniedForever) {
      return Failure("Location permissions are permanently denied. Please enable them in settings.".tr);
    }

    // 3. Get Position
    try {
      loc.LocationData locationData = await _location.getLocation().timeout(
        const Duration(seconds: 5),
      );
      
      if (locationData.latitude == null || locationData.longitude == null) {
        return Failure("Could not retrieve valid location coordinates.".tr);
      }
      
      return Success("${locationData.latitude},${locationData.longitude}");
    } catch (e) {
      return Failure("Could not retrieve location. Please check your GPS signal.".tr);
    }
  }
}
