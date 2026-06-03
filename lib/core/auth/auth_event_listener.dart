import '../../config/routes/app_routers.dart';
import '../../config/routes/route_names.dart';
import 'auth_event_bus.dart';

class AuthEventListener {
  static void init() {
    AuthEventBus.instance.stream.listen((event) {
      if (event == AuthEvent.logout) {
        appRouter.go(RouteNames.login);
      }
    });
  }
}