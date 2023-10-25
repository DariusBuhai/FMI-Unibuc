import 'package:instagram_analytics/components/buttons/adaptive_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'input_done_view.dart';

class AdaptiveSelect extends StatefulWidget {
  final String text;
  String value;
  final List<dynamic> values;
  List<dynamic> keys;
  Function(String) onChanged;
  Function(String) onFinished;

  AdaptiveSelect({Key key,
    this.text = "",
    this.value = "",
    this.onChanged,
    this.onFinished,
    this.keys,
    @required this.values
  }) : super(key: key);

  @override
  State<AdaptiveSelect> createState() => AdaptiveSelectState();
}

class AdaptiveSelectState extends State<AdaptiveSelect>{

  @override
  void initState() {
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

    return AdaptiveTextButton(
        onPressed: ()=>_showAdaptiveSelector(),
        text: "${widget.text} $value",
        fontSize: 14,
    );
  }

  void _showAdaptiveSelector(){
    if(!(widget.values.length>1)) {
      return;
    }
    FocusScope.of(context).requestFocus(FocusNode());
    showModalBottomSheet(
        enableDrag: true,
        context: context,
        builder: (BuildContext builder) {
          return SizedBox(
              height: MediaQuery.of(context).size.height / 3 + 50,
              child: Column(
                children: <Widget>[
                  inputDoneView(context, callback: (){
                    Navigator.pop(context);
                    if(widget.onFinished!=null) {
                      widget.onFinished(widget.value);
                    }
                  }),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 3,
                    child: CupertinoPicker(
                        onSelectedItemChanged: (index){
                          setState(() {
                            widget.value = widget.values[index];
                          });
                          if (widget.onChanged != null) {
                            widget.onChanged(widget.value);
                          }
                        },
                        scrollController: FixedExtentScrollController(initialItem: widget.values.contains(widget.value) ? widget.values.indexOf(widget.value) : 0),
                        itemExtent: 50,

                        children: List.generate(widget.keys.length, (index){
                          return Container(
                            alignment: Alignment.center,
                            child: Text(
                              widget.keys[index].toString(),
                              style: TextStyle(
                                  color: Theme.of(context).primaryColorLight,
                              ),
                            ),
                          );
                        })
                    ),
                  )
                ],
              )
          );
        });
  }

}