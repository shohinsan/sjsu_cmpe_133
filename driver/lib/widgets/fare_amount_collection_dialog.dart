import 'package:driver/global/global.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../global/global.dart';
import '../helper/helper_methods.dart';
import '../screens/new_trip_screen.dart';


class FareAmountCollectionDialog extends StatefulWidget
{
  double? totalFareAmount;

  FareAmountCollectionDialog({this.totalFareAmount});

  @override
  State<FareAmountCollectionDialog> createState() => _FareAmountCollectionDialogState();
}




class _FareAmountCollectionDialogState extends State<FareAmountCollectionDialog>
{
  @override
  Widget build(BuildContext context)
  {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),

      child: Container(
        margin: const EdgeInsets.all(6),
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xF2F2F9F9),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            const SizedBox(height: 20,),

            Text(
              "TRIP FARE AMOUNT (${driverVehicleType!.toUpperCase()})",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 20,),

            const Divider(
              thickness: 4,
              color: Colors.white,
            ),

            const SizedBox(height: 16,),

            Text(
              // "\$ ${HelperMethods.calculateFareAmountFromOriginToDestination(tripDirectionDetails!).toStringAsFixed(2)}",
              widget.totalFareAmount.toString(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 50,
              ),
            ),

            const SizedBox(height: 10,),

            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "This is the total trip amount. Collect!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),

            const SizedBox(height: 10,),

            Padding(
              padding: const EdgeInsets.all(18.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.green,
                ),
                onPressed: ()
                {
                  Future.delayed(const Duration(milliseconds: 2000), ()
                  {
                    SystemNavigator.pop();
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Collect Cash",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      // "\$ ${HelperMethods.calculateFareAmountFromOriginToDestination(directionDetailsInfo!).toStringAsFixed(2)}",
                      "\$  ${widget.totalFareAmount!}",  //
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 4,),

          ],
        ),
      ),
    );
  }
}
