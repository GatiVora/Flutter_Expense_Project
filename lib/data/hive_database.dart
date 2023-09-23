import 'package:hive/hive.dart';

import '../models/expense_item.dart';

class HiveDatabase{
  //reference our Box
  final _myBox = Hive.box("expense_database");

  //writing data

  void saveData(List<ExpenseItem> allExpense){
    /*

      Hive can only store strings and dateTime, and not custom objects link ExpenseItem.
      So, lets convert ExpenseItem objects into types that can be stored in our db

      allExpenses=
      [
        ExpenseItem (name / amount / datetime)
        ..

      ]
      ->
      [
        [name , amount , dateTime],
      ]


     */

    List<List<dynamic>> allExpensesFormated = [];

    for(var expense in allExpense){
      //convert each expenseItem into a list of storable types
      List<dynamic> expenseFormatted = [
        expense.name,
        expense.amount,
        expense.dateTime,
      ];
      allExpensesFormated.add(expenseFormatted);
    }

    //finally we can store it in our database
    _myBox.put("ALL_EXPENSES", allExpensesFormated);

  }

  //reading data
  List<ExpenseItem> readData(){
    /*
      Data is stored in Hive in a list of strings+ datetime ,so lets convert into ExpenseItem
    */

    List savedExpenses = _myBox.get("ALL_EXPENSES") ?? [];
    List<ExpenseItem> allExpenses = [];

    for(int i=0;i<savedExpenses.length;i++){
      //collect individual expense data
      String name = savedExpenses[i][0];
      String amount =savedExpenses[i][1];
      DateTime dateTime=savedExpenses[i][2];

      //create expense item
      ExpenseItem expense = ExpenseItem(name: name, amount: amount, dateTime: dateTime);

      //add expense to overall list of expenses
      allExpenses.add(expense);



    }
    return allExpenses;

  }


}