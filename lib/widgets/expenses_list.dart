import 'package:flutter/material.dart';
import 'package:transport_expense_tracker/models/expense.dart';
import 'package:transport_expense_tracker/screens/edit_expense_screen.dart';
import 'package:transport_expense_tracker/services/firestore_service.dart';

class ExpensesList extends StatefulWidget {
  @override
  State<ExpensesList> createState() => _ExpensesListState();
}

class _ExpensesListState extends State<ExpensesList> {
  FirestoreService fsService = FirestoreService();

  void removeItem(String id) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Confirmation'),
              content: Text('Are you sure you want to delete?'),
              actions: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      fsService.removeExpense(id);
                    });
                    Navigator.of(context).pop();
                  },
                  child: Text('Yes'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('No'),
                )
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Expense>>(
        stream: fsService.getExpenses(),
        builder: (context, snapshot) {
          return snapshot.connectionState == ConnectionState.waiting
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : ListView.separated(
                  itemBuilder: (context, index) => ListTile(
                    leading: CircleAvatar(
                      child: Text(snapshot.data![index].mode),
                    ),
                    title: Text(snapshot.data![index].purpose),
                    subtitle:
                        Text(snapshot.data![index].cost.toStringAsFixed(2)),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        removeItem(snapshot.data![index].id);
                      },
                    ),
                    onTap: () => Navigator.of(context).pushNamed(
                        EditExpenseScreen.routeName,
                        arguments: snapshot.data![index]),
                  ),
                  itemCount: snapshot.data!.length,
                  separatorBuilder: (context, index) => Divider(
                    height: 3,
                    color: Colors.blueGrey,
                  ),
                );
        });
  }
}
