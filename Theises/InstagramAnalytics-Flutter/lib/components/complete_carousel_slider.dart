

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:instagram_analytics/components/tiles/tile_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CompleteCarouselSlider extends StatefulWidget{
  int currentPage;
  final List<Widget> items;
  final List<String> itemsNames;
  final String title;
  final double height;
    CarouselController carouselController;

  CompleteCarouselSlider({Key key,this.title = "", @required this.items, @required this.itemsNames, this.currentPage = 0, @required this.carouselController, @required this.height}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CompleteCarouselSliderState();
}

class _CompleteCarouselSliderState extends State<CompleteCarouselSlider>{

  @override
  void initState() {
    widget.carouselController ??= CarouselController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Expanded(
                child: TileText(
                  padding: const EdgeInsets.only(bottom: 8),
                  text: widget.title
                ),
              ),
              _actionButton()
            ],
          ),
        ),
        CarouselSlider(
            items: widget.items,
            carouselController: widget.carouselController,
            options: CarouselOptions(
              viewportFraction: 1,
              onPageChanged: (_newPage, __){
                setState(() {
                  widget.currentPage = _newPage;
                });
              },
              initialPage: widget.currentPage,
              height: widget.height,
              enableInfiniteScroll: true,
              reverse: false,
              autoPlay: false,
              enlargeCenterPage: false,
              scrollDirection: Axis.horizontal,
            )
        ),
        const SizedBox(height: 5),
        DotsIndicator(
            dotsCount: widget.itemsNames.length,
            position: widget.currentPage.toDouble(),
            decorator: DotsDecorator(
              activeColor: Theme.of(context).primaryColor,
              activeSize: const Size(18.0, 9.0),
              activeShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0))
            ),
            onTap: (position) {
              widget.carouselController.animateToPage(position.toInt(), duration: const Duration(milliseconds: 300));
            }
        )
      ],
    );
  }

  Widget _actionButton(){
    String _text = "";
    int _jumpToPage = (widget.currentPage + 1) % widget.itemsNames.length;
    IconData _icon = CupertinoIcons.arrow_right;

    _text = widget.itemsNames[_jumpToPage];
    if(widget.currentPage==widget.itemsNames.length-1) {
      _icon = CupertinoIcons.arrow_turn_up_left;
    }

    return CupertinoButton(
        onPressed: () => widget.carouselController.animateToPage(_jumpToPage),
        child: Row(
          children: [
            Text(
                _text,
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                ),
            ),
            const SizedBox(width: 5),
            Icon(
              _icon,
              size: 17,
              color: Theme.of(context).primaryColor,
            )
          ],
        ),
    );
  }

}