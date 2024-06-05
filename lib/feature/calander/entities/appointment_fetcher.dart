import 'appointments_entity.dart';

class AppointmentFetcher{
  static final AppointmentFetcher _instance = AppointmentFetcher._internal();

  factory AppointmentFetcher() {
    return _instance;
  }

  List<Appointment> appointments = [];

  AppointmentFetcher._internal();


  List<Appointment> fetch(){
    return appointments;
  }

  void addAppointments(List<Appointment> app){
    // print(app);
    // appointments = app;
  }

}

