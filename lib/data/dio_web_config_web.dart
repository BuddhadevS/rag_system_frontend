import 'package:dio/browser.dart';
import 'package:dio/dio.dart';

/// Silence Dio's per-request CORS preflight notice on web.
///
/// JSON POSTs (e.g. `/query`) are not CORS "simple requests", so the browser
/// always sends OPTIONS first. Our Spring API already allows those origins and
/// headers — the log is noise, not a failure.
void configureWebDio(Dio dio) {
  dio.httpClientAdapter = BrowserHttpClientAdapter(
    enableCORSWarning: false,
  );
}
