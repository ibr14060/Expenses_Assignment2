import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title, required this.username})
      : super(key: key);

  final String title;
  final String username;
  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> ExpensesData = [];
  TextEditingController _titleController = TextEditingController();
  TextEditingController _amountController = TextEditingController();
  DateTime? selectedDate = DateTime.now();
  void initState() {
    super.initState();
    fetchExpensess(); // Fetch posts when the page is initialized
  }

  Future<void> fetchExpensess() async {
    try {
      final response = await http.get(Uri.parse(
          'https://expenses-assignment-default-rtdb.firebaseio.com/Expenses.json'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
//

//
        // Clear existing post data
        ExpensesData.clear();

        jsonData.forEach((key, value) {
          final Map<String, dynamic> expense = {
            'id': key,
            'title': value['title'],
            'amount': value['amount'],
            'date': value['date'],
          };

          ExpensesData.add(expense);
        });
        // var responseData = json.decode(response.body);
        // var username = responseData['name'];

        setState(() {});
      } else {
        print('Failed to fetch posts: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching posts: $error');
    }
  }

  Future<void> expenseData() async {
    var url = Uri.parse(
        'https://expenses-assignment-default-rtdb.firebaseio.com/Expenses.json'); // Replace with your API endpoint
    var response = await http.post(url,
        body: json.encode({
          'title': _titleController.text,
          'amount': double.parse(_amountController.text),
          'date': selectedDate.toString(),
        }));

    if (response.statusCode == 200) {
      // Request successful
      print('POST request successful');
      print(response.body);
    } else {
      // Request failed
      print('POST request failed with status: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final expenses = useState([
      {
        'id': '1',
        'title': 'New Shoes',
        'amount': 69.99,
        'date': DateTime.now(),
      },
      {
        'id': '2',
        'title': 'Weekly Groceries',
        'amount': 0.53,
        'date': DateTime.now(),
      },
      {
        'id': '3',
        'title': 'Makeup',
        'amount': 16.53,
        'date': DateTime.now(),
      },
      {
        'id': '4',
        'title': 'Weekly shopping',
        'amount': 160.00,
        'date': DateTime.now(),
      },
    ]);

    double totalExpenses = 0.0;
    for (var expense in expenses.value) {
      totalExpenses += expense['amount'] as num;
    }

    void deleteExpense(int index) {
      if (index >= 0 && index < expenses.value.length) {
        final List<Map<String, dynamic>> updatedExpenses =
            List.from(expenses.value);
        updatedExpenses.removeAt(index);
        expenses.value = List<Map<String, Object>>.from(updatedExpenses);
      }
    }

    void addExpense(String title, double amount, DateTime date) {
      final List<Map<String, dynamic>> updatedExpenses =
          List.from(expenses.value);
      final newExpense = {
        'id': '${expenses.value.length + 1}',
        'title': title,
        'amount': amount,
        'date': date,
      };
      updatedExpenses.add(newExpense);
      expenses.value = List<Map<String, Object>>.from(updatedExpenses);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Tracker'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 66, 191, 196),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () async {
              TextEditingController _titleController = TextEditingController();
              TextEditingController _amountController = TextEditingController();
              DateTime? selectedDate = DateTime.now();

              await showModalBottomSheet(
                context: context,
                isScrollControlled:
                    true, // Ensure the bottom sheet occupies full height
                builder: (BuildContext context) {
                  return SingleChildScrollView(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                    ),
                    child: Container(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text("Add Expense", style: TextStyle(fontSize: 20)),
                          SizedBox(height: 8),
                          TextField(
                            controller: _titleController,
                            decoration: InputDecoration(
                              hintText: 'Expense Title',
                            ),
                          ),
                          TextField(
                            controller: _amountController,
                            decoration: InputDecoration(
                              hintText: 'Expense Amount',
                            ),
                          ),
                          TextButton(
                            onPressed: () async {
                              final DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2015, 8),
                                lastDate: DateTime(2101),
                              );
                              selectedDate = pickedDate;
                              print(selectedDate);
                            },
                            child: Text(
                              selectedDate != null
                                  ? 'Selected Date: ${selectedDate.toString()}'
                                  : 'Select Date',
                            ),
                          ),
                          TextButton(
                            onPressed: () async {
                              if (_titleController.text.isNotEmpty &&
                                  _amountController.text.isNotEmpty &&
                                  selectedDate != null) {
                                addExpense(
                                  _titleController.text,
                                  double.parse(_amountController.text),
                                  selectedDate!,
                                );
                                _titleController.clear();
                                _amountController.clear();
                                selectedDate = DateTime.now();
                                print('Expense added');
                                Navigator.pop(context);
                              } else {
                                print('All fields are required');
                              }
                            },
                            child: Text("Submit"),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.all(10),
            child: FractionallySizedBox(
              widthFactor: 1.0,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('EGP ${totalExpenses.toStringAsFixed(2)}',
                      style: TextStyle(
                          fontSize: 20,
                          color: Color.fromARGB(255, 66, 191, 196)),
                      textAlign: TextAlign.center),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: expenses.value.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: FittedBox(
                          child: Text('EGP ${expenses.value[index]['amount']}'),
                        ),
                      ),
                    ),
                    title: Text(
                      expenses.value[index]['title'].toString(),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      expenses.value[index]['date'].toString(),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      color: Colors.red,
                      onPressed: () {
                        deleteExpense(index);
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Builder(
        builder: (BuildContext context) {
          return FloatingActionButton(
            backgroundColor: const Color.fromARGB(255, 66, 191, 196),
            tooltip: 'Increment',
            onPressed: () async {
              TextEditingController _titleController = TextEditingController();
              TextEditingController _amountController = TextEditingController();
              DateTime? selectedDate = DateTime.now();

              await showModalBottomSheet(
                context: context,
                isScrollControlled:
                    true, // Ensure the bottom sheet occupies full height
                builder: (BuildContext context) {
                  return SingleChildScrollView(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                    ),
                    child: Container(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text("Add Expense", style: TextStyle(fontSize: 20)),
                          SizedBox(height: 8),
                          TextField(
                            controller: _titleController,
                            decoration: InputDecoration(
                              hintText: 'Expense Title',
                            ),
                          ),
                          TextField(
                            controller: _amountController,
                            decoration: InputDecoration(
                              hintText: 'Expense Amount',
                            ),
                          ),
                          TextButton(
                            onPressed: () async {
                              final DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2015, 8),
                                lastDate: DateTime(2101),
                              );
                              selectedDate = pickedDate;
                              print(selectedDate);
                            },
                            child: Text(
                              selectedDate != null
                                  ? 'Selected Date: ${selectedDate.toString()}'
                                  : 'Select Date',
                            ),
                          ),
                          TextButton(
                            onPressed: () async {
                              if (_titleController.text.isNotEmpty &&
                                  _amountController.text.isNotEmpty &&
                                  selectedDate != null) {
                                addExpense(
                                  _titleController.text,
                                  double.parse(_amountController.text),
                                  selectedDate!,
                                );
                                _titleController.clear();
                                _amountController.clear();
                                selectedDate = DateTime.now();
                                print('Expense added');
                                Navigator.pop(context);
                              } else {
                                print('All fields are required');
                              }
                            },
                            child: Text("Submit"),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            child: const Icon(Icons.add, color: Colors.white, size: 28),
          );
        },
      ),
    );
  }
}
