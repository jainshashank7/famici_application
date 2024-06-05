part of 'company_logo_bloc.dart';


class CompanyLogoState extends Equatable {
  const CompanyLogoState({required this.status, required this.companyUrl});

  final String companyUrl;
  final bool status;

  factory CompanyLogoState.initial() {
    return const CompanyLogoState(status: false, companyUrl: "");
  }

  CompanyLogoState copyWith({String? companyUrl, bool? status}) {
    return CompanyLogoState(
      status: status ?? this.status,
      companyUrl: companyUrl ?? this.companyUrl
    );
  }

  @override
  List<Object> get props => [
    status,
    companyUrl,
  ];
}