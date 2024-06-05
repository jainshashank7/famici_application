import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';


import '../../../core/router/router_delegate.dart';
import '../../../utils/config/color_pallet.dart';
import '../../../utils/constants/assets_paths.dart';
import '../education_bloc/education_bloc.dart';

class LinkItem extends StatefulWidget {
  final EducationItem item;

  const LinkItem({super.key, required this.item});

  @override
  State<LinkItem> createState() => _LinkItemState();
}

class _LinkItemState extends State<LinkItem> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () async {
        print(widget.item.link);

        var response = await http.head(Uri.parse(widget.item.link));
        String? contentType = response.headers['content-type'];

        bool isPDF = (contentType != null &&
            (lookupMimeType('dummy.pdf') == contentType ||
                contentType.contains('application/pdf')));

        // if (isPDF) {
        //   print('The link is a PDF file.');
        //   fcRouter.navigate(PdfViewRoute(
        //     pdfUrl: widget.item.link,
        //     title: widget.item.title,
        //     fileId: "",
        //   ));
        // } else {
        //   print('The link is a website.');
        //   fcRouter.navigate(CustomWebViewRoute(
        //     url: widget.item.link,
        //     title: widget.item.title,
        //     selectedModule: "Education",
        //     fileId: "",
        //   ));
        // }
      },
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: 0.025 * width, vertical: 0.01 * height),
        margin: EdgeInsets.only(bottom: height * 0.02),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(0.015 * height),
            color: Color(0xFFE7F1FF),
            border: Border.all(
              color: Color(0XFFC6C5CC),
              width: 2,
            )),
        child: Row(
          children: [
            Center(
              child: CircleAvatar(
                radius: 0.03 * height,
                backgroundColor: Color(0xFFCEE1FC),
                child: widget.item.link.contains("superiorhealthplan")
                    ? Image.asset(
                        AssetIconPath.superiorLink,
                        height: 0.04 * height,
                      )
                    : SvgPicture.asset(
                        AssetIconPath.globeLink,
                        // color: Color(0XFF535763),
                        height: 0.04 * height,
                      ),
              ),
            ),
            SizedBox(
              width: 0.03 * width,
            ),
            Expanded(
              child: Text(
                widget.item.title,
                softWrap: true,
                maxLines: 1,
                style: GoogleFonts.roboto(
                  color: ColorPallet.kThemePrimaryColor,
                  fontSize: width > 500 ? width / 30 : width / 22,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(
              width: 0.03 * width,
            ),
            GestureDetector(
              onTap: () {
                context.read<EducationBloc>().add(OnSetPinStatus(
                      id: widget.item.id,
                      status: 1 - widget.item.status,
                    ));
              },
              child: Container(
                width: 0.04 * height,
                height: 0.04 * height,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.16),
                      spreadRadius: 0,
                      blurRadius: 4,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: widget.item.status == 1
                      ? SvgPicture.asset(
                          AssetIconPath.notPinnedIcon,
                          // color: Color(0XFF535763),
                          width: 0.025 * height,
                          height: 0.025 * height,
                        )
                      : SvgPicture.asset(
                          AssetIconPath.pinnedIcon,
                          // color: Color(0XFF535763),
                          width: 0.025 * height,
                          height: 0.025 * height,
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
