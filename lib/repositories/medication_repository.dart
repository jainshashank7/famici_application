import 'dart:convert';

import 'package:amplify_api/amplify_api.dart';
import 'package:famici/feature/health_and_wellness/my_medication/add_medication/entity/dosage.dart';
import 'package:famici/feature/health_and_wellness/my_medication/add_medication/entity/safety_disclaimer.dart';
import 'package:famici/feature/health_and_wellness/my_medication/entity/medication.dart';
import 'package:famici/feature/health_and_wellness/my_medication/entity/medication_intake_history.dart';
import 'package:famici/feature/health_and_wellness/my_medication/entity/selected_medication_details.dart';

import '../feature/health_and_wellness/my_medication/add_medication/entity/medication_type.dart';
import '../utils/helpers/amplify_helper.dart';
import 'amplify_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MedicationRepository {
  static final MedicationRepository _singleton =
      MedicationRepository._internal();
  bool _hasData = false;

  factory MedicationRepository() {
    return _singleton;
  }

  MedicationRepository._internal();

  final AmplifyService _amplifyAPI = AmplifyService();

  Future<List<Medication>?> fetchMedications({
    required String familyId,
    required String contactId,
    required String date,
  }) async {
    String graphQLDocument =
        '''query GetMedicationList(\$familyId:ID!,\$contactId:String!,\$date:String!) {
      getMedicationList(familyId:\$familyId,contactId:\$contactId,date:\$date) {
        medicationList  {
          createdByUserType
          date
          imageUrl
          medicationId
          medicationName
          nextDosage {
            hasPrompted
            detail
            id
            hasTaken
            quantity
            time
            popUpLabel
          }
          previousDosage {
            hasPrompted
            detail
            id
            quantity
            time
            hasTaken
            popUpLabel
          }
        }      
        contactId
        familyId
      }
    }''';

    GraphQLResponse response = await _amplifyAPI.query(
      document: graphQLDocument,
      variables: {
        "familyId": familyId,
        "contactId": contactId,
        "date": date,
      },
      apiName: AmplifyApiName.defaultApi,
    );

    if (response.errors.isNotEmpty) {
      return null;
    } else {
      List<Medication>? fetchedList =
          (json.decode(response.data)['getMedicationList']['medicationList']
                  as List)
              .map((n) => (Medication.fromJson(n)))
              .toList();

      final prefs = await SharedPreferences.getInstance();
      prefs.setString('${contactId}_medication', response.data);
      return fetchedList;
    }
  }

  Future<SelectedMedicationDetails?> fetchMedicationDetails({
    required String familyId,
    required String medicationId,
    required String date,
  }) async {
    String graphQLDocument =
        '''query GetMedicationDetails(\$familyId:ID!,\$medicationId:String!,\$date:String!) {
      getMedicationDetails(familyId:\$familyId,medicationId:\$medicationId,date:\$date) {
          DEA
          ICD10
          SIG
          additionalDetails
          daw
          daysSupply
          dosageList {
            detail
            hasPrompted
            hasTaken
            id
            quantity
            time
          }
          medicationReminderTime
          durationDays
          effectiveDate
          endDate
          familyId
          height
          heightUnit
          isRemind
          issueTo
          medicationId
          medicationName
          medicationTypeId
          medicationTypeImageUrl
          nextDosageTime
          prescriberInfoAddress
          refills
          prescriberName
          prescriberPhone
          remainingDays
          startDate
          supervisor
          weight
          weightUnit
          medicationType
      }
    }''';

    GraphQLResponse response = await _amplifyAPI.query(
      document: graphQLDocument,
      variables: {
        "familyId": familyId,
        "medicationId": medicationId,
        "date": date,
      },
      apiName: AmplifyApiName.defaultApi,
    );

    if (response.errors.isNotEmpty) {
      return null;
    } else {
      SelectedMedicationDetails? fetchedData =
          SelectedMedicationDetails.fromJson(
        json.decode(response.data)['getMedicationDetails'],
      );
      return fetchedData;
    }
  }

  Future<List> fetchIntakeHistory({
    required String familyId,
    required String contactId,
    required String medicationId,
    required String month,
    required String year,
  }) async {
    String graphQLDocument =
        '''query GetMedicationIntakeHistory(\$familyId:ID!,\$contactId:String!,\$medicationId:String!,\$month:String!,\$year:String!) {
      getMedicationIntakeHistory(familyId:\$familyId,contactId:\$contactId,medicationId:\$medicationId,month:\$month,year:\$year) {
        history  {
          medicationStatus
          date
        }
        remainingDayCount
        missedDayCount
      }
    }''';

    GraphQLResponse response = await _amplifyAPI.query(
      document: graphQLDocument,
      variables: {
        "familyId": familyId,
        "contactId": contactId,
        "medicationId": medicationId,
        "month": month,
        "year": year,
      },
      apiName: AmplifyApiName.defaultApi,
    );

    if (response.errors.isNotEmpty) {
      List<MedicationIntakeHistory>? fetchedList;
      return [fetchedList, "0", "0"];
    } else {
      List<MedicationIntakeHistory>? fetchedList =
          (json.decode(response.data)['getMedicationIntakeHistory']['history']
                  as List)
              .map((n) => (MedicationIntakeHistory.fromJson(n)))
              .toList();
      return [
        fetchedList,
        json.decode(response.data)['getMedicationIntakeHistory']
            ['missedDayCount'],
        json.decode(response.data)['getMedicationIntakeHistory']
            ['remainingDayCount']
      ];
    }
  }

  Future<List<MedicationType>?> fetchMedicationTypes() async {
    final storage = FlutterSecureStorage();
    String graphQLDocument = '''query GetMedicationTypes {
      getMedicationTypes {
        hasQuantity
        imageUrl
        medicationType
        medicationTypeId
        quantityLabel
      }
    }''';

    GraphQLResponse response = await _amplifyAPI.query(
      document: graphQLDocument,
      apiName: AmplifyApiName.defaultApi,
    );
    if (response.errors.isNotEmpty) {
      return null;
    } else {
      List<MedicationType>? fetchedList =
          (json.decode(response.data)['getMedicationTypes'] as List)
              .map((n) => (MedicationType.fromJson(n)))
              .toList();
      if (_hasData == false) {
        String data = jsonEncode(fetchedList);
        await storage.write(key: 'medication_types', value: data);
        _hasData = true;
      }
      return fetchedList;
    }
  }

  Future<SafetyDisclaimer> fetchMedicationSafetyDisclaimer({
    required String familyId,
  }) async {
    String graphQLDocument = '''query GetSafetyDisclaimer(\$familyId:ID!) {
      getSafetyDisclaimer(familyId:\$familyId) {
        config  {
          medicationDisclaimer
        }
        content
      }
    }''';

    GraphQLResponse response = await _amplifyAPI.query(
      document: graphQLDocument,
      variables: {
        "familyId": familyId,
      },
      apiName: AmplifyApiName.defaultApi,
    );

    if (response.errors.isNotEmpty) {
      return SafetyDisclaimer();
    } else {
      return SafetyDisclaimer.fromJson(
        jsonDecode(response.data)['getSafetyDisclaimer'],
      );
    }
  }

  Future<bool> setIntakeHistory({
    required String dosageId,
    required String dosageTakenDate,
    required String familyId,
    required bool hasTaken,
    required String medicationId,
  }) async {
    String graphQLDocument = '''mutation UpdateIntakeHistory(
    \$familyId:ID!,
    \$dosageTakenDate:String!,
    \$dosageId:String!,
    \$hasTaken:Boolean!,
    \$medicationId:String!
    ) {
      updateIntakeHistory(
      familyId:\$familyId,
      dosageTakenDate:\$dosageTakenDate,
      dosageId:\$dosageId,
      hasTaken:\$hasTaken,
      medicationId:\$medicationId,
      ) {
          medicationId
      }
    }''';

    GraphQLResponse response = await _amplifyAPI.mutate(
      document: graphQLDocument,
      variables: {
        "familyId": familyId,
        "dosageTakenDate": dosageTakenDate,
        "dosageId": dosageId,
        "hasTaken": hasTaken,
        "medicationId": medicationId
      },
      apiName: AmplifyApiName.defaultApi,
    );

    if (response.errors.isNotEmpty) {
      return false;
    } else {
      return true;
    }
  }

  Future<dynamic> setMedication(
      {required String familyId,
      required String additionalDetails,
      required List<Dosage> dosageList,
      required String endDate,
      required bool isRemind,
      required String medicationName,
      required String medicationTypeId,
      required String startDate,
      required String contactId,
      required String createdByUserType,
      required String medicationType,
      required String prescriberName,
      String? medicationReminderTime,
      required String issuedTo,
      required String SIG}) async {
    List<dynamic> generateDosageList = [];
    for (var i = 0; i < dosageList.length; i++) {
      generateDosageList.add(DosageInput(
              detail: dosageList[i].detail,
              quantity: int.parse(dosageList[i].quantity.value),
              time: dosageList[i].time)
          .toJson());
    }

    String graphQLDocument = '''mutation CreateMedication(
    \$familyId:ID!,
    \$SIG:String!,
    \$issueTo:String!,
    \$contactId:ID!,
    \$effectiveDate:String!,
    \$medicationType: String!,
    \$additionalDetails:String,
    \$dosageList: [DosageInput],
    \$endDate:String!,
    \$isRemind:Boolean!,
    \$medicationName:String!,
    \$medicationTypeId:ID!,
    \$startDate:String,
    \$createdByUserType: String,
    \$prescriberName: String,
    \$medicationReminderTime: String
    ) {
  createMedication(
    familyId: \$familyId, 
    medication: {
      additionalDetails: \$additionalDetails, 
      dosageList: \$dosageList
      endDate: \$endDate,
      isRemind: \$isRemind, 
      medicationName: \$medicationName, 
      medicationTypeId: \$medicationTypeId, 
      startDate: \$startDate
      SIG: \$SIG
      issueTo: \$issueTo
      contactId: \$contactId
      effectiveDate: \$effectiveDate
      medicationType: \$medicationType,
      createdByUserType: \$createdByUserType
      prescriberName: \$prescriberName
      medicationReminderTime: \$medicationReminderTime
    }) {
    medicationId
  }
}''';

    GraphQLResponse response = await _amplifyAPI.mutate(
      document: graphQLDocument,
      variables: {
        "familyId": familyId,
        "additionalDetails": additionalDetails,
        "dosageList": generateDosageList,
        "endDate": endDate,
        "SIG": SIG,
        "isRemind": isRemind,
        "effectiveDate": startDate,
        "medicationName": medicationName,
        "medicationTypeId": medicationTypeId,
        "startDate": startDate,
        "contactId": contactId,
        "createdByUserType": createdByUserType,
        "medicationType": medicationType,
        "medicationReminderTime": medicationReminderTime,
        "issueTo": issuedTo,
        "prescriberName": prescriberName
      },
      apiName: AmplifyApiName.defaultApi,
    );

    if (response.errors.isNotEmpty) {
      return null;
    } else {
      return json.decode(response.data)["createMedication"]['medicationId'];
    }
  }

  Future<bool> deleteMedication(
      String familyId, String medicationId, String contactId) async {
    String graphQLDocument =
        '''mutation DeleteMedication (\$familyId: ID!,\$medicationId: ID!, \$contactId: ID!) {
            deleteMedication (familyId:\$familyId, medicationId: \$medicationId,contactId : \$contactId)
            {
            medicationId
            }
        }''';

    GraphQLResponse response = await _amplifyAPI.mutate(
      document: graphQLDocument,
      variables: {
        "familyId": familyId,
        "medicationId": medicationId,
        "contactId": contactId
      },
      apiName: AmplifyApiName.defaultApi,
    );

    if (response.errors.isNotEmpty) {
      return false;
    } else {
      return true;
    }
  }

  Future<dynamic> updateMedication(
      {required String familyId,
      required String medicationId,
      required String additionalDetails,
      required List<Dosage> dosageList,
      required String endDate,
      required bool isRemind,
      required String medicationName,
      required String medicationTypeId,
      required String startDate,
      required String contactId,
      required String createdByUserType,
      required String medicationType,
      required String prescriberName,
      String? medicationReminderTime,
      required String issuedTo,
      required String SIG}) async {
    List<dynamic> generateDosageList = [];
    for (var i = 0; i < dosageList.length; i++) {
      generateDosageList.add(DosageInputWithId(
              ID: dosageList[i].id!,
              detail: dosageList[i].detail,
              quantity: int.parse(dosageList[i].quantity.value),
              time: dosageList[i].time)
          .toJson());
    }
    String graphQLDocument = '''mutation UpdateMedication(
    \$medicationId:ID!,
     \$familyId:ID!,
    \$SIG:String!,
    \$issueTo:String!,
    \$contactId:ID!,
    \$effectiveDate:String!,
    \$medicationType: String!,
    \$additionalDetails:String,
    \$dosageList: [UpdateDosageInput],
    \$endDate:String!,
    \$isRemind:Boolean!,
    \$medicationName:String!,
    \$medicationTypeId:ID!,
    \$startDate:String,
    \$prescriberName: String,
    \$medicationReminderTime: String
    ) {
  updateMedication(
    familyId: \$familyId, 
    medicationId: \$medicationId
    medication: {
      SIG: \$SIG,
      medicationName: \$medicationName, 
      issueTo: \$issueTo
      medicationTypeId: \$medicationTypeId, 
      dosageList: \$dosageList
      contactId: \$contactId
      effectiveDate: \$effectiveDate
      endDate: \$endDate, 
      isRemind: \$isRemind, 
      medicationType: \$medicationType,
      prescriberName: \$prescriberName
      medicationReminderTime: \$medicationReminderTime
      additionalDetails: \$additionalDetails, 
      startDate: \$startDate
      SIG: \$SIG
    }) {
    medicationId
  }
}''';

    GraphQLResponse response = await _amplifyAPI.mutate(
      document: graphQLDocument,
      variables: {
        "medicationId": medicationId,
        "familyId": familyId,
        "additionalDetails": additionalDetails,
        "dosageList": generateDosageList,
        "endDate": endDate,
        "SIG": SIG,
        "isRemind": isRemind,
        "effectiveDate": startDate,
        "medicationName": medicationName,
        "medicationTypeId": medicationTypeId,
        "startDate": startDate,
        "contactId": contactId,
        "medicationType": medicationType,
        "medicationReminderTime": medicationReminderTime,
        "issueTo": issuedTo,
        "prescriberName": prescriberName
      },
      apiName: AmplifyApiName.defaultApi,
    );

    if (response.errors.isNotEmpty) {
      return null;
    } else {
      return json.decode(response.data)["updateMedication"]['medicationId'];
    }
  }
}

class DosageInputWithId {
  const DosageInputWithId({
    required this.detail,
    required this.quantity,
    required this.time,
    required this.ID,
  });
  final String ID;
  final String detail;
  final int quantity;
  final String time;

  toJson() {
    return <String, dynamic>{
      "id": ID,
      "detail": detail,
      "quantity": quantity,
      "time": time,
    };
  }
}

class DosageInput {
  const DosageInput({
    required this.detail,
    required this.quantity,
    required this.time,
  });

  final String detail;
  final int quantity;
  final String time;

  toJson() {
    return <String, dynamic>{
      "detail": detail,
      "quantity": quantity,
      "time": time,
    };
  }
}
