import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:qum_la_tanam/ui/widgets/custom_spinBox.dart';

class TaskInputRow extends StatelessWidget {
  const TaskInputRow({super.key, required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [

        // Prayer name column
        Column(
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w500),
            ),
          ],
        ),
        const SizedBox(width: 30),
        // arrow icon column
        const Column(
          children: [
            Icon(
              //Icons.arrow_right_alt_rounded,
                Iconsax.arrow_square_right3
            ),
          ],
        ),
        const SizedBox(width: 10),
        Column(children: [
          Row(
            children: [
              SizedBox(
                width: 80,
                height: 45,
                child: CustomSpinBox(
                  min: 0,
                  max: 23,
                  initialValue: 0,
                  onChanged: (value) {},
                ),
              ),
              const SizedBox(width: 4),
              SizedBox(
                  width: 70,
                  height: 45,
                  child: CustomSpinBox(min: 0, max: 23, initialValue: 0, onChanged: (value){})
              ),
            ],
          )
        ],),
      ],
    );
  }
}

// TextFormField(
// inputFormatters: <TextInputFormatter>[
// FilteringTextInputFormatter.digitsOnly
// ],
// keyboardType: TextInputType.number,
// decoration: InputDecoration(
// hintText: '0 mins',
// border: OutlineInputBorder(
// borderSide: const BorderSide(),
// borderRadius: BorderRadius.circular(8),
// ),
// focusedBorder: const OutlineInputBorder(
// borderSide: BorderSide(
// color: Colors.amber,
// )
// )
// ),
// ),