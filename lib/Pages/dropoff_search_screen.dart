
import 'package:acetaxiscamberley/dropoff_place_prediction_tile.dart';
import 'package:flutter/material.dart';
import '../map_key.dart';
import '../predicted_places.dart';
import '../request_assistance.dart';


class DropOffSearchScreen extends StatefulWidget {
  const DropOffSearchScreen({super.key});


  @override
  State<DropOffSearchScreen> createState() => _DropOffSearchScreenState();
}

class _DropOffSearchScreenState extends State<DropOffSearchScreen>
{

  List<PredictedPlaces> placesPredictedList = [];

  void findPlaceAutoCompleteSearch(String inputText) async
  {
    if(inputText.length >1)
    {
      String urlAutoCompleteSearch = "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$inputText&key=$mapKey&components=country:UK";

      var responseAutoCompleteSearch = await RequestAssistant.receiveRequest(urlAutoCompleteSearch);

      if(responseAutoCompleteSearch == "Error Occurred, Failed. No Response.")
      {
        return;
      }

      if(responseAutoCompleteSearch["status"] == "OK")
      {
        var placePredictions =  responseAutoCompleteSearch["predictions"];

        var placePredictionsList = (placePredictions as List).map((jsonData) =>PredictedPlaces.fromJson(jsonData)).toList();


        setState(() {

          placesPredictedList = placePredictionsList;

        });
      }
      // print("this is Api Result ");
      // print(responseAutoCompleteSearch);
    }

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [

          //this place ui
          Container(

            height: 180,
            decoration: const BoxDecoration(
              color: Colors.black54,
              boxShadow: [
                BoxShadow(
                  color: Colors.white54,
                  blurRadius: 8,
                  spreadRadius: 0.5,
                  offset: Offset(
                    0.7,
                    0.7,
                  ),
                ),
              ],
            ),

            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(

                children: [
                  const SizedBox(height: 45,),
                  Stack(
                    children: [
                      GestureDetector(
                        onTap: ()
                        {
                          Navigator.pop(context);
                        },

                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.grey,
                        ),
                      ),

                      const Center(
                        child: Text(
                          "Search and Set DropOff Location",
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16.0,),

                  Row(
                    children: [
                      const Icon(
                        Icons.adjust_sharp,
                        color: Colors.grey,
                      ),

                      const SizedBox(height: 18.0,),

                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(

                            onChanged: (valueTyped)
                            {
                              findPlaceAutoCompleteSearch(valueTyped);
                            },


                            decoration: const InputDecoration(
                              hintText: "Search here...",
                              fillColor: Colors.white54,
                              filled: true,
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.only(
                                left: 11.0,
                                top: 8.0,
                                bottom: 8.0,

                              ),

                            ),
                          ),
                        ),
                      ),

                    ],
                  ),
                ],


              ),
            ),


          ),

          //display place predictions result
          (placesPredictedList.length > 0)
              ?Expanded(

            child: ListView.separated(
                itemCount: placesPredictedList.length,
                physics: ClampingScrollPhysics(),
                itemBuilder:(context,index)
                {
                  return  DropOffPlacePredictionTileDesign(
                    predictedPlaces:  placesPredictedList[index],
                  );
                },
                separatorBuilder: (BuildContext context, int index)
                {
                  return const Divider(
                    height: 1,
                    color: Colors.white,
                    thickness: 1,
                  );
                }


            ),

          )
              : Container(),
        ],
      ),

    );
  }
}
