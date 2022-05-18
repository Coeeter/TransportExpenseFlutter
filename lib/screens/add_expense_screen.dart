import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:transport_expense_tracker/services/firestore_service.dart';

class AddExpenseScreen extends StatefulWidget {
  static String routeName = '/add-expense';

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  var form = GlobalKey<FormState>();

  String? purpose;
  String? mode;
  double? cost;
  DateTime? travelDate;

  void saveForm(BuildContext context) {
    if (form.currentState!.validate()) {
      form.currentState!.save();
      if (travelDate == null) travelDate = DateTime.now();
      FirestoreService fsService = FirestoreService();
      fsService.addExpense(purpose, mode, cost, travelDate);
      FocusScope.of(context).unfocus();
      form.currentState!.reset();
      travelDate = null;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Travel expense added successfully!'),
        ),
      );
      Navigator.of(context).pop();
    }
  }

  void presentDatePicker(BuildContext context) {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(Duration(days: 14)),
      lastDate: DateTime.now(),
    ).then((value) {
      if (value == null) return;

      setState(() {
        travelDate = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Expense'),
        actions: [
          IconButton(onPressed: () => saveForm(context), icon: Icon(Icons.save))
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Form(
          key: form,
          child: Column(
            children: [
              DropdownButtonFormField(
                decoration:
                    const InputDecoration(label: Text('Mode of Transport')),
                items: const [
                  DropdownMenuItem(child: Text('Bus'), value: 'bus'),
                  DropdownMenuItem(child: Text('Grab'), value: 'grab'),
                  DropdownMenuItem(child: Text('MRT'), value: 'mrt'),
                  DropdownMenuItem(child: Text('Taxi'), value: 'taxi'),
                ],
                validator: (value) {
                  if (value == null) {
                    return "Please provide a mode of transport.";
                  }
                  return null;
                },
                onChanged: (value) => mode = value as String,
              ),
              TextFormField(
                decoration: const InputDecoration(label: Text('Cost')),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please provide a travel cost.";
                  }
                  if (double.tryParse(value) == null) {
                    return "Please provide a valid travel cost.";
                  }
                  return null;
                },
                onSaved: (value) => cost = double.parse(value!),
              ),
              TextFormField(
                decoration: const InputDecoration(label: Text('Purpose')),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please provide a purpose";
                  }
                  if (value.length < 5) {
                    return "Please enter a description that is at least 5 characters.";
                  }
                  return null;
                },
                onSaved: (value) => purpose = value,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    travelDate == null
                        ? 'No Date Chosen'
                        : "Picked date: ${DateFormat('dd/MM/yyyy').format(travelDate!)}",
                  ),
                  TextButton(
                    child: const Text('Choose Date',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    onPressed: () {
                      presentDatePicker(context);
                    },
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
