import 'package:equatable/equatable.dart';

abstract class UserFormEvent extends Equatable {
  const UserFormEvent();

  @override
  List<Object> get props => [];
}

class UserFormSubmitted extends UserFormEvent {
  final Map<String, dynamic> formData;

  const UserFormSubmitted({required this.formData});

  @override
  List<Object> get props => [formData];
} 