import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_info.dart';
import '../golobal.dart';
import '../map_key.dart';
import '../predicted_places.dart';
import '../progress_dialog.dart';
import '../request_assistance.dart';
import 'directions.dart';

class DropOffPlacePredictionTileDesign extends StatefulWidget {

  final PredictedPlaces? predictedPlaces;

  DropOffPlacePredictionTileDesign({this.predictedPlaces});

  @override
  State<DropOffPlacePredictionTileDesign> createState() => _DropOffPlacePredictionTileDesignState();
}

class _DropOffPlacePredictionTileDesignState extends State<DropOffPlacePredictionTileDesign> {
  getPlaceDirectionDetails(String? placeId, context) async {
    showDialog(context: context,
      builder: (BuildContext context) =>
          ProgressDialog(
            message: "Setting Up Drop Off wow",
          ),
    );
    String placeDirectionDetailsUrl = "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$mapKey";

       var responseApi = await RequestAssistant.receiveRequest(placeDirectionDetailsUrl);

       Navigator.pop(context);

       if(responseApi == "Error Occurred, Failed. No Response.")
         {
            return;
         }

       if(responseApi["status"] == "OK")
       {

         Directions directions = Directions();
         directions.locationName = responseApi["result"]["name"];
         directions.locationId = placeId;
         directions.locationLatitude = responseApi["result"]["geometry"]["location"]["lat"];
         directions.locationLongitude =  responseApi["result"]["geometry"]["location"]["lng"];

         Provider.of<AppInfo>(context,listen: false).updateDropOffLocationAddress(directions);

         setState(() {
          userPickUpAddress = directions.locationName!;
         });

         FocusManager.instance.primaryFocus?.unfocus();
         print("dropoff Location is "+userPickUpAddress);
         Navigator.pop(context, "obtainedDropoff");
       }


  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: ()
        {

          getPlaceDirectionDetails(widget.predictedPlaces!.place_id,context);

        },

        style: ElevatedButton.styleFrom(
          primary: Colors.white24,
        ) ,
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Row(
            children:  [
             const Icon(
                Icons.add_location,
                color: Colors.grey,
              ),

            const SizedBox(width: 14.0,),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  const  SizedBox(height: 8.0,),

                    Text(
                      widget.predictedPlaces!.main_text!,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16.0,
                        color: Colors.white54
                      ),
                    ),
                    const SizedBox(height: 2.0,),

                    Text(
                      widget.predictedPlaces!.secondary_text!,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 12.0,
                          color: Colors.white54
                      ),
                    ),

                    const SizedBox(height: 8.0,),
                  ],

                ) ,
              ),

            ],
          ),
        ));
  }
}


