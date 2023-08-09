import 'dart:async';

class LoadingWebPageBloc {
  final _loadingController = StreamController<bool>.broadcast();

  Stream<bool> get loadingStream => _loadingController.stream;

  void add(LoadingWebPageEvent event) {
    _loadingController.sink.add(event.loading);
  }

  void dispose() {
    _loadingController.close();
  }
}

class LoadingWebPageEvent {
  final bool loading;

  LoadingWebPageEvent(this.loading);
}
