import 'package:instagram_analytics/utils/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../input_done_view.dart';

class TileSelect extends StatefulWidget {
  final String text;
  String value;
  final IconData icon;
  final Widget child;
  final List<dynamic> values;
  List<dynamic> keys;
  FocusNode focusNode;
  Function(dynamic) onChanged;

  TileSelect({Key key,
    @required this.text,
    this.value = "",
    this.icon,
    this.child,
    this.onChanged,
    this.focusNode,
    @required this.values,
    this.keys,
  }) : super(key: key);

  @override
  State<TileSelect> createState() => TileSelectState();
}

class TileSelectState extends State<TileSelect> {
  final selectNotifier = ValueNotifier<String>("0");

  @override
  void initState() {
    widget.focusNode ??= FocusNode();
    if (!widget.values.contains(widget.value)) {
      widget.value = widget.values[0];
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    widget.keys ??= widget.values;
    dynamic value = "";
    try{
      value = widget.keys[widget.values.indexOf(widget.value)];
    }catch(_){}


    Widget content = Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 0.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              color: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.only(
                  right: 20,
                  top: 10,
                  bottom: 10,
                ),
                child: Icon(
                  widget.icon,
                  color: Theme.of(context).primaryColorLight,
                  size: 20,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(widget.text,
                  style: TextStyle(
                      fontFamily:
                      Theme.of(context).textTheme.headline1.fontFamily,
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).primaryColorLight)),
              Text(
                limitTextValue(value),
                overflow: TextOverflow.fade,
                style: TextStyle(
                    fontSize: 14,
                    fontFamily:
                    Theme.of(context).textTheme.subtitle2.fontFamily,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).textTheme.subtitle2.color),
              )
            ],
          ),
          flex: 5,
        ),
        const SizedBox(width: 7)
      ],
    );

    return GestureDetector(
      onTap: _showSelector,
      child: Container(
        margin: const EdgeInsets.only(
          top: 4,
          bottom: 4,
        ),
        height: 50,
        child: Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(BORDER_RADIUS),
            ),
            child: content),
      ),
    );
  }

  String limitTextValue(String value){
    const length = 25;
    if(value.length>length) {
      value = value.substring(0, length);
    }
    return value;
  }

  void _showSelector() {
    // if (!(widget.values.length > 1)) return;
    FocusScope.of(context).requestFocus(FocusNode());
    showModalBottomSheet(
        enableDrag: true,
        context: context,
        builder: (BuildContext _) {
          return SizedBox(
              height: 350,
              child: Column(
                children: <Widget>[
                  inputDoneView(context, callback: () {
                    Navigator.pop(context);
                  }),
                  SizedBox(
                    height: 300,
                    child: CupertinoPicker(
                        onSelectedItemChanged: (index) {
                          setState(() {
                            widget.value = widget.values[index];
                          });
                          if (widget.onChanged != null) {
                            widget.onChanged(widget.value);
                          }
                        },
                        scrollController: FixedExtentScrollController(
                            initialItem: widget.values.contains(widget.value)
                                ? widget.values.indexOf(widget.value)
                                : 0),
                        itemExtent: 50,
                        children: List.generate(widget.values.length, (index) {
                          return Container(
                            alignment: Alignment.center,
                            child: Text(
                              widget.keys[index].toString(),
                              style: TextStyle(
                                  color: Theme.of(context).primaryColorLight),
                            ),
                          );
                        })),
                  )
                ],
              ));
        });
  }
}
