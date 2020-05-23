import 'package:deadly_timer/utils/common_utils.dart';
import 'package:flutter/material.dart';

class MaterialAddButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 8, bottom: 8, right: 12, left: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        gradient: CommonUtils.appMaterialLinearGradient()),
      child: Text(" + Add Tasks", style:  TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 15)),
    );
  }
}
