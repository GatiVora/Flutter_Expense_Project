import 'package:finance_project/components/expense_summary.dart';
import 'package:finance_project/components/expense_title.dart';
import 'package:finance_project/data/expense_data.dart';
import 'package:finance_project/models/expense_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  //text controllers
  final newExpenseNameController = TextEditingController();
  final newExpenseDollarController = TextEditingController();
  final newExpenseCentsController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //prepare data on startup
    Provider.of<ExpenseData>(context,listen: false).prepareData();
  }

  //add new expense
  void addNewExpense(){
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Add new Expense"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              //expense name
              TextField(
                controller: newExpenseNameController,
                decoration: const InputDecoration(
                  hintText: "Expense name",
                ),
              ),

              //expense amount
              Row(
                children: [
                  //dollars
                  Expanded(
                    child: TextField(
                      controller: newExpenseDollarController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: "Dollars",
                      ),
                    ),
                  ),
                  //cents
                  Expanded(
                    child: TextField(
                      controller: newExpenseCentsController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: "Cents",
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            //save button
            MaterialButton(
              onPressed: save,
              child: Text("Save"),
            ),
            MaterialButton(
                onPressed: cancel,
              child: Text("Cancel"),
            )


            //cancel button
          ],
        ),
    );
  }


  //delete expense
  void deleteExpense(ExpenseItem expense){
    Provider.of<ExpenseData>(context, listen: false).deleteExpense(expense);
  }

  //save
  void save() {
    //only save if all fields are filled
    if (newExpenseNameController.text.isNotEmpty &&
        newExpenseDollarController.text.isNotEmpty &&
        newExpenseCentsController.text.isNotEmpty){
      //put dollars and cents together
      String amount = '${newExpenseDollarController
          .text}.${newExpenseCentsController.text}';

    //create expense item
    ExpenseItem newExpense = ExpenseItem(
      name: newExpenseNameController.text,
      amount: amount,
      dateTime: DateTime.now(),
    );

    //add the new expense
    Provider.of<ExpenseData>(context, listen: false).addNewExpense(newExpense);
  }

    Navigator.pop(context);
    clear();

  }

  //cancel
  void cancel(){
    Navigator.pop(context);
    clear();
  }

  //clear controllers
  void clear(){
    newExpenseNameController.clear();
    newExpenseDollarController.clear();
    newExpenseCentsController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseData>(
        builder: (context,value,child)=> Scaffold(
          backgroundColor: Colors.grey[300],
          floatingActionButton: FloatingActionButton(
            onPressed: addNewExpense,
            child: const Icon(Icons.add),
            backgroundColor: Colors.black,
          ),
          body: ListView(children: [

            //weekly summary

            ExpenseSummary(startOfWeek: value.startOfWeekDate()),

            const SizedBox(height: 20),
            //expense list
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),

              itemCount: value.getAllExpenseList().length,
              itemBuilder: (context,index)=> ExpenseTitle(
                name: value.getAllExpenseList()[index].name,
                amount: value.getAllExpenseList()[index].amount,
                dateTime: value.getAllExpenseList()[index].dateTime,
                deleteTapped: (p0)=>
                    deleteExpense(value.getAllExpenseList()[index]),
              ),

            )


          ]),

        ),
    );
  }
}


