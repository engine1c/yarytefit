import 'package:flutter/material.dart';
import 'package:yarytefit/core/constants.dart';

class SaveButton extends StatelessWidget {
  final Function onPressed;

  SaveButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
    foregroundColor: bgWhite, 
    backgroundColor: Colors.green, // foreground
  ),
              // style: RoundedRectangleBorder(
              //     borderRadius: BorderRadius.circular(0.0),
              //     side: const BorderSide(color: Colors.green)),
              onPressed: () {
                onPressed();
              },
              child:
                  Icon(Icons.save),
            );
  }
}
