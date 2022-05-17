import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transport_expense_tracker/models/expense.dart';
import 'package:transport_expense_tracker/providers/all_expenses.dart';

class ExpensesList extends StatefulWidget {
  @override
  State<ExpensesList> createState() => _ExpensesListState();
}

class _ExpensesListState extends State<ExpensesList> {
  void removeItem(int i, AllExpenses myExpenses) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Confirmation'),
              content: Text('Are you sure you want to delete?'),
              actions: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      myExpenses.removeExpense(i);
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
    AllExpenses expenseList = Provider.of<AllExpenses>(context);

    return ListView.separated(
      itemBuilder: (context, index) => ListTile(
        leading: CircleAvatar(
          child: Text(expenseList.getMyExpenses()[index].mode),
        ),
        title: Text(expenseList.getMyExpenses()[index].purpose),
        subtitle: Text(expenseList.getMyExpenses()[index].cost.toStringAsFixed(2)),
        trailing: IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {
            removeItem(index, expenseList);
          },
        ),
      ),
      itemCount: expenseList.getMyExpenses().length,
      separatorBuilder: (context, index) => Divider(
        height: 3,
        color: Colors.blueGrey,
      ),
    );
  }
}
