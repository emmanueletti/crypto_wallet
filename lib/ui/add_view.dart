import '../net/flutterfire.dart';
import 'package:flutter/material.dart';

class AddView extends StatefulWidget {
  AddView({Key? key}) : super(key: key);

  @override
  _AddViewState createState() => _AddViewState();
}

class _AddViewState extends State<AddView> {
  List<String> coins = ['bitcoin', 'tether', 'ethereum'];
  String dropdownValue = 'bitcoin';
  TextEditingController _amountController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          DropdownButton(
            items: coins.map((String value) {
              return DropdownMenuItem<String>(value: value, child: Text(value));
            }).toList(),
            value: dropdownValue,
            onChanged: (String? value) {
              setState(() {
                dropdownValue = value!;
              });
            },
          ),
          Container(
            width: MediaQuery.of(context).size.width / 1.3,
            child: TextFormField(
              controller: _amountController,
              decoration: const InputDecoration(labelText: 'Coin Amount'),
            ),
          ),
          // Submit btn
          Container(
            width: MediaQuery.of(context).size.width / 1.4,
            height: 45,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              color: Colors.white,
            ),
            child: MaterialButton(
              onPressed: () async {
                // Firestore method to add new coins
                await addCoin(dropdownValue, _amountController.text);
                // Go back to preview screen
                Navigator.of(context).pop();
              },
              child: const Text('Add'),
            ),
          ),
        ],
      ),
    );
  }
}
