import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:instagram_analytics/components/page_templates/adaptive_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'adaptive_loader.dart';
import 'buttons/adaptive_button.dart';

class ImagesView extends StatefulWidget {

  final List<dynamic> images;
  final Function() onClosed;

  const ImagesView({Key key, @required this.images, @required this.onClosed}) : super(key: key);

  @override
  State<ImagesView> createState() => _ImagesViewState();
}

class _ImagesViewState extends State<ImagesView>{

  int _activePage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        extendBodyBehindAppBar: true,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(AppBar().preferredSize.height),
          child: AdaptiveAppBar(
            automaticallyImplyLeading: false,
            trailing: AdaptiveIconButton(
              onPressed: () {
                if(widget.onClosed!=null) {
                  widget.onClosed();
                }
              },
              icon: Icon(
                CupertinoIcons.xmark,
                color: Theme.of(context).primaryColor,
                size: 25,
              ),
            ),
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.center,
              child: CarouselSlider(
                  items: List.generate(widget.images.length, (index) {
                    return CachedNetworkImage(
                      imageUrl: widget.images[index],
                      fit: BoxFit.contain,
                      width: MediaQuery.of(context).size.width,
                      repeat: ImageRepeat.noRepeat,
                      errorWidget: (_, __, ___) {
                        return Container();
                      },
                      placeholder: (context, url) => Theme(
                          data: ThemeData(brightness: Brightness.dark),
                          child: const AdaptiveLoader()),
                    );
                  }),

                  options: CarouselOptions(
                    viewportFraction: 1,
                    onPageChanged: (page, _){
                      setState(() {
                        _activePage = page;
                      });
                    },
                    initialPage: 0,
                    height: 500,
                    enableInfiniteScroll: widget.images.length > 1,
                    enlargeCenterPage: true,
                    scrollDirection: Axis.horizontal,
                  )),
            ),
            Visibility(
              visible: widget.images.length > 1,
              child: DotsIndicator(
                dotsCount: widget.images.length,
                position: _activePage.toDouble(),
                decorator: DotsDecorator(
                    activeColor: Theme.of(context).primaryColor,
                    activeSize: const Size(18.0, 9.0),
                    activeShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                    color: Colors.white
                ),
              ),
            )
          ],
        ));
  }
}
