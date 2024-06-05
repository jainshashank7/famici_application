import 'package:dio/dio.dart';

class FamilyClientApi {
  static final FamilyClientApi _singleton = FamilyClientApi._internal();

  factory FamilyClientApi() {
    return _singleton;
  }

  FamilyClientApi._internal() {
    initialize();
  }

  Dio _dio = Dio();
  Dio _rawDio = Dio();
  Dio _retryDio = Dio();

  // Future<void> refreshToken() async {
  //   final Credential oldCredentials = await Credential.readFromVault();
  //   final Response response = await _rawDio.post(
  //     '/auth/refresh',
  //     data: {
  //       'username': oldCredentials.username,
  //       'refreshToken': oldCredentials.refreshToken,
  //     },
  //   );

  //   if (response.statusCode == 200) {
  //     Credential refreshedCredentials = Credential.fromJson(response.data);
  //     refreshedCredentials.partyRoleId = oldCredentials.partyRoleId;
  //     refreshedCredentials.username = oldCredentials.username;
  //     await refreshedCredentials.storeInVault();
  //   }
  // }

  // Future<Response> _retry(RequestOptions requestOptions) async {
  //   final Credential credential = await Credential.readFromVault();
  //   final options = new Options(
  //     method: requestOptions.method,
  //     headers: {
  //       ...requestOptions.headers,
  //       'Authorization': credential.token,
  //     },
  //   );
  //   return _retryDio.request(
  //     requestOptions.path,
  //     data: requestOptions.data,
  //     queryParameters: requestOptions.queryParameters,
  //     options: options,
  //   );
  // }

  get instance => _dio;

  get raw => _rawDio;

  void initialize() {
    //add headers to the raw instance of dio
    // _rawDio.interceptors.add(
    //   InterceptorsWrapper(
    //     onRequest: (
    //       RequestOptions options,
    //       RequestInterceptorHandler handler,
    //     ) async {
    //       options.path = '$kBaseApiUrl${options.path}';
    //       handler.next(options);
    //     },
    //   ),
    // );
    //add headers to the main dio instance
    // _dio.interceptors.add(
    //   InterceptorsWrapper(
    //     onRequest: (
    //       RequestOptions options,
    //       RequestInterceptorHandler handler,
    //     ) async {
    //       Credential credential = await Credential.readFromVault();
    //       options.headers.addAll({'Authorization': credential.token});
    //       options.path = '$kBaseApiUrl${options.path}';
    //       options.validateStatus =
    //           (status) => status == 200 || status == 201 || status == 202;
    //       handler.next(options);
    //     },
    //     onError: (
    //       DioError error,
    //       ErrorInterceptorHandler handler,
    //     ) async {
    //       try {
    //         if (error.response?.statusCode == 401) {
    //           await refreshToken();
    //           Response res = await _retry(error.requestOptions);
    //           handler.resolve(res);
    //         } else {
    //           handler.reject(error);
    //         }
    //       } catch (err) {
    //         handler.reject(error);
    //       }
    //     },
    //   ),
    // );
  }
}
