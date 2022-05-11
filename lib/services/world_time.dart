import 'package:http/http.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

class WorldTime {

  String location; // location name for the UI
  String time; // time in that location
  String flag; // url to an asset flag icon
  String url; // location url for api endpoint
  bool isDayTime;

  WorldTime({ this.location = "" , this.time = "", this.flag = "", this.url = "", this.isDayTime = false});

  Future <void> getTime() async {

    try {
      // Make the request
      var apiUrl = Uri.http('worldtimeapi.org', '/api/timezone/$url');

      Response response = await get(apiUrl);

      if(response.statusCode == 200){
        Map data = jsonDecode(response.body);

        // get properties from data.
        String datetime = data['datetime'];
        // Used to determine if offset is negative or positive.
        String actualOffset = data['utc_offset'];
        // Actual offset to be added or subtracted.
        String offset = data['utc_offset'].substring(1, 3);
        // Create a date/time object.
        DateTime now = DateTime.parse(datetime);

        /**
         * @desc    Switch to handle if offset is add or subtract. If someone
         *          has a better way to do this I'm all ears.. er.. fingers..
         */
        switch(actualOffset[0]){
          case '+':
              now = now.add(Duration(hours: int.parse(offset)));
            break;
          case '-':
              now = now.subtract(Duration(hours: int.parse(offset)));
            break;
          default:
              now = now;
            break;
        }


        isDayTime = now.hour > 6 && now.hour < 20 ? true : false;
        time = DateFormat.jm().format(now);

      }
    } catch (err) {
      print(err);
      time = 'could not get time data';
    }
  }


}