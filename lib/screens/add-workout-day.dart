import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:yarytefit/components/common/save-button.dart';
import 'package:yarytefit/components/common/toast.dart';
import 'package:yarytefit/components/drill/drill-remove-alert.dart';
import 'package:yarytefit/components/drill/drill.dart';
import 'package:yarytefit/core/constants.dart';
import 'package:yarytefit/domain/workout.dart';

class AddWorkoutDay extends StatefulWidget {
  final WorkoutWeekDay day;
  AddWorkoutDay({Key? key, required this.day}) : super(key: key);

  @override
  _AddWorkoutDayState createState() => _AddWorkoutDayState();
}

class _AddWorkoutDayState extends State<AddWorkoutDay> {
   final _formKey = GlobalKey<FormBuilderState>();
  WorkoutWeekDay day = WorkoutWeekDay(drillBlocks: [], notes: '');

  @override
  void initState() {
    day = widget.day.copy();

    if (day.drillBlocks.isEmpty) {
      day.drillBlocks = [
        WorkoutSingleDrillBlock(
            drill: WorkoutDrill())
      ];
    }

    super.initState();
  }

  final _fbKey = GlobalKey<FormBuilderState>();
  String _defaultNewDrillType = 'Single Drill';

  final _drillTypeMenuItems = <String>[
    'Rest',
    'Single Drill',
    'Multiset Drill',
    'For Time',
    'AMRAP',
    'EMOM',
  ]
      .map((String value) => DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          ))
      .toList();

void _addDrillsBlock() {
  WorkoutDrillsBlock newBlock;
  switch (_defaultNewDrillType) {
    case 'Single Drill':
      newBlock = WorkoutSingleDrillBlock(
          drill: WorkoutDrill());
      break;
    case 'Multiset Drill':
      newBlock = WorkoutMultisetDrillBlock(drills: [
        WorkoutDrill(),
        WorkoutDrill()
      ]);
      break;
    case 'For Time':
      newBlock = WorkoutForTimeDrillBlock(drills: [
        WorkoutDrill(),
        WorkoutDrill()
      ], timeCapMin: 10, rounds: 2, restBetweenRoundsMin: 1);
      break;
    case 'AMRAP':
      newBlock = WorkoutAmrapDrillBlock(drills: [
        WorkoutDrill(),
        WorkoutDrill()
      ], minutes: 10);
      break;
    case 'EMOM':
      newBlock = WorkoutEmomDrillBlock(drills: [
        WorkoutDrill(),
        WorkoutDrill()
      ], timeCapMin: 10, intervalMin: 1);
      break;
    case 'Rest':
      newBlock = WorkoutRestDrillBlock(timeMin: 5);
      break;
    default:
      newBlock = WorkoutSingleDrillBlock(
          drill: WorkoutDrill());
      break;
  }

  setState(() {
    day.drillBlocks.add(newBlock);
  });
}


  void _newDrillTypeDialog() {
    var alert = AlertDialog(
      title: const Text("Select Drill Type"),
      content: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Drill Type'),
              items: _drillTypeMenuItems,
              value: _defaultNewDrillType,
              onChanged: (String? val) =>
                  setState(() => _defaultNewDrillType = val!),
              style: TextStyle(color: Colors.black),
            ),
          ],
        );
      }),
      actions: <Widget>[
        TextButton(
            onPressed: () {
              _addDrillsBlock();
              Navigator.pop(context);
            },
            child: const Text('Select')),
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'))
      ],
    );
    showDialog(context: context, builder: (_) => alert);
  }

  void _saveDayPlan() {
    if (_fbKey.currentState!.saveAndValidate()) {
      if (day.drillBlocks.isNotEmpty) {
        print(day.drillBlocks.whereType<WorkoutRestDrillBlock>().length);
        if (day.drillBlocks.whereType<WorkoutRestDrillBlock>().length ==
            day.drillBlocks.length) {
          buildToast('Please add at least one Drill');
          return;
        }
      }

      Navigator.of(context).pop(day);
    } else {
      buildToast('Ooops! Что-то неправильно');
    }
  }

  void _removeDrill(WorkoutDrillsBlock block) {
    setState(() {
      day.drillBlocks.remove(block);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('yarytefit // Create Day Plan'),
        actions: <Widget>[
          SaveButton(onPressed: _saveDayPlan),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        onPressed: _newDrillTypeDialog,
        child: const Icon(Icons.add),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(color: bgColorWhite),
          child: FormBuilder(
            key: _fbKey,
            autovalidateMode: AutovalidateMode.disabled,
            initialValue: {},
            enabled: false,
            child: Column(
                children: day.drillBlocks.map((block) {
              var index = day.drillBlocks.indexOf(block);
              return _buildDrillsBlock(index, block);
            }).toList()),
          ),
        ),
      ),
    );
  }

  Widget _buildDrillsBlock(int blockIndex, WorkoutDrillsBlock block) {
    return Container(
      child: Card(
        elevation: 2.0,
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        child: Container(
          decoration:
              BoxDecoration(color: _getDrillBlockHeaderColor(context, block)),
          child: Column(
            children: <Widget>[
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                title: Row(children: <Widget>[
                  Text(_getDrillBlockHeader(block),
                      style: TextStyle(
                          color: Theme.of(context).textTheme.titleLarge!.color,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(width: 20),
                  _canSelectDrillsCount(block)
                      ? DropdownButton(
                          items: Iterable<int>.generate(5)
                              .map((val) => DropdownMenuItem(
                                    value: _isMultisetWorkout(block)
                                        ? val + 2
                                        : val + 1,
                                    child: Text(
                                        '${_isMultisetWorkout(block) ? (val + 2) : (val + 1)} Drills'),
                                  ))
                              .toList(),
                          onChanged: (val) {
                            setState(() {
                              block.changeDrillsCount(val!);
                            });
                          },
                          value: block.drills.length,
                          style: const TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                        )
                      : const SizedBox.shrink()
                ]),
                trailing: IconButton(
                  icon: const Icon(Icons.remove_circle),
                  color: Colors.red,
                  onPressed: () async {
                    var result = await showDialog(
                        context: context,
                        builder: (_) => drillRemoveAlert(context));
                    if (result) _removeDrill(block);
                  },
                ),
              ),
              Column(
                children: <Widget>[
                  _buildDrillBlockParams(blockIndex, block),
                  _buildDrills(blockIndex, block)
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  isNumeric(string) =>
      string != null && int.tryParse(string.toString().trim()) != null;
  cleanInt(string) => int.parse(string.toString().trim());

  Widget _buildDrills(int blockIndex, WorkoutDrillsBlock block) {
    return Column(
        children: Iterable<int>.generate(block.drills.length)
            .map(
              (ind) => Drill(
                isSingleDrill: block.drills.length <= 1,
                drillBlockIndex: blockIndex,
                index: ind,
                drill: block.drills[ind],
              ),
            )
            .toList());
  }

  Widget _buildDrillBlockParams(int index, WorkoutDrillsBlock block) {
       if (block is WorkoutAmrapDrillBlock) {
      return FormBuilder(
        key: _formKey,
        child: Card(
          child: Column(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.only(left: 4, right: 4),
                child: FormBuilderTextField(
                  initialValue:
                      block.minutes == null ? '' : block.minutes.toString(),
                  name: "minutes_$index",
                  decoration: const InputDecoration(
                    labelText: "Minutes *",
                  ),
                  onChanged: (dynamic val) {
                    if (isNumeric(val)) block.minutes = cleanInt(val);
                  },
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                    FormBuilderValidators.numeric(
                        errorText: 'Не больше 100 (max_21)'),
                    FormBuilderValidators.max(100),
                    (val) {
                      final number = int.tryParse(val!);
                      if (number == null) return null;
                      if (number < 0) return 'Не больше!';
                      return null;
                    }
                  ]),
                  // validator: [
                  //   FormBuilderValidators.required(),
                  //   FormBuilderValidators.max(100),
                  //   FormBuilderValidators.numeric(),
                  // ],
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
        ),
      );
    } else if (block is WorkoutForTimeDrillBlock) {
      return Card(
        child: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(left: 4, right: 4),
              child: FormBuilderTextField(
                initialValue:
                    block.timeCapMin == null ? '' : block.timeCapMin.toString(),
                name: "timeCapMin_$index",
                decoration: const InputDecoration(
                  labelText: "Time Cap in minutes *",
                ),
                onChanged: (dynamic val) {
                  if (isNumeric(val)) block.timeCapMin = cleanInt(val);
                },
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                  FormBuilderValidators.numeric(
                      errorText: 'Не больше 100 (max_22)'),
                  FormBuilderValidators.max(100),
                  (val) {
                    final number = int.tryParse(val!);
                    if (number == null) return null;
                    if (number < 0) return 'Не больше!';
                    return null;
                  }
                ]),
                // validator: [
                //   FormBuilderValidators.required(),
                //   FormBuilderValidators.max(100),
                //   FormBuilderValidators.numeric(),
                // ],
                keyboardType: TextInputType.number,
              ),
            ),
            Container(
              padding: const EdgeInsets.only(left: 4, right: 4),
              child: FormBuilderTextField(
                initialValue:
                    block.rounds == null ? '' : block.rounds.toString(),
                name: "rounds_$index",
                decoration: const InputDecoration(
                  labelText: "Rounds *",
                ),
                onChanged: (dynamic val) {
                  if (isNumeric(val)) block.rounds = cleanInt(val);
                },
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                  FormBuilderValidators.numeric(
                      errorText: 'Не больше 100 (max_23)'),
                  FormBuilderValidators.max(100),
                  (val) {
                    final number = int.tryParse(val!);
                    if (number == null) return null;
                    if (number < 0) return 'Не больше!';
                    return null;
                  }
                ]),
                // validator: [
                //   FormBuilderValidators.required(),
                //   FormBuilderValidators.max(100),
                //   FormBuilderValidators.numeric(),
                // ],
                keyboardType: TextInputType.number,
              ),
            ),
            Container(
              padding: const EdgeInsets.only(left: 4, right: 4),
              child: FormBuilderTextField(
                initialValue: block.restBetweenRoundsMin == null
                    ? ''
                    : block.restBetweenRoundsMin.toString(),
                name: "restBetweenRoundsMin_$index",
                decoration: const InputDecoration(
                  labelText: "Rest between rounds in minutes *",
                ),
                onChanged: (dynamic val) {
                  if (isNumeric(val)) {
                    block.restBetweenRoundsMin = cleanInt(val);
                  }
                },
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                  FormBuilderValidators.numeric(
                      errorText: 'Не больше 100 (max_24)'),
                  FormBuilderValidators.max(100),
                  (val) {
                    final number = int.tryParse(val!);
                    if (number == null) return null;
                    if (number < 0) return 'Не больше!';
                    return null;
                  }
                ]),
                // validator: [
                //   FormBuilderValidators.required(),
                //   FormBuilderValidators.max(100),
                //   FormBuilderValidators.numeric(),
                // ],
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
      );
    } else if (block is WorkoutEmomDrillBlock) {
      return Card(
        child: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(left: 4, right: 4),
              child: FormBuilderTextField(
                initialValue:
                    block.timeCapMin == null ? '' : block.timeCapMin.toString(),
                name: "timeCapMin_$index",
                decoration: const InputDecoration(
                  labelText: "Time Cap in minutes *",
                ),
                onChanged: (dynamic val) {
                  if (isNumeric(val)) block.timeCapMin = cleanInt(val);
                },
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                  FormBuilderValidators.numeric(
                      errorText: 'Не больше 100 (max_25)'),
                  FormBuilderValidators.max(100),
                  (val) {
                    final number = int.tryParse(val!);
                    if (number == null) return null;
                    if (number < 0) return 'Не больше!';
                    return null;
                  }
                ]),
                // validator: [
                //   FormBuilderValidators.required(),
                //   FormBuilderValidators.max(100),
                //   FormBuilderValidators.numeric(),
                // ],
                keyboardType: TextInputType.number,
              ),
            ),
            Container(
              padding: const EdgeInsets.only(left: 4, right: 4),
              child: FormBuilderTextField(
                initialValue: block.intervalMin == null
                    ? ''
                    : block.intervalMin.toString(),
                name: "intervalMin_$index",
                decoration: const InputDecoration(
                  labelText: "Interval length in minutes *",
                ),
                onChanged: (dynamic val) {
                  if (isNumeric(val)) block.intervalMin = cleanInt(val);
                },
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                  FormBuilderValidators.numeric(
                      errorText: 'Не больше 100 (max_26)'),
                  FormBuilderValidators.max(100),
                  (val) {
                    final number = int.tryParse(val!);
                    if (number == null) return null;
                    if (number < 0) return 'Не больше!';
                    return null;
                  }
                ]),
                // validator: [
                //   FormBuilderValidators.required(),
                //   FormBuilderValidators.max(100),
                //   FormBuilderValidators.numeric(),
                // ],
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
      );
    } else if (block is WorkoutRestDrillBlock) {
      return Card(
        child: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(left: 4, right: 4),
              child: FormBuilderTextField(
                initialValue:
                    block.timeMin == null ? '' : block.timeMin.toString(),
                name: "timeMin_$index",
                decoration: const InputDecoration(
                  labelText: "Minutes *",
                ),
                onChanged: (dynamic val) {
                  if (isNumeric(val)) block.timeMin = cleanInt(val);
                },
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                  FormBuilderValidators.numeric(
                      errorText: 'Не больше 100 (max_27)'),
                  FormBuilderValidators.max(100),
                  (val) {
                    final number = int.tryParse(val!);
                    if (number == null) return null;
                    if (number < 0) return 'Не больше!';
                    return null;
                  }
                ]),
                // validator: [
                //   FormBuilderValidators.required(),
                //   FormBuilderValidators.max(100),
                //   FormBuilderValidators.numeric(),
                // ],
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
      );
    }

    return const SizedBox.shrink();
  }

  Color _getDrillBlockHeaderColor(
      BuildContext context, WorkoutDrillsBlock block) {
    if (block is WorkoutRestDrillBlock)
      return const Color.fromRGBO(80, 150, 70, 0.9);

    return const Color.fromRGBO(50, 65, 85, 0.9);
  }

  String _getDrillBlockHeader(WorkoutDrillsBlock block) {
    if (block is WorkoutAmrapDrillBlock) {
      return 'AMRAP';
    } else if (block is WorkoutForTimeDrillBlock) {
      return 'For Time';
    } else if (block is WorkoutEmomDrillBlock) {
      return 'EMOM';
    } else if (block is WorkoutMultisetDrillBlock) {
      return 'Multi Drill';
    } else if (block is WorkoutSingleDrillBlock) {
      return 'Single Drill';
    } else if (block is WorkoutRestDrillBlock) {
      return 'Rest';
    }

    return '';
  }

  bool _canSelectDrillsCount(WorkoutDrillsBlock block) =>
      !(block is WorkoutRestDrillBlock || block is WorkoutSingleDrillBlock);

  bool _isMultisetWorkout(WorkoutDrillsBlock block) =>
      block is WorkoutMultisetDrillBlock;
}
