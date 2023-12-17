import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

// Model class for each expense row
class Expense {
  int? id;
  late String date;
  late String title;
  late double amount;

  Expense({
    this.id,
    required this.date,
    required this.title,
    required this.amount,
  });


  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id : map['id'],
      date : map['date'],
      title : map['title'],
      amount : map['amount'],
    );
  }
}

class ViewExpenses extends StatefulWidget {
  const ViewExpenses({super.key});

  @override
  State<ViewExpenses> createState() => _ViewExpensesState();
}

class _ViewExpensesState extends State<ViewExpenses> {
  late List<Expense> expenses = [];

  @override
  void initState() {
    super.initState();
    fetchExpensesFromDatabase();
  }

  Future<void> fetchExpensesFromDatabase() async {
    final database = openDatabase(
      join(await getDatabasesPath(), 'expenses.db'),
      onCreate: (db, version) {
        return db.execute(
          '''
          CREATE TABLE IF NOT EXISTS expensetable (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            date TEXT,
            title TEXT,
            amount REAL
          )
          ''',
        );
      },
      version: 1,
    );
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('expensetable');

    setState(() {
      expenses = List.generate(maps.length, (index) {
        return Expense.fromMap(maps[index]);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('Exlog - Expense Logger'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(30.0),
                child: Text(
                  'All Expenses',
                  style: TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columnSpacing: 40,
                  dividerThickness: 0,
                  columns: const [
                    DataColumn(label: Text('S No')),
                    DataColumn(label: Text('Date')),
                    DataColumn(label: Text('Title')),
                    DataColumn(label: Text('Amount')),
                  ],
                  headingRowColor: MaterialStateProperty.all(Colors.blueGrey.shade50),
                  rows: expenses
                      .map(
                        (expense) => DataRow(cells: [
                          DataCell(Text(expense.id.toString())),
                          DataCell(Text(expense.date)),
                          DataCell(Text(expense.title)),
                          DataCell(Text(expense.amount.toString())),
                        ]),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
