part of 'finance_bloc.dart';

abstract class FinanceEvent extends Equatable {
  const FinanceEvent();

  @override
  List<Object?> get props => [];
}

class LoadFinanceData extends FinanceEvent {}

class LoadTransactions extends FinanceEvent {
  final DateTime? startDate;
  final DateTime? endDate;
  final TransactionCategory? category;

  const LoadTransactions({
    this.startDate,
    this.endDate,
    this.category,
  });

  @override
  List<Object?> get props => [startDate, endDate, category];
}

class AddTransaction extends FinanceEvent {
  final Transaction transaction;

  const AddTransaction(this.transaction);

  @override
  List<Object?> get props => [transaction];
}

class UpdateTransaction extends FinanceEvent {
  final Transaction transaction;

  const UpdateTransaction(this.transaction);

  @override
  List<Object?> get props => [transaction];
}

class DeleteTransaction extends FinanceEvent {
  final String id;

  const DeleteTransaction(this.id);

  @override
  List<Object?> get props => [id];
}

class LoadBudgets extends FinanceEvent {}

class AddBudget extends FinanceEvent {
  final Budget budget;

  const AddBudget(this.budget);

  @override
  List<Object?> get props => [budget];
}

class UpdateBudget extends FinanceEvent {
  final Budget budget;

  const UpdateBudget(this.budget);

  @override
  List<Object?> get props => [budget];
}

class DeleteBudget extends FinanceEvent {
  final String id;

  const DeleteBudget(this.id);

  @override
  List<Object?> get props => [id];
}

class LoadAccounts extends FinanceEvent {}

class AddAccount extends FinanceEvent {
  final Account account;

  const AddAccount(this.account);

  @override
  List<Object?> get props => [account];
}

class UpdateAccount extends FinanceEvent {
  final Account account;

  const UpdateAccount(this.account);

  @override
  List<Object?> get props => [account];
}

class DeleteAccount extends FinanceEvent {
  final String id;

  const DeleteAccount(this.id);

  @override
  List<Object?> get props => [id];
}

class SelectDateRange extends FinanceEvent {
  final DateTime startDate;
  final DateTime endDate;

  const SelectDateRange({
    required this.startDate,
    required this.endDate,
  });

  @override
  List<Object?> get props => [startDate, endDate];
}
