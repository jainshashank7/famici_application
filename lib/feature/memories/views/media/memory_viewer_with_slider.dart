import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:photo_view/photo_view.dart';
import 'package:famici/feature/memories/blocs/memories/memories_bloc.dart';
import 'package:famici/feature/memories/entities/barrel.dart';
import 'package:famici/shared/barrel.dart';
import 'package:famici/shared/edit_icon_button.dart';
import 'package:famici/utils/barrel.dart';

class MemoryViewerWithSlider extends StatelessWidget {
  const MemoryViewerWithSlider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int previous = 0;
    return Scaffold(
      backgroundColor: Color.fromARGB(80, 32, 32, 32),
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              vertical: 48.0,
              horizontal: 80.0,
            ),
            child: BlocBuilder<MemoriesBloc, MemoriesState>(
              buildWhen: (prev, current) {
                previous =
                    prev.memoryViewSliderIndex - current.memoryViewSliderIndex;
                return true;
              },
              builder: (context, MemoriesState state) {
                return AnimatedSwitcher(
                  duration: Duration(milliseconds: 400),
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                    return SlideTransition(
                      position: Tween<Offset>(
                        end: Offset.zero,
                        begin: Offset(previous.sign * 1.0, 0.0),
                      ).animate(animation),
                      child: child,
                    );
                  },
                  child: state.media[state.memoryViewSliderIndex].type ==
                          MemoryType.photo
                      ? Stack(
                          children: [
                            Center(
                              child: PhotoView(
                                customSize: Size(
                                  MediaQuery.of(context).size.width - 160,
                                  MediaQuery.of(context).size.height - 96,
                                ),
                                minScale: PhotoViewComputedScale.contained,
                                initialScale:
                                    PhotoViewComputedScale.contained * 0.8,
                                tightMode: true,
                                imageProvider: getImageProvider(state
                                    .media[state.memoryViewSliderIndex].url!),
                              ),
                            ),
                            // (
                            //   right: -39,
                            //   top: -10,
                            //   child: CloseIconButton(),
                            // ),
                          ],
                        )
                      : FCVideoPlayer(
                          videoUrl:
                              state.media[state.memoryViewSliderIndex].url!,
                        ),
                );
              },
            ),
          ),
          const Align(
            alignment: Alignment.topRight,
            child: CloseIconButton(
              size: 50,
              boxed: true,
              margin: EdgeInsets.all(10),
              color: Color.fromARGB(255, 255, 255, 255),
            ),
          ),
          BlocBuilder<MemoriesBloc, MemoriesState>(
              builder: (context, state){
                return (state.media[state.memoryViewSliderIndex].type == MemoryType.photo) ?
                  const Align(
                    alignment: Alignment.bottomRight,
                    child: EditIconButton(
                      size: 50,
                      boxed: true,
                      margin: EdgeInsets.only(left: 10, top: 10, right: 10, bottom: 10),
                      color: Color.fromARGB(255, 255, 255, 255),
                    ),
                  ) : const SizedBox(width: 0,height: 0);
              }
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: BlocBuilder<MemoriesBloc, MemoriesState>(
              builder: (context, MemoriesState state) {
                return InkWell(
                  borderRadius: BorderRadius.circular(40.0),
                  onTap: (){
                    context.read<MemoriesBloc>().add(ShowPreviousMemory());
                  },
                  child: state.memoryViewSliderIndex != 0
                      ? Container(
                          padding: EdgeInsets.only(
                            left: 24.0,
                            right: 8.0,
                            top: 16.0,
                            bottom: 16.0,
                          ),
                          width: 90,
                          height: 90,
                          decoration: BoxDecoration(shape: BoxShape.circle),
                          child: FittedBox(
                            child: Icon(
                              Icons.arrow_back_ios,
                              color: Colors.white,
                              // size: 64.0,
                            ),
                          ),
                        )
                      : SizedBox.shrink(),
                );
              },
            ),
          ),
          BlocBuilder<MemoriesBloc, MemoriesState>(
              builder: (context, MemoriesState state) {
            return state.memoryViewSliderIndex != state.media.length - 1
                ? Container(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(40.0),
                      onTap: () {
                        context.read<MemoriesBloc>().add(ShowNextMemory());
                      },
                      child: Container(
                        width: 90,
                        height: 90,
                        padding: EdgeInsets.all(16.0),
                        child: FittedBox(
                          child: Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  )
                : SizedBox.shrink();
          }),
        ],
      ),
    );
  }
}
