import 'package:flutter/material.dart';

class SaveButton extends StatelessWidget {
  final Function onPressed;

  SaveButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
    foregroundColor: Colors.white, 
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
