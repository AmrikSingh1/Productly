import 'package:equatable/equatable.dart';

abstract class UserFormState extends Equatable {
  const UserFormState();
  
  @override
  List<Object> get props => [];
}

class UserFormInitial extends UserFormState {
  const UserFormInitial();
}

class UserFormSubmitting extends UserFormState {
  const UserFormSubmitting();
}

class UserFormSubmitSuccess extends UserFormState {
  final Map<String, dynamic> userData;
  
  const UserFormSubmitSuccess({required this.userData});
  
  @override
  List<Object> get props => [userData];
}

class UserFormSubmitFailure extends UserFormState {
  final String error;
  
  const UserFormSubmitFailure({required this.error});
  
  @override
  List<Object> get props => [error];
} 