import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdaptivePicker extends StatelessWidget implements PreferredSizeWidget{
  
  final List<String> values;
  final String value;
  final Function(String) onChanged;

  const AdaptivePicker({Key key, this.values, this.value, this.onChanged}) : super(key: key);

  static const double _kKeyboardHeight = 300;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        color: Colors.transparent,
        height: _kKeyboardHeight,
        child: CupertinoPicker(
            onSelectedItemChanged: (index){
              if(onChanged!=null) {
                onChanged(values[index]);
              }
            },
            scrollController: FixedExtentScrollController(initialItem: values.contains(value) ? values.indexOf(value) : 0),
            itemExtent: 50,
            children: List.generate(values.length, (index){
              return Container(
                alignment: Alignment.center,
                child: Text(
                  values[index].toString(),
                  style: TextStyle(
                      color: Theme.of(context).primaryColorLight
                  ),
                ),
              );
            })
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(_kKeyboardHeight);
  
}