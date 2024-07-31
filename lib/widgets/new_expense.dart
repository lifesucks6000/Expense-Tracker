import 'package:flutter/material.dart';
import 'package:expense_tracker/models/expense.dart';

class NewExpense extends StatefulWidget {
  const NewExpense(this.onAddExpense, {super.key});

  final void Function(Expense expense) onAddExpense;

  @override
  State<NewExpense> createState() {
    return _NewExpenseState();
  }
}

class _NewExpenseState extends State<NewExpense> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;
  Category _selectedCategory = Category.leisure;

  void _presentDatePicker() async {
    final firstDate = DateTime(2020);
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: firstDate,
      lastDate: DateTime.now(),
    );

    setState(() {
      _selectedDate = pickedDate;
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _submitExpenseData() {
    final enteredAmount = double.tryParse(_amountController.text);
    final amountIsInvalid = enteredAmount == null || enteredAmount <= 0;
    if (_titleController.text.trim().isEmpty ||
        amountIsInvalid ||
        _selectedDate == null) {
      showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                title: const Text('Invalid Input'),
                content: const Text(
                    'Please make sure a valid title, amount, date and category was selected...'),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                      },
                      child: const Text('Okay'))
                ],
              ));
      return;
    }

    widget.onAddExpense(Expense(
      title: _titleController.text,
      amount: enteredAmount,
      date: _selectedDate!,
      category: _selectedCategory,
    ));

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;

    return LayoutBuilder(builder: (ctx, constraints) {
      final width = constraints.maxWidth;

      return SizedBox(
        height: double.infinity,
        child: SingleChildScrollView(
          child: Padding(
              padding: EdgeInsets.fromLTRB(16, 48, 16, keyboardSpace + 16),
              child: Column(
                children: [
                  if (width >= 600)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: TextField(
                            maxLength: 50,
                            controller: _titleController,
                            decoration: const InputDecoration(
                              label: Text('Title: '),
                            ),
                          ),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          flex: 2,
                          child: TextField(
                            keyboardType: TextInputType.number,
                            controller: _amountController,
                            decoration: const InputDecoration(
                              prefixText: '₹ ',
                              label: Text('Amount: '),
                            ),
                          ),
                        ),
                      ],
                    )
                  else
                    TextField(
                      maxLength: 50,
                      controller: _titleController,
                      decoration: const InputDecoration(
                        label: Text('Title: '),
                      ),
                    ),
                  if (width >= 600)
                    Row(
                      children: [
                        DropdownButton(
                          value: _selectedCategory,
                          items: Category.values.map(
                            (category) {
                              return DropdownMenuItem(
                                value: category,
                                child: Text(
                                  category.name.toUpperCase(),
                                ),
                              );
                            },
                          ).toList(),
                          onChanged: (value) {
                            setState(
                              () {
                                if (value != null) {
                                  _selectedCategory = value;
                                }
                              },
                            );
                          },
                        ),
                        // const SizedBox(width: 24),
                        const Spacer(),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Text(
                                  _selectedDate == null
                                      ? 'No Date Selected'
                                      : formatter.format(_selectedDate!),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              IconButton(
                                  onPressed: _presentDatePicker,
                                  icon: const Icon(Icons.calendar_month))
                            ],
                          ),
                        )
                      ],
                    )
                  else
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: TextField(
                            keyboardType: TextInputType.number,
                            controller: _amountController,
                            decoration: const InputDecoration(
                              prefixText: '₹ ',
                              label: Text('Amount: '),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          flex: 3,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Text(
                                  _selectedDate == null
                                      ? 'No Date Selected'
                                      : formatter.format(_selectedDate!),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              IconButton(
                                  onPressed: _presentDatePicker,
                                  icon: const Icon(Icons.calendar_month))
                            ],
                          ),
                        )
                      ],
                    ),
                  const SizedBox(
                    height: 30,
                  ),
                  if (width >= 600)
                    Row(
                      children: [
                        const Spacer(),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            _submitExpenseData();
                          },
                          child: const Text('Save Expense'),
                        )
                      ],
                    )
                  else
                    Row(
                      children: [
                        DropdownButton(
                            value: _selectedCategory,
                            items: Category.values.map(
                              (category) {
                                return DropdownMenuItem(
                                  value: category,
                                  child: Text(
                                    category.name.toUpperCase(),
                                  ),
                                );
                              },
                            ).toList(),
                            onChanged: (value) {
                              setState(() {
                                if (value != null) {
                                  _selectedCategory = value;
                                }
                              });
                            }),
                        const Spacer(),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            _submitExpenseData();
                          },
                          child: const Text('Save Expense'),
                        )
                      ],
                    )
                ],
              )),
        ),
      );
    });
  }
}
