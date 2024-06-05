import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/screens/template/kiosk/rss_feed/feed.dart';
import '../../../utils/config/color_pallet.dart';
import '../../kiosk_generic/widgets/custom_in_app_webview.dart';
import '../../kiosk_generic/widgets/kiosk_scaffold.dart';
import '../../kiosk_generic/widgets/pdf_viewer_screen.dart';
import '../education_bloc/education_bloc.dart';

class FeedCard extends StatefulWidget {
  final RssFeedItem feed;
  final int rssId;

  const FeedCard({Key? key, required this.feed, required this.rssId})
      : super(key: key);

  @override
  State<FeedCard> createState() => _FeedCardState();
}

class _FeedCardState extends State<FeedCard> {
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    isFavorite =
        context.read<EducationBloc>().state.favorites[widget.feed.id] == 1
            ? true
            : false;
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    // print(widget.feed.toJson());

    return GestureDetector(
      onTap: () async {
        print(widget.feed.link);

        var response = await http.head(Uri.parse(widget.feed.link));
        String? contentType = response.headers['content-type'];

        bool isPDF = (contentType != null &&
            (lookupMimeType('dummy.pdf') == contentType ||
                contentType.contains('application/pdf')));

        if (isPDF) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return PdfViewerScreen(
                    pdfUrl: widget.feed.link,
                    pdfTitle: widget.feed.title,
                    isSensitive: false,
                    sensitiveScreenTimeOut: 30,
                    sensitiveAlertTimeOut: 15);
              },
            ),
          );
        } else {
          Navigator.of(context).push(PageRouteBuilder(
            opaque: false,
            pageBuilder: (BuildContext context, _, __) {
              return KioskScaffold(
                onDashboard: true,
                body: CustomInAppWebView(
                    url: widget.feed.link,
                    isSensitive: false,
                    sensitiveScreenTimeOut: 30,
                    sensitiveAlertTimeOut: 15),
                title: widget.feed.title,
                sensitiveScreenTimeOut: 30,
                sensitiveAlertTimeOut: 15,
                isSensitive: false,
              );
            },
          ));
        }

        // if (isPDF) {
        //   print('The link is a PDF file.');
        //   fcRouter.navigate(PdfViewRoute(
        //     pdfUrl: widget.feed.link,
        //     title: widget.feed.title,
        //     fileId: "",
        //   ));
        // } else {
        //   print('The link is a website.');
        //   fcRouter.navigate(CustomWebViewScreen(
        //     url: widget.feed.link,
        //     title: widget.feed.title,
        //     selectedModule: "Education",
        //     fileId: "",
        //   ));
        // }
      },
      child: BlocBuilder<EducationBloc, EducationState>(
        builder: (context, educationState) {
          return Container(
            width: 0.25 * width,
            padding: EdgeInsets.fromLTRB(
                0.02 * width, 0.008 * height, 0.02 * width, 0.008 * height),
            margin: EdgeInsets.fromLTRB(
                0, 0.015 * height, 0.025 * width, 0.015 * height),
            decoration: BoxDecoration(
              color: Color(0xFFFEFEFF),
              borderRadius: BorderRadius.circular(0.015 * height),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 0,
                  blurRadius: 15,
                  offset: Offset(0, 0.005 * height),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          width: 0.2 * width,
                          height: 0.25 * height,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(0.025 * height),
                          ),
                          child: CachedNetworkImage(
                            imageUrl: widget.feed.imageUrl,
                            // "https://source.unsplash.com/user/c_v_r/200x200",
                            placeholder: (context, url) => SizedBox(
                              child: Shimmer.fromColors(
                                baseColor: ColorPallet.kWhite,
                                highlightColor: ColorPallet.kPrimaryGrey,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(
                                      Icons.photo,
                                      // size: size.height * 0.04,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              margin: EdgeInsets.all(8),
                              width: width * 0.12,
                              height: height * 0.1,
                              decoration: BoxDecoration(
                                  color: ColorPallet.kWhite.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      color: ColorPallet.kPrimaryGrey)),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.photo,
                                  ),
                                  Center(
                                    child: Text(
                                      "No Image",
                                      style: TextStyle(
                                        overflow: TextOverflow.ellipsis,
                                        color: ColorPallet.kGrey,
                                        fontSize: width / 40,
                                        decoration: TextDecoration.none,
                                        fontFamily:
                                            GoogleFonts.poppins().fontFamily,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            fadeInCurve: Curves.easeIn,
                            fadeInDuration: const Duration(milliseconds: 100),
                            // imageUrl: feed.image,
                          ),
                        ),
                        Positioned(
                          top: 22,
                          right: 18,
                          child: Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(0.01 * height),
                                color: ColorPallet.kGrey.withOpacity(0.1)),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  isFavorite = !isFavorite;
                                });
                                context
                                    .read<EducationBloc>()
                                    .add(OnChangeLikeStatus(
                                      rssId: widget.rssId,
                                      status: isFavorite,
                                      feedItemId: widget.feed.id,
                                    ));
                              },
                              child: isFavorite
                                  ? Icon(
                                      Icons.favorite,
                                      size: 0.035 * height,
                                    )
                                  : Icon(Icons.favorite_border,
                                      size: 0.035 * height),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: 0.33 * height,
                      width: width * 0.22,
                      padding:
                          EdgeInsets.symmetric(vertical: 0.10, horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(widget.feed.title,
                              // 'Study Abroad & Career Guidance E x p e rt Tips for Students Tips for Students Tips for Students',
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                  color: Colors.black),
                              maxLines: 3,
                              softWrap: true,
                              overflow: TextOverflow.ellipsis),
                          SizedBox(
                            height: 15,
                          ),
                          Text(
                            widget.feed.description,
                            // 'More privilege can be found in areas with more resources.  More privilege translates More privilege translate sMore privilege translates',
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w400,
                                fontSize: 15,
                                color: Colors.black),
                            maxLines: 5,
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.end,
                //   children: [
                //     SvgPicture.asset(
                //       AssetIconPath.shareIcon,
                //       color: Color(0XFF949494),
                //       height: 0.015 * height,
                //     ),
                //     Text(
                //       '  Share',
                //       style: GoogleFonts.poppins(
                //         fontWeight: FontWeight.w600,
                //         fontSize: width / 40,
                //         color: Color(0XFF949494),
                //       ),
                //     ),
                //     SizedBox(
                //       width: 0.05 * width,
                //     )
                //   ],
                // ),
                Container(
                  height: 30,
                  width: 40,
                  margin: EdgeInsets.only(right: 0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(0.01 * height),
                      color: ColorPallet.kGrey.withOpacity(0.6)),
                  child: Icon(
                    Icons.arrow_forward_rounded,
                    size: 20,
                    color: Colors.white,
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
