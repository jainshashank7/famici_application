import 'package:famici/utils/config/amplifyconfiguration.dart';
/*
  Please make sure all the below env are same so that same env data resides in it only...
*/
class ApiConfig {
  static const dev = "https://dev-api.mobexhealth.com";
  static const internal = "https://internal-api.mobexhealth.com";
  static const prod = "https://pm-api.mobexhealth.com";
  static const uat = "https://uat-pm-api.mobexhealth.com";
  static const demo = "https://development-api.mobexhealth.com";

  static const baseUrl = uat;


  static const devEnv = "dev";
  static const internalEnv = "dev";
  static const uatEnv = "uat";
  static const prodEnv = "prod";

  static const callEnv = uatEnv;

  static String get apiUrl => "https://mr39vfd5ml.execute-api.us-east-1.amazonaws.com/prod"; // API url goes here
  static String get region => "us-east-1";
}

class FirebaseConfig {
  static const dev = "mhh_dev";
  static const internal = "mhh_dev";
  static const uat = "mhh_uat";
  static const prod = "mhh_prod";

  static const current = uat;
}

class AmplifiyEnvConfig {
  static const currentEnv = uat;
}

class MixpanelTokens {
  static const dev = "ac975b9bd0c1a64461fec1c4405d6aa6";
  static const internal = "ac975b9bd0c1a64461fec1c4405d6aa6";
  static const prod = "77d43575f3dbf763d58f00f967786e8b";
  static const uat = "a7eb55cab6fedba36a8066c09f3a4e96";

  static const env = uat;
}

