import 'package:amplify_api/amplify_api.dart';
import 'package:famici/feature/calander/entities/appointments_entity.dart';
import 'package:famici/repositories/amplify_service.dart';
import 'package:famici/utils/barrel.dart';
import 'dart:convert';

class AppointmentRepository {
  static final AppointmentRepository _singleton =
      AppointmentRepository._internal();

  factory AppointmentRepository() {
    return _singleton;
  }

  AppointmentRepository._internal();

  final AmplifyService _amplifyAPI = AmplifyService();

  Future<bool> createAppointment({required Appointment appointment}) async {
    String graphQLDocument = '''mutation createAppointment(
    \$appointment:AppointmentInput!,
    \$familyId:ID!,
    ) {
      createAppointment(
        appointment: \$appointment,
        familyId: \$familyId
      ) {
          appointmentId
      }
    }''';

    GraphQLResponse response = await _amplifyAPI.mutate(
      document: graphQLDocument,
      variables: appointment.toCreateInput(),
      apiName: AmplifyApiName.defaultApi,
    );

    if (response.errors.isNotEmpty) {
      throw response.errors.first;
    } else {
      return true;
    }
  }

  Future<bool> updateAppointment({required Appointment appointment}) async {
    String graphQLDocument = '''mutation UpdateAppointment(
    \$appointment: AppointmentUpdateInput!,
    \$appointmentId:ID!,
    \$familyId:ID!,
    ) {
      updateAppointment(
        appointmentId: \$appointmentId,
        appointment: \$appointment,
        familyId: \$familyId
      ) {
          appointmentId
      }
    }''';

    GraphQLResponse response = await _amplifyAPI.mutate(
      document: graphQLDocument,
      variables: appointment.toUpdateInput(),
      apiName: AmplifyApiName.defaultApi,
    );

    if (response.errors.isNotEmpty) {
      throw response.errors.first;
    } else {
      return true;
    }
  }

  Future<Appointment> fetchAppointment({
    String? familyId = '',
    required String appointmentId,
  }) async {
    String graphQLDocument =
        '''query GetAppointment(\$familyId:ID!,\$appointmentId:ID!) {
          getAppointment(familyId:\$familyId,appointmentId:\$appointmentId) {
            appointmentDate
            appointmentId
            appointmentName
            appointmentType
            guests
            guestsMetaData {
              contactId
              givenName
            }
            isAllDay
            location
            note
            reccuranceType
            startTime
            endTime
            taskDescription
          }
        }''';

    GraphQLResponse response = await _amplifyAPI.query(
      document: graphQLDocument,
      variables: {
        "familyId": familyId,
        "appointmentId": appointmentId,
      },
      apiName: AmplifyApiName.defaultApi,
    );

    if (response.errors.isEmpty) {
      Appointment appointment = Appointment.fromJson(
        json.decode(response.data)["getAppointment"],
      );
      return appointment;
    } else {
      return Appointment();
    }
  }

  Future<bool> deleteAppointment({
    String? familyId = '',
    required String appointmentId,
  }) async {
    String graphQLDocument = '''mutation DeleteAppointment(
    \$familyId:ID!,
    \$appointmentId:ID!,
    ) {
      deleteAppointment(
        appointmentId: \$appointmentId,
        familyId: \$familyId
      ) 
    }''';

    GraphQLResponse response = await _amplifyAPI.mutate(
      document: graphQLDocument,
      variables: {
        "familyId": familyId,
        "appointmentId": appointmentId,
      },
      apiName: AmplifyApiName.defaultApi,
    );

    if (response.errors.isNotEmpty) {
      throw response.errors.first;
    } else {
      return true;
    }
  }
}
