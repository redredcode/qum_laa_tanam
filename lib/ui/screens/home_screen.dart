import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:qum_la_tanam/ui/widgets/taskInputRow.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TimeOfDay _fajrTimeStartsAt = const TimeOfDay(hour: 4, minute: 53);
  void _showTimePicker() {
    showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    ).then((value){
      setState(() {
        _fajrTimeStartsAt =value!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //leading: Icon(Iconsax.moon5),
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 20,
            ),
            Icon(Iconsax.moon5),
            SizedBox(
              width: 5,
            ),
            Text(
              'Qum la Tanam!',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 28,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.settings),
          ),
        ],
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(26.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  'Time you want to spend in...',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
              // Container(
              //   color: Colors.grey.shade300,
              //   width: 300,
              //   height: 200,
              // ),
              const SizedBox(
                height: 20,
              ),
              const TaskInputRow(label: 'Qiyam'),
              const SizedBox(
                height: 5,
              ),
              const TaskInputRow(label: 'Study'),
              const SizedBox(
                height: 5,
              ),
              const TaskInputRow(label: 'Suhoor'),
              const SizedBox(
                height: 5,
              ),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                      color: Colors.grey,
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8))),
                onPressed: () {},
                child: const Text(
                  'Add another task',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              const SizedBox(
                height: 10,
              ),

              Row(
                children: [
                  const Text('Time needed to \nfully wake up'),
                  const SizedBox(
                    width: 25,
                  ),
                  const Icon(Iconsax.arrow_square_right3),
                  const SizedBox(
                    width: 25,
                  ),
                  SizedBox(
                    width: 100,
                    height: 35,
                    child: TextFormField(
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: '0 mins',
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.amber,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),

              // the info icon
              const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info,
                    size: 20,
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              const Divider(
                color: Colors.grey,
              ),
              const SizedBox(
                height: 5,
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('Total time needed'),
                  Text('40 minutes'),
                ],
              ),
              Row(
                children: [
                  const Text('Fajr starts at'),
                  const SizedBox(
                    width: 25,
                  ),
                  const Icon(Iconsax.arrow_square_right3),
                  const SizedBox(
                    width: 25,
                  ),
                  GestureDetector(
                    onTap: _showTimePicker,
                    child: Container(
                      width: 75,
                      height: 35,
                      //color: Colors.red,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.grey
                        ),
                      ),
                      child: Align(
                        child: Text(_fajrTimeStartsAt.format(context).toString()),
                      ),
                    ),
                  )
                  // SizedBox(
                  //   width: 100,
                  //   height: 35,
                  //   child: TextFormField(
                  //     inputFormatters: <TextInputFormatter>[
                  //       FilteringTextInputFormatter.digitsOnly
                  //     ],
                  //     keyboardType: TextInputType.number,
                  //     decoration: InputDecoration(
                  //       hintText: '0 mins',
                  //       border: OutlineInputBorder(
                  //         borderSide: const BorderSide(),
                  //         borderRadius: BorderRadius.circular(8),
                  //       ),
                  //       focusedBorder: const OutlineInputBorder(
                  //         borderSide: BorderSide(
                  //           color: Colors.amber,
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Center(
                child: Text(
                  'You must get up at...',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),

              SizedBox(
                width: 250,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {},
                  child: const Text(
                    'Calculate',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              //ToggleButtons(isSelected: [], children: [Text('Read out remaining time')])
            ],
          ),
        ),
      ),
    );
  }
}
