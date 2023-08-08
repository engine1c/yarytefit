import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:yarytefit/domain/workout.dart';

class Drill extends StatelessWidget {
  final _formKey = GlobalKey<FormBuilderState>();
  final bool isSingleDrill;
  final int drillBlockIndex;
  final int index;
  final WorkoutDrill drill;

  Drill(
      {Key? key,
      required this.drillBlockIndex,
      required this.index,
      required this.isSingleDrill,
      required this.drill})
      : super(key: key);

  isNumeric(string) =>
      string != null && int.tryParse(string.toString().trim()) != null;
  cleanInt(string) => int.parse(string.toString().trim());

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
       autovalidateMode: AutovalidateMode.disabled,
      key: _formKey,
      child: Card(
        child: Container(
          padding: const EdgeInsets.only(left: 4, right: 4),
          decoration: const BoxDecoration(color: Colors.white54),
          child: Column(
            children: <Widget>[
              FormBuilderTextField(
                style: const TextStyle(color: Colors.black87,),
                initialValue: drill.title,
                enabled: true,
                enableInteractiveSelection: true,
                name: "title_${drillBlockIndex}_$index",
                decoration: InputDecoration(
                  labelText: isSingleDrill ? "Drill *" : "Drill #${index + 1} *",
                ),
                onChanged: (dynamic val) {
                  drill.title = val;
                },
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                  FormBuilderValidators.maxLength(100),
                  // (val) {
                  //   final number = int.tryParse(val!);
                  //   if (number == null) return null;
                  //   if (number < 0) return 'Не больше 100 (2)';
                  //   return null;
                  // }
                ]),
              ),
              FormBuilderTextField(
                style: const TextStyle(color: Colors.black87,),
                initialValue: drill.sets == null ? '' : drill.sets.toString(),
                name: "sets_${drillBlockIndex}_$index",
                decoration: InputDecoration(
                  labelText: isSingleDrill ? "Sets *" : "Sets #${index + 1} *",
                ),
                onChanged: (dynamic val) {
                  if (isNumeric(val)) drill.sets = cleanInt(val);
                },
    
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                  FormBuilderValidators.numeric(
                      errorText: 'Не больше 100 (max_1)'),
                  FormBuilderValidators.max(100),
                  // (val) {
                  //   final number = int.tryParse(val!);
                  //   if (number == null) return null;
                  //   if (number < 0) return 'Не больше!';
                  //   return null;
                  // }
                ]),
                keyboardType: TextInputType.number,
              ),
              FormBuilderTextField(
                style: const TextStyle(color: Colors.black87,),
                initialValue: drill.reps == null ? '' : drill.reps.toString(),
                name: "reps_${drillBlockIndex}_$index",
                decoration: InputDecoration(
                  labelText: isSingleDrill ? "Reps *" : "Reps #${index + 1} *",
                ),
                onChanged: (dynamic val) {
                  if (isNumeric(val)) {
                    drill.reps = cleanInt(val);
                  }
                },
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                  FormBuilderValidators.numeric(
                      errorText: 'Не больше 500 (max_1)'),
                  FormBuilderValidators.max(500),
    
                  // (val) {
                  //   final number = int.tryParse(val!);
                  //   if (number == null) return null;
                  //   if (number < 0) return 'Не больше!';
                  //   return null;
                  // }
                ]),
                // keyboardType: TextInputType.number,
              ),
              FormBuilderTextField(
                style: const TextStyle(color: Colors.black87,),
                initialValue: drill.weight,
                name: "weight_${drillBlockIndex}_$index",
                decoration: InputDecoration(
                  labelText: isSingleDrill ? "Weight" : "Weight #${index + 1}",
                ),
                onChanged: (dynamic val) {
                  drill.weight = val;
                },
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                  FormBuilderValidators.maxLength(100),
                  // (val) {
                  //   final number = int.tryParse(val!);
                  //   if (number == null) return null;
                  //   if (number < 0) return 'Не больше 100 (3)';
                  //   return null;
                  // }
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
