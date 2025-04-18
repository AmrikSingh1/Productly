import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:productly/features/user_form/presentation/bloc/user_form_event.dart';
import 'package:productly/features/user_form/presentation/bloc/user_form_state.dart';

class UserFormBloc extends Bloc<UserFormEvent, UserFormState> {
  UserFormBloc() : super(const UserFormInitial()) {
    on<UserFormSubmitted>(_onUserFormSubmitted);
  }

  Future<void> _onUserFormSubmitted(
    UserFormSubmitted event,
    Emitter<UserFormState> emit,
  ) async {
    emit(const UserFormSubmitting());
    
    try {
      // Here we would normally send the data to an API
      // For this example, we'll simulate a network delay
      await Future.delayed(const Duration(seconds: 2));
      
      // Validate the form data here if needed
      final userData = event.formData;
      
      // For demonstration, we'll consider the form submission successful
      // In a real app, we would handle API responses here
      emit(UserFormSubmitSuccess(userData: userData));
    } catch (e) {
      emit(UserFormSubmitFailure(error: e.toString()));
    }
  }
} 