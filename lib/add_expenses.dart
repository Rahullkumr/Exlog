import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:rflutter_alert/rflutter_alert.dart';


class AddExpenses extends StatefulWidget {
  const AddExpenses({super.key});

  @override
  State<AddExpenses> createState() => _AddExpensesState();
}

class _AddExpensesState extends State<AddExpenses> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  // database related code
  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'expenses.db'),
      onCreate: (database, version) async {
        await database.execute(
          "CREATE TABLE IF NOT EXISTS expensetable (id INTEGER PRIMARY KEY AUTOINCREMENT, date TEXT, title TEXT, amount REAL)",
        );
      },
      version: 1,
    );
  }

  void insertData() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      final Database db = await initializeDB();
      await db.insert(
        'expensetable',
        {
          'date': dateController.text,
          'title': titleController.text,
          'amount': amountController.text
        },
      );
      setState(() {});
    }
  }

  // database related code ends

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('Exlog - Expense Logger'),
          centerTitle: true,
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(30.0),
                    child: Text(
                      'Today\'s Expenses',
                      style: TextStyle(fontSize: 32.0),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: TextField(
                      controller: dateController,
                      decoration:
                      const InputDecoration(hintText: 'Date (25/12/2022)'),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: TextField(
                      controller: titleController,
                      decoration: const InputDecoration(hintText: 'Title'),
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: TextField(
                      controller: amountController,
                      decoration:
                          const InputDecoration(hintText: 'Amount Spent'),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 10),
                        child: ElevatedButton(
                          onPressed: () {
                            final date = dateController.text;
                            final title = titleController.text;
                            final amount = amountController.text;

                            bool isValidInput() {

                              // Check if the email address is valid.
                              if (!RegExp(
                                  r'^(0?[1-9]|[12][0-9]|3[01])/(0?[1-9]|1[0-2])/([0-9]{4})$')
                                  .hasMatch(date)) {
                                // Show an error message.
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Invalid date format'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                                return false;
                              }

                              // Check if the amount is valid.
                              if (!RegExp(
                                  r'^\d+(\.\d{1,2})?$')
                                  .hasMatch(amount)) {
                                // Show an error message.
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Invalid amount'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                                return false;
                              }
                              return true;
                            }

                            if (date.isEmpty ||
                                title.isEmpty ||
                                amount.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Empty fields not allowed'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            } else if (isValidInput()) {
                              insertData(); // insert data into dB
                              // r_flutter alert box for successful insertion
                              Alert(
                                context: context,
                                type: AlertType.success,
                                title: "Data inserted",
                                desc: "You have successfully inserted data to the database.",
                                buttons: [
                                  DialogButton(
                                    onPressed: () => Navigator.pop(context),
                                    width: 120,
                                    child: const Text(
                                      "OK",
                                      style: TextStyle(color: Colors.white, fontSize: 20),
                                    ),
                                  )
                                ],
                              ).show();

                            }
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(18.0),
                            child: Text(
                              "Add Expense",
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
