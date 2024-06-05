part of 'company_logo_bloc.dart';

@immutable
abstract class CompanyLogoEvent {}

class FetchCompanyLogoEvent extends CompanyLogoEvent {
  FetchCompanyLogoEvent();
}
