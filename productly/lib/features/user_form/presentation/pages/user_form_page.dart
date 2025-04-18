import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:productly/core/constants/app_constants.dart';
import 'package:productly/core/widgets/app_button.dart';
import 'package:productly/features/user_form/presentation/bloc/user_form_bloc.dart';
import 'package:productly/features/user_form/presentation/bloc/user_form_event.dart';
import 'package:productly/features/user_form/presentation/bloc/user_form_state.dart';

class UserFormPage extends StatelessWidget {
  const UserFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => UserFormBloc(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('User Form'),
        ),
        body: const UserFormView(),
      ),
    );
  }
}

class UserFormView extends StatefulWidget {
  const UserFormView({super.key});

  @override
  State<UserFormView> createState() => _UserFormViewState();
}

class _UserFormViewState extends State<UserFormView> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool _isSubmitting = false;

  // Country, State, City options
  final List<String> _countries = [
    'United States',
    'Canada',
    'United Kingdom',
    'Australia',
    'Germany',
    'France',
    'Japan',
    'India',
    'Brazil',
    'Other'
  ];

  final Map<String, List<String>> _statesByCountry = {
    'United States': [
      'Alabama', 'Alaska', 'Arizona', 'Arkansas', 'California',
      'Colorado', 'Connecticut', 'Delaware', 'Florida', 'Georgia',
      'Hawaii', 'Idaho', 'Illinois', 'Indiana', 'Iowa',
      'Kansas', 'Kentucky', 'Louisiana', 'Maine', 'Maryland',
      'Massachusetts', 'Michigan', 'Minnesota', 'Mississippi', 'Missouri',
      'Montana', 'Nebraska', 'Nevada', 'New Hampshire', 'New Jersey',
      'New Mexico', 'New York', 'North Carolina', 'North Dakota', 'Ohio',
      'Oklahoma', 'Oregon', 'Pennsylvania', 'Rhode Island', 'South Carolina',
      'South Dakota', 'Tennessee', 'Texas', 'Utah', 'Vermont',
      'Virginia', 'Washington', 'West Virginia', 'Wisconsin', 'Wyoming'
    ],
    'Canada': [
      'Alberta', 'British Columbia', 'Manitoba', 'New Brunswick', 'Newfoundland and Labrador',
      'Northwest Territories', 'Nova Scotia', 'Nunavut', 'Ontario', 'Prince Edward Island',
      'Quebec', 'Saskatchewan', 'Yukon'
    ],
    'United Kingdom': [
      'England', 'Scotland', 'Wales', 'Northern Ireland'
    ],
    'Australia': [
      'Australian Capital Territory', 'New South Wales', 'Northern Territory', 'Queensland',
      'South Australia', 'Tasmania', 'Victoria', 'Western Australia'
    ],
    'Germany': [
      'Baden-Württemberg', 'Bavaria', 'Berlin', 'Brandenburg', 'Bremen',
      'Hamburg', 'Hesse', 'Lower Saxony', 'Mecklenburg-Vorpommern', 'North Rhine-Westphalia',
      'Rhineland-Palatinate', 'Saarland', 'Saxony', 'Saxony-Anhalt', 'Schleswig-Holstein', 'Thuringia'
    ],
    'Other': ['Not Applicable']
  };

  String? _selectedCountry;
  List<String> _availableStates = [];
  
  @override
  Widget build(BuildContext context) {
    return BlocListener<UserFormBloc, UserFormState>(
      listener: (context, state) {
        if (state is UserFormSubmitting) {
          setState(() {
            _isSubmitting = true;
          });
        } else if (state is UserFormSubmitSuccess) {
          setState(() {
            _isSubmitting = false;
          });
          _showSuccessDialog();
        } else if (state is UserFormSubmitFailure) {
          setState(() {
            _isSubmitting = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: FormBuilder(
          key: _formKey,
          autovalidateMode: AutovalidateMode.disabled,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                'Personal Information',
                style: Theme.of(context).textTheme.headlineSmall,
              ).animate().fadeIn(
                duration: AppConstants.defaultAnimationDuration,
              ),
                
              const SizedBox(height: 24),
                
              // Full Name
              _buildTextField(
                name: 'fullName',
                labelText: 'Full Name',
                prefixIcon: Icons.person,
                validators: FormBuilderValidators.compose<String>([
                  FormBuilderValidators.required(),
                  FormBuilderValidators.minLength(3),
                ]),
                delay: 50,
              ),
                
              const SizedBox(height: 16),
                
              // Email
              _buildTextField(
                name: 'email',
                labelText: 'Email',
                prefixIcon: Icons.email,
                keyboardType: TextInputType.emailAddress,
                validators: FormBuilderValidators.compose<String>([
                  FormBuilderValidators.required(),
                  FormBuilderValidators.email(),
                ]),
                delay: 100,
              ),
                
              const SizedBox(height: 16),
                
              // Phone
              _buildTextField(
                name: 'phone',
                labelText: 'Phone',
                prefixIcon: Icons.phone,
                keyboardType: TextInputType.phone,
                validators: FormBuilderValidators.compose<String>([
                  FormBuilderValidators.required(),
                  FormBuilderValidators.numeric(),
                  FormBuilderValidators.minLength(10),
                  FormBuilderValidators.maxLength(15),
                ]),
                delay: 150,
              ),
                
              const SizedBox(height: 24),
                
              // Gender
              _buildDropdown(
                name: 'gender',
                labelText: 'Gender',
                prefixIcon: Icons.person_outline,
                items: const ['Male', 'Female', 'Non-binary', 'Prefer not to say'],
                validators: FormBuilderValidators.compose<String>([
                  FormBuilderValidators.required(),
                ]),
                delay: 200,
              ),
                
              const SizedBox(height: 24),
                
              // Address Title
              Text(
                'Address Information',
                style: Theme.of(context).textTheme.titleLarge,
              ).animate().fadeIn(
                duration: AppConstants.defaultAnimationDuration,
                delay: const Duration(milliseconds: 250),
              ),
                
              const SizedBox(height: 16),
                
              // Country
              _buildDropdown(
                name: 'country',
                labelText: 'Country',
                prefixIcon: Icons.public,
                items: _countries,
                validators: FormBuilderValidators.compose<String>([
                  FormBuilderValidators.required(),
                ]),
                onChanged: (value) {
                  setState(() {
                    _selectedCountry = value;
                    _availableStates = _statesByCountry[value] ?? [];
                  });
                  // Reset state field when country changes
                  _formKey.currentState?.fields['state']?.reset();
                },
                delay: 300,
              ),
                
              const SizedBox(height: 16),
                
              // State
              _buildDropdown(
                name: 'state',
                labelText: 'State / Province',
                prefixIcon: Icons.location_city,
                items: _availableStates,
                enabled: _selectedCountry != null,
                validators: _selectedCountry != null && _selectedCountry != 'Other'
                    ? FormBuilderValidators.compose<String>([
                        FormBuilderValidators.required(),
                      ])
                    : null,
                delay: 350,
              ),
                
              const SizedBox(height: 16),
                
              // City
              _buildTextField(
                name: 'city',
                labelText: 'City',
                prefixIcon: Icons.location_on,
                validators: FormBuilderValidators.compose<String>([
                  FormBuilderValidators.required(),
                ]),
                delay: 400,
              ),
                
              const SizedBox(height: 32),
                
              // Submit Button
              Builder(
                builder: (context) {
                  return AppButton(
                    text: 'Submit Form',
                    onPressed: _submitForm,
                    isLoading: _isSubmitting,
                    isFullWidth: true,
                    icon: Icons.check_circle,
                  );
                }
              ).animate().fadeIn(
                duration: AppConstants.defaultAnimationDuration,
                delay: const Duration(milliseconds: 450),
              ),
                
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String name,
    required String labelText,
    IconData? prefixIcon,
    TextInputType? keyboardType,
    String? Function(String?)? validators,
    int delay = 0,
  }) {
    final field = FormBuilderTextField(
      name: name,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        ),
      ),
      keyboardType: keyboardType,
      validator: validators,
    );
    
    Widget animatedField = field;
    if (delay > 0) {
      animatedField = field.animate().fadeIn(
        duration: AppConstants.defaultAnimationDuration,
        delay: Duration(milliseconds: delay),
      );
    }
    
    return animatedField;
  }

  Widget _buildDropdown({
    required String name,
    required String labelText,
    required List<String> items,
    IconData? prefixIcon,
    String? Function(String?)? validators,
    Function(dynamic)? onChanged,
    bool enabled = true,
    int delay = 0,
  }) {
    final field = FormBuilderDropdown<String>(
      name: name,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        ),
        enabled: enabled,
      ),
      items: items
          .map((item) => DropdownMenuItem(
                value: item,
                child: Text(item),
              ))
          .toList(),
      validator: validators,
      onChanged: onChanged,
      enabled: enabled,
    );
    
    Widget animatedField = field;
    if (delay > 0) {
      animatedField = field.animate().fadeIn(
        duration: AppConstants.defaultAnimationDuration,
        delay: Duration(milliseconds: delay),
      );
    }
    
    return animatedField;
  }

  void _submitForm() {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      final formData = _formKey.currentState!.value;
      context.read<UserFormBloc>().add(UserFormSubmitted(formData: formData));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fix the errors in the form'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Success'),
        content: const Text('Form submitted successfully.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _formKey.currentState?.reset();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}