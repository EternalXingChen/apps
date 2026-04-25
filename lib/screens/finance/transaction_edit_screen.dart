import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/transaction_model.dart';
import '../../models/category_model.dart';
import '../../providers/transaction_provider.dart';
import '../../providers/category_provider.dart';
import 'package:provider/provider.dart';

class TransactionEditScreen extends StatefulWidget {
  final TransactionModel? transaction;

  const TransactionEditScreen({Key? key, this.transaction}) : super(key: key);

  @override
  State<TransactionEditScreen> createState() => _TransactionEditScreenState();
}

class _TransactionEditScreenState extends State<TransactionEditScreen> {
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  
  TransactionType _type = TransactionType.expense;
  String? _selectedCategoryId;
  AccountType _accountType = AccountType.cash;
  DateTime _selectedDate = DateTime.now();
  List<String> _tags = [];
  bool _isEncrypted = false;

  bool get _isEditing => widget.transaction != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      _amountController.text = widget.transaction!.amount.toString();
      _noteController.text = widget.transaction!.note ?? '';
      _type = widget.transaction!.type;
      _selectedCategoryId = widget.transaction!.categoryId;
      _accountType = widget.transaction!.accountType;
      _selectedDate = widget.transaction!.timestamp;
      _tags = widget.transaction!.tags ?? [];
      _isEncrypted = widget.transaction!.isEncrypted;
    }
    
    // Load categories
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CategoryProvider>().loadCategories();
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 1)),
    );
    if (date != null) {
      setState(() {
        _selectedDate = date;
      });
    }
  }

  Future<void> _saveTransaction() async {
    if (_amountController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请输入金额')),
      );
      return;
    }

    final amount = double.tryParse(_amountController.text.trim());
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请输入有效的金额')),
      );
      return;
    }

    if (_selectedCategoryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请选择分类')),
      );
      return;
    }

    final transaction = TransactionModel(
      id: widget.transaction?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      amount: amount,
      type: _type,
      categoryId: _selectedCategoryId!,
      accountType: _accountType,
      timestamp: _selectedDate,
      note: _noteController.text.trim().isEmpty ? null : _noteController.text.trim(),
      tags: _tags.isNotEmpty ? _tags : null,
      isEncrypted: _isEncrypted,
      createdAt: widget.transaction?.createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final provider = context.read<TransactionProvider>();

    if (_isEditing) {
      await provider.updateTransaction(transaction);
    } else {
      await provider.addTransaction(transaction);
    }

    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? '编辑记录' : '记一笔'),
        actions: [
          IconButton(
            icon: Icon(_isEncrypted ? Icons.lock : Icons.lock_open),
            onPressed: () {
              setState(() {
                _isEncrypted = !_isEncrypted;
              });
            },
          ),
          TextButton(
            onPressed: _saveTransaction,
            child: const Text('保存'),
          ),
        ],
      ),
      body: Consumer<CategoryProvider>(
        builder: (context, categoryProvider, child) {
          final categories = _type == TransactionType.expense
              ? categoryProvider.expenseCategories
              : categoryProvider.incomeCategories;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Type selector
                SegmentedButton<TransactionType>(
                  segments: const [
                    ButtonSegment(
                      value: TransactionType.expense,
                      label: Text('支出'),
                      icon: Icon(Icons.arrow_downward),
                    ),
                    ButtonSegment(
                      value: TransactionType.income,
                      label: Text('收入'),
                      icon: Icon(Icons.arrow_upward),
                    ),
                  ],
                  selected: {_type},
                  onSelectionChanged: (Set<TransactionType> selected) {
                    setState(() {
                      _type = selected.first;
                      _selectedCategoryId = null;
                    });
                  },
                ),
                const SizedBox(height: 24),
                
                // Amount input
                TextField(
                  controller: _amountController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    labelText: '金额',
                    prefixText: '¥',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                
                // Category selector
                Text(
                  '分类',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                if (categories.isEmpty)
                  const Center(child: CircularProgressIndicator())
                else
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: categories.map((category) {
                      final isSelected = _selectedCategoryId == category.id;
                      return ChoiceChip(
                        avatar: Text(category.icon ?? "📦"),
                        label: Text(category.name),
                        selected: isSelected,
                        selectedColor: _type == TransactionType.expense
                            ? Colors.red.withValues(alpha: 0.2)
                            : Colors.green.withValues(alpha: 0.2),
                        onSelected: (selected) {
                          setState(() {
                            _selectedCategoryId = selected ? category.id : null;
                          });
                        },
                      );
                    }).toList(),
                  ),
                const SizedBox(height: 24),
                
                // Account type
                Text(
                  '账户',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                SegmentedButton<AccountType>(
                  segments: AccountType.values.map((type) {
                    return ButtonSegment(
                      value: type,
                      label: Text(type.label),
                    );
                  }).toList(),
                  selected: {_accountType},
                  onSelectionChanged: (Set<AccountType> selected) {
                    setState(() {
                      _accountType = selected.first;
                    });
                  },
                ),
                const SizedBox(height: 24),
                
                // Date picker
                InkWell(
                  onTap: _selectDate,
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: '日期',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(DateFormat('yyyy年MM月dd日').format(_selectedDate)),
                        const Icon(Icons.calendar_today),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                
                // Note
                TextField(
                  controller: _noteController,
                  decoration: InputDecoration(
                    labelText: '备注（可选）',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  maxLines: 3,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
