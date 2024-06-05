import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:debug_logger/debug_logger.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:famici/utils/barrel.dart';

import '../core/blocs/connectivity_bloc/connectivity_bloc.dart';

class AmplifyService {
  static final AmplifyService _singleton = AmplifyService._internal();

  factory AmplifyService() {
    return _singleton;
  }

  AmplifyService._internal();

  final _amplifyAPI = Amplify.API;
  final ConnectivityBloc _connectivity = connectivityBloc;

  final FirebaseCrashlytics _crashlytics = FirebaseCrashlytics.instance;

  bool isInitialized = false;

  Future<GraphQLResponse> query({
    required String document,
    required String apiName,
    Map<String, dynamic>? variables,
  }) async {
    try {
      if (_connectivity.state.hasInternet) {
        final query = _amplifyAPI.query(
          request: GraphQLRequest(
            document: document,
            variables: variables ?? {},
            apiName: apiName,
          ),
        );

        GraphQLResponse response = await query.response;
        if (response.errors.isNotEmpty) {
          _logError(
            graphQLDocument: document,
            apiName: apiName,
            variables: variables,
            err: response.errors.first,
            trace: StackTrace.fromString(document),
          );
        }
        return response;
      } else {
        GraphQLResponse response = const GraphQLResponse(
            errors: [GraphQLResponseError(message: "no internet connection")]);
        return response;
      }
    } on GraphQLResponseError catch (err) {
      _logError(
        graphQLDocument: document,
        apiName: apiName,
        variables: variables,
        err: err,
        trace: StackTrace.fromString(document),
      );
      rethrow;
    } catch (err) {
      rethrow;
    }
  }

  Future<GraphQLResponse> mutate({
    required String document,
    required String apiName,
    Map<String, dynamic>? variables,
  }) async {
    try {
      if (_connectivity.state.hasInternet) {
        final query = _amplifyAPI.mutate(
          request: GraphQLRequest(
            document: document,
            variables: variables ?? {},
            apiName: apiName,
          ),
        );
        GraphQLResponse response = await query.response;
        if (response.errors.isNotEmpty) {
          _logError(
            graphQLDocument: document,
            apiName: apiName,
            variables: variables,
            err: response.errors.first,
            trace: StackTrace.fromString(document),
          );
        }
        return response;
      } else {
        GraphQLResponse response = const GraphQLResponse(
            errors: [GraphQLResponseError(message: "no internet connection")]);
        return response;
      }
    } on GraphQLResponseError catch (err) {
      _logError(
        graphQLDocument: document,
        apiName: apiName,
        variables: variables,
        err: err,
        trace: StackTrace.fromString(document),
      );
      rethrow;
    } catch (err) {
      rethrow;
    }
  }

  _logError({
    required String graphQLDocument,
    required String apiName,
    Map<String, dynamic>? variables,
    GraphQLResponseError? err,
    StackTrace? trace,
  }) async {
    try {
      _crashlytics.recordError(err, trace,
          reason: [graphQLDocument, apiName, variables]);
    } catch (err) {
      DebugLogger.error(err);
    }
  }
}
