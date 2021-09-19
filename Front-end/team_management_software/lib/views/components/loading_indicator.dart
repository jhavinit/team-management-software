import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

Widget loadingIndicator(context){
  return
    Container(
      padding: EdgeInsets.all(20),
      //height: 400,
      width: MediaQuery.of(context).size.width/2.5,
      child: Row(
        children: [

          Expanded(
            child: LoadingIndicator(
                indicatorType: Indicator.lineScaleParty, /// Required, The loading type of the widget
                colors: const [Colors.black12],       /// Optional, The color collections
                strokeWidth: 2,                     /// Optional, The stroke of the line, only applicable to widget which contains line
                //  backgroundColor: Colors.black,      /// Optional, Background of the widget
                pathBackgroundColor: Colors.red   /// Optional, the stroke backgroundColor
            ),
          ),
          SizedBox(width:  MediaQuery.of(context).size.width/50,),
          Expanded(
            child: LoadingIndicator(
                indicatorType: Indicator.lineScaleParty, /// Required, The loading type of the widget
                colors: const [Colors.black12],       /// Optional, The color collections
                strokeWidth: 2,                     /// Optional, The stroke of the line, only applicable to widget which contains line
                //  backgroundColor: Colors.black,      /// Optional, Background of the widget
                pathBackgroundColor: Colors.black   /// Optional, the stroke backgroundColor
            ),
          ),
          SizedBox(width:  MediaQuery.of(context).size.width/50,),
          Expanded(
            child: LoadingIndicator(
                indicatorType: Indicator.lineScaleParty, /// Required, The loading type of the widget
                colors: const [Colors.black12],       /// Optional, The color collections
                strokeWidth: 2,                     /// Optional, The stroke of the line, only applicable to widget which contains line
                //  backgroundColor: Colors.black,      /// Optional, Background of the widget
                pathBackgroundColor: Colors.black   /// Optional, the stroke backgroundColor
            ),
          ),
        ],
      ),
    );
}