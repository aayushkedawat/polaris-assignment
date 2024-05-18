import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityCheck {
  static Future<bool> isConnected() async {
    final List<ConnectivityResult> connectivityResult =
        await (Connectivity().checkConnectivity());
    if (connectivityResult.contains(ConnectivityResult.none)) {
      return false;
    }
    return true;
  }
}
