import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/journal_entry.dart';
import '../../../domain/usecases/journal_usecases.dart';

part 'journal_event.dart';
part 'journal_state.dart';

class JournalBloc extends Blococ<JournalEvent, JournalState> {
  final GetJournalEntries getJournalEntries;
  final AddJournalEntry addJournalEntry;
  final UpdateJournalEntry updateJournalEntry;
  final DeleteJournalEntry deleteJournalEntry;

  JournalBloc({
    required this.getJournalEntries,
    required this.addJournalEntry,
    required this.updateJournalEntry,
    required this.deleteJournalEntry,
  }) : super(JournalInitial()) {
    on on<LoadJournalEntries>(_onLoadJournalEntries);
    on on<AddNewJournalEntry>(_onAddNewJournalEntry);
    on on<UpdateExistingJournalEntry>(_onUpdateExistingJournalEntry);
    on on<DeleteExistingJournalEntry>(_onDeleteExistingJournalEntry);
  }

  Future<void> _onLoadJournalEntries(
    LoadJournalEntries event,
    Emitter Emitter<JournalState> emit,
  ) async {
    emit(JournalLoading());
    try {
      final entries = await getJournalEntries(
        startDate: event.startDate,
        endDate: event.endDate,
      );
      emit(JournalLoaded(entries: entries));
    } catch (e) {
      emit(JournalError(message: e.toString()));
    }
  }

  Future<void> _onAddNewJournalEntry(
    AddNewJournalEntry event,
    Emitter Emitter<JournalState> emit,
  ) async {
    try {
      await addJournalEntry(event.entry);
      add(LoadJournalEntries());
    } catch (e) {
      emit(JournalError(message: e.toString()));
    }
  }

  Future<void> _onUpdateExistingJournalEntry(
    UpdateExistingJournalEntry event,
    Emitter Emitter<JournalState> emit,
  ) async {
    try {
      await updateJournalEntry(event.entry);
      add(LoadJournalEntries());
    } catch (e) {
      emit(JournalError(message: e.toString()));
    }
  }

  Future<void> _onDeleteExistingJournalEntry(
    DeleteExistingJournalEntry event,
    Emitter Emitter<JournalState> emit,
  ) async {
    try {
      await deleteJournalEntry(event.id);
      add(LoadJournalEntries());
    } catch (e) {
      emit(JournalError(message: e.toString()));
    }
  }
}
