import 'dart:async';

enum AuthEvent {
  logout,
}

class AuthEventBus {
  AuthEventBus._();

  static final AuthEventBus instance =
  AuthEventBus._();

  final StreamController<AuthEvent> _controller =
  StreamController<AuthEvent>.broadcast();

  Stream<AuthEvent> get stream =>
      _controller.stream;

  void addEvent(AuthEvent event) {
    if (!_controller.isClosed) {
      _controller.add(event);
    }
  }

  void dispose() {
    _controller.close();
  }
}