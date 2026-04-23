import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:personal_manager/models/task.dart';
import 'package:personal_manager/models/journal.dart';
import 'package:personal_manager/models/transaction.dart';
import 'package:personal_manager/services/database_service.dart';
import 'package:personal_manager/widgets/calendar/event_list.dart';

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
    final db = DatabaseService.instance;
    
    // Load tasks
    final tasks = await db.getAllTasks();
    // Load journals
    final journals = await db.getAllJournals();
    // Load transactions
    final transactions = await db.getAllTransactions();
    
    final events = <DateTime, List List<CalendarEvent>>{};
    
    // Add tasks
    for (final task in tasks) {
      if (task.dueTime != null) {
        final date = DateTime(
          task.dueTime!.year,
          task.dueTime!.month,
          task.dueTime!.day,
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
    for (final journal in journals) {
      final date = DateTime(
        journal.createdAt.year,
        journal.createdAt.month,
        journal.createdAt.day,
      );
      events.putIfAbsent(date, () => []);
      events[date]!.add(CalendarEvent(
        title: journal.content.substring(0, journal.content.length > 20 ? 20 : journal.content.length),
        type: EventType.journal,
        item: journal,
      ));
    }
    
    // Add transactions
    for (final transaction in transactions) {
      final date = DateTime(
        transaction.timestamp.year,
        transaction.timestamp.month,
        transaction.timestamp.day,
      );
      events.putIfAbsent(date, () => []);
      events[date]!.add(CalendarEvent(
        title: '${transaction.category}: ${transaction.amount}',
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
        title: const Text('Calendar'),
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
            child: EventList(
              events: _getEventsForDay(_selectedDay ?? _focusedDay),
              onEventTap: (event) {
                _handleEventTap(event);
              },
            ),
          ),
        ],
      ),
    );
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
