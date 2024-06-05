import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MemberProfile extends StatefulWidget {
  const MemberProfile({Key? key}) : super(key: key);

  @override
  State<MemberProfile> createState() => _MemberProfileState();
}

class _MemberProfileState extends State<MemberProfile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("Profile"),
    );
  }
}
