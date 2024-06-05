import 'dart:convert';

import 'package:amplify_api/amplify_api.dart';
import 'package:famici/feature/calander/entities/appointments_entity.dart';
import 'package:famici/utils/barrel.dart';

import '../core/offline/local_database/users_db.dart';
import '../feature/calander/blocs/calendar/calendar_bloc.dart';
import 'amplify_service.dart';

class CalendarRepository {
  static final CalendarRepository _singleton = CalendarRepository._internal();

  factory CalendarRepository() {
    return _singleton;
  }

  CalendarRepository._internal();

  final AmplifyService _amplifyAPI = AmplifyService();

  Future<List<Appointment>> fetchAppointments({
    String? familyId,
    String? clientId,
    String? companyId,
    required String startDate,
    required String endDate,
    String? userId,
  }) async {
    // print(familyId);
    // print(clientId);
    // print(companyId);
    // print(startDate);
    // print(endDate);

    String graphQLDocument =
        '''query GetCalendarDetails(\$clientId:String!,\$companyId:String!,\$startDate:String!,\$endDate:String!) {
              getCalendarDetails(clientId:\$clientId,companyId:\$companyId,startDate:\$startDate,endDate:\$endDate) {
                active
                appointment
                appt_id
                appt_notes
                appt_status
                appt_type
                company_id
                dayt_appt_end
                dayt_appt_start
                end
                group_uuid
                isRequired
                office_id
                place_of_service_code
                recurrence_id
                recurrence_rule
                recurring_appt
                recurring_locked
                room
                start
                telehealth
                counselors {
                  id
                  isDisabled
                  name
                }
              }
        }''';

    GraphQLResponse response = await _amplifyAPI.query(
      document: graphQLDocument,
      variables: {
        "startDate": startDate,
        "endDate": endDate,
        "clientId": clientId,
        "companyId": companyId,
      },
      apiName: AmplifyApiName.defaultApi,
    );

    if (response.errors.isNotEmpty) {
      return [];
    }

    final jsonString = json.decode(response.data)["getCalendarDetails"];
    List<Appointment> appointments = Appointment.fromJsonList(jsonString);

    final DatabaseHelperForUsers dbFactory = DatabaseHelperForUsers();
    dbFactory.insertOrUpdateAppointment(clientId ?? "DummyId", response.data);

    return appointments;
  }

  Future<bool> saveICal(
      {required String familyId,
      required String contactId,
      required ICalURL ical}) async {
    var stringM = ical.color.value.toString();
    // int value = int.parse(stringM, radix: 16);
    String graphQLDocument =
        ''' mutation createiCalMeeting(\$contactId: ID!, \$familyId:ID!, \$meetingData: [ICalInput!]!){createiCalMeeting(contactId: \$contactId, familyId: \$familyId, meetingData: \$meetingData)}''';
    GraphQLResponse response = await _amplifyAPI.mutate(
      document: graphQLDocument,
      variables: {
        "familyId": familyId,
        "contactId": contactId,
        "meetingData": [
          {
            "color": stringM,
            "name": ical.name,
            "link": ical.url,
          }
        ]
      },
      apiName: AmplifyApiName.defaultApi,
    );

    if (response.errors.isEmpty) {
      String success = json.decode(response.data)["createiCalMeeting"];
      if (success == "Meeting link has been created") {
        return true;
      }

      return false;
    } else {
      return false;
    }
  }

  Future<bool> updateICal(
      {required String familyId,
      required String contactId,
      required ICalURL ical}) async {
    var stringM = ical.color.value.toString();
    String graphQLDocument =
        ''' mutation updateiCalMeeting(\$calendarId: String!, \$contactId: ID!, \$familyId:ID!, \$ICalInput: ICalInput) { updateiCalMeeting(calendarId:\$calendarId , contactId: \$contactId, familyId: \$familyId, ICalInput: \$ICalInput )}''';
    GraphQLResponse response = await _amplifyAPI.query(
      document: graphQLDocument,
      variables: {
        "calendarId": ical.id,
        "familyId": familyId,
        "contactId": contactId,
        "ICalInput": {
          "color": stringM,
          "name": ical.name,
          "link": ical.url,
        }
      },
      apiName: AmplifyApiName.defaultApi,
    );

    if (response.errors.isEmpty) {
      String success = json.decode(response.data)["updateiCalMeeting"];
      if (success == "Updated Successfully.") {
        return true;
      }

      return false;
    } else {
      return false;
    }
  }

  Future<bool> deleteICal(
      {required String familyId,
      required String contactId,
      required String icalID}) async {
    String graphQLDocument =
        ''' mutation deleteiCalMeeting(\$calendarId: String!, \$contactId: ID!, \$familyId:ID!){ deleteiCalMeeting(calendarId:\$calendarId , contactId: \$contactId, familyId: \$familyId)}
      ''';
    // b0778105-5e13-4b0c-8a1c-d832635cccc1
    GraphQLResponse response = await _amplifyAPI.query(
      document: graphQLDocument,
      variables: {
        "calendarId": icalID,
        "familyId": familyId,
        "contactId": contactId,
      },
      apiName: AmplifyApiName.defaultApi,
    );

    if (response.errors.isEmpty) {
      String success = json.decode(response.data)["deleteiCalMeeting"];
      if (success == "Successfully Deleted.") {
        return true;
      }

      return false;
    } else {
      return false;
    }
  }

  Future<List<ICalURL>> fetchICalList(
      {required String familyId, required String contactId}) async {
    String graphQLDocument =
        ''' query getiCalData(\$familyId:ID!,\$contactId:ID! ){
            getiCalData(familyId: \$familyId, contactId: \$contactId) {
            calendars {
            calendarId
            color
            link
            name
            }
            }
            }
      ''';
    GraphQLResponse response = await _amplifyAPI.query(
      document: graphQLDocument,
      variables: {
        "familyId": familyId,
        "contactId": contactId,
      },
      apiName: AmplifyApiName.defaultApi,
    );

    if (response.errors.isEmpty) {
      List<ICalURL> icals = ICalURL.fromJsonList(
        json.decode(response.data)["getiCalData"]["calendars"],
      );

      return icals;
    } else {
      return [];
    }
  }

  Future<Appointment> fetchAppointment({
    required String familyId,
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
}
