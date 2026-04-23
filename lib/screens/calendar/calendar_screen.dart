import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:provider/provider.dart';
import '../../models/task_model.dart';
import '../../models/journal_model.dart';
import '../../models/transaction_model.dart';
import '../../providers/task_provider.dart';
import '../../providers/journal_provider.dart';
import '../../providers/transaction_provider.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  State State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State State<CalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  Map<DateTime, List List<CalendarEvent>> _events = {};

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    final taskProvider = context.read<TaskProvider>();
    final journalProvider = context.read.read<JournalProvider>();
    final transactionProvider = context.read.read<TransactionProvider>();

    await taskProvider.loadTasks();
    await journalProvider.loadEntries();
    await transactionProvider.loadTransactions();

    final events = <DateTime, List List<CalendarEvent>>{};

    // Add tasks
    for (final task in taskProvider.tasks) {
      if (task.dueDate != null) {
        final date = DateTime(
          task.dueDate!.year,
          task.dueDate!.month,
          task.dueDate!.day,
        );
        events.putIfAbsent(date, () => []);
        events[date]!.add(CalendarEvent(
          title: task.title,
          type: EventType.task,
          item: task,
        ));
      }
    }

    // Add journals
    for (final journal in journalProvider.entries) {
      final date = DateTime(
        journal.createdAt.year,
        journal.createdAt.month,
        journal.createdAt.day,
      );
      events.putIfAbsent(date, () => []);
      events[date]!.add(CalendarEvent(
        title: journal.content.length > 20
            ? '${journal.content.substring(0, 20)}...'
            : journal.content,
        type: EventType.journal,
        item: journal,
      ));
    }

    // Add transactions
    for (final transaction in transactionProvider.transactions) {
      final date = DateTime(
        transaction.timestamp.year,
        transaction.timestamp.month,
        transaction.timestamp.day,
      );
      events.putIfAbsent(date, () => []);
      events[date]!.add(CalendarEvent(
        title: '${transaction.categoryId}: ¥${transaction.amount}',
        type: EventType.transaction,
        item: transaction,
      ));
    }

    setState(() {
      _events = events;
    });
  }

  List List<CalendarEvent> _getEventsForDay(DateTime day) {
    final date = DateTime(day.year, day.month, day.day);
    return _events[date] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('日历'),
      ),
      body: Column(
        children: [
          TableCalendarCalendar<CalendarEvent>(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
            eventLoader: _getEventsForDay,
            calendarStyle: const CalendarStyle(
              markersMaxCount: 3,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: _buildEventList(),
          ),
        ],
      ),
    );
  }

  Widget _buildEventList() {
    final events = _getEventsForDay(_selectedDay ?? _focusedDay);

    if (events.isEmpty) {
      return const Center(
        child: Text('暂无事件'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: Icon(
              _getEventIcon(event.type),
              color: _getEventColor(event.type),
            ),
            title: Text(event.title),
            subtitle: Text(_getEventTypeLabel(event.type)),
            onTap: () => _handleEventTap(event),
          ),
        );
      },
    );
  }

  IconData _getEventIcon(EventType type) {
    switch (type) {
      case EventType.task:
        return Icons.check_circle;
      case EventType.journal:
        return Icons.book;
      case EventType.transaction:
        return Icons.account_balance_wallet;
    }
  }

  Color _getEventColor(EventType type) {
    switch (type) {
      case EventType.task:
        return Colors.blue;
      case EventType.journal:
        return Colors.orange;
      case EventType.transaction:
        return Colors.green;
    }
  }

  String _getEventTypeLabel(EventType type) {
    switch (type) {
      case EventType.task:
        return '任务';
      case EventType.journal:
        return '日记';
      case EventType.transaction:
        return '财务';
    }
  }

  void _handleEventTap(CalendarEvent event) {
    switch (event.type) {
      case EventType.task:
        // Navigate to task detail
        break;
      case EventType.journal:
        // Navigate to journal detail
        break;
      case EventType.transaction:
        // Navigate to transaction detail
        break;
    }
  }
}

enum EventType {
  task,
  journal,
  transaction,
}

class CalendarEvent {
  final String title;
  final EventType type;
  final dynamic item;

  CalendarEvent({
    required this.title,
    required this.type,
    required this.item,
  });
}
