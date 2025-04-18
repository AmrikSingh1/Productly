import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:productly/core/constants/app_constants.dart';
import 'package:productly/core/storage/local_storage.dart';
import 'package:productly/core/widgets/app_button.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isLoading = true;
  Map<String, dynamic>? _userProfile;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    setState(() {
      _isLoading = true;
    });

    final userProfile = await LocalStorage.getUserProfile();

    setState(() {
      _userProfile = userProfile;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () => context.push(AppConstants.cartRoute),
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text(
                    'Loading profile...',
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
            )
          : _userProfile == null
              ? _buildEmptyProfile(theme)
              : _buildUserProfile(theme),
    );
  }

  Widget _buildEmptyProfile(ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Animate(
              effects: [
                FadeEffect(duration: AppConstants.defaultAnimationDuration),
                ScaleEffect(
                  begin: const Offset(0.8, 0.8),
                  end: const Offset(1.0, 1.0),
                  duration: AppConstants.defaultAnimationDuration,
                ),
              ],
              child: Icon(
                Icons.person_outline,
                size: 80,
                color: theme.colorScheme.primary.withOpacity(0.5),
              ),
            ),
            const SizedBox(height: 16),
            Animate(
              effects: [
                FadeEffect(
                  duration: AppConstants.defaultAnimationDuration,
                  delay: const Duration(milliseconds: 100),
                ),
              ],
              child: Text(
                'No profile information',
                style: theme.textTheme.titleLarge,
              ),
            ),
            const SizedBox(height: 8),
            Animate(
              effects: [
                FadeEffect(
                  duration: AppConstants.defaultAnimationDuration,
                  delay: const Duration(milliseconds: 150),
                ),
              ],
              child: Text(
                'Fill out the user form to create your profile',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium,
              ),
            ),
            const SizedBox(height: 24),
            Animate(
              effects: [
                FadeEffect(
                  duration: AppConstants.defaultAnimationDuration,
                  delay: const Duration(milliseconds: 200),
                ),
                MoveEffect(
                  begin: const Offset(0, 20),
                  end: const Offset(0, 0),
                  duration: AppConstants.defaultAnimationDuration,
                  delay: const Duration(milliseconds: 200),
                ),
              ],
              child: AppButton(
                text: 'Create Profile',
                onPressed: () => context.push(AppConstants.userFormRoute),
                icon: Icons.edit,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserProfile(ThemeData theme) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Header
          Animate(
            effects: [
              FadeEffect(duration: AppConstants.defaultAnimationDuration),
              MoveEffect(
                begin: const Offset(0, 30),
                end: const Offset(0, 0),
                duration: AppConstants.defaultAnimationDuration,
              ),
            ],
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(AppConstants.largeBorderRadius),
                ),
                child: Column(
                  children: [
                    // Avatar with decorative elements
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        // Background decorative elements
                        Animate(
                          effects: [
                            FadeEffect(duration: AppConstants.defaultAnimationDuration),
                            RotateEffect(
                              begin: -0.1,
                              end: 0,
                              duration: AppConstants.longAnimationDuration,
                            ),
                          ],
                          child: Container(
                            width: 140,
                            height: 140,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: theme.colorScheme.primary.withOpacity(0.2),
                                width: 8,
                              ),
                            ),
                          ),
                        ),
                        
                        // Main avatar
                        Animate(
                          effects: [
                            FadeEffect(duration: AppConstants.defaultAnimationDuration),
                            ScaleEffect(
                              begin: const Offset(0.8, 0.8),
                              end: const Offset(1.0, 1.0),
                              duration: AppConstants.defaultAnimationDuration,
                            ),
                          ],
                          child: CircleAvatar(
                            radius: 60,
                            backgroundColor: theme.colorScheme.primary,
                            child: Text(
                              _getInitials(_userProfile!['fullName'] as String),
                              style: theme.textTheme.headlineMedium?.copyWith(
                                color: theme.colorScheme.onPrimary,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 20),
                    
                    Animate(
                      effects: [
                        FadeEffect(
                          duration: AppConstants.defaultAnimationDuration,
                          delay: const Duration(milliseconds: 100),
                        ),
                      ],
                      child: Text(
                        _userProfile!['fullName'] as String,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 6),
                    
                    Animate(
                      effects: [
                        FadeEffect(
                          duration: AppConstants.defaultAnimationDuration,
                          delay: const Duration(milliseconds: 150),
                        ),
                      ],
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.email_outlined,
                            size: 18,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _userProfile!['email'] as String,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 32),
          
          // Personal Information Section
          _buildSection(
            theme,
            title: 'Personal Information',
            icon: Icons.person_outline,
            delayFactor: 0,
            children: [
              _buildInfoRow(
                theme,
                icon: Icons.phone,
                label: 'Phone',
                value: _userProfile!['phone'] as String,
                delay: 200,
              ),
              const SizedBox(height: 16),
              _buildInfoRow(
                theme,
                icon: Icons.person,
                label: 'Gender',
                value: _userProfile!['gender'] as String,
                delay: 250,
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Address Information Section
          _buildSection(
            theme,
            title: 'Address Information',
            icon: Icons.location_on_outlined,
            delayFactor: 300,
            children: [
              _buildInfoRow(
                theme,
                icon: Icons.location_city,
                label: 'Country',
                value: _userProfile!['country'] as String,
                delay: 350,
              ),
              if (_userProfile!.containsKey('state') && _userProfile!['state'] != null) ...[
                const SizedBox(height: 16),
                _buildInfoRow(
                  theme,
                  icon: Icons.map,
                  label: 'State',
                  value: _userProfile!['state'] as String,
                  delay: 400,
                ),
              ],
              if (_userProfile!.containsKey('city') && _userProfile!['city'] != null) ...[
                const SizedBox(height: 16),
                _buildInfoRow(
                  theme,
                  icon: Icons.location_on,
                  label: 'City',
                  value: _userProfile!['city'] as String,
                  delay: 450,
                ),
              ],
            ],
          ),
          
          const SizedBox(height: 32),
          
          // Actions
          Animate(
            effects: [
              FadeEffect(
                duration: AppConstants.defaultAnimationDuration,
                delay: const Duration(milliseconds: 500),
              ),
            ],
            child: Center(
              child: AppButton(
                text: 'Edit Profile',
                onPressed: () => context.push(AppConstants.userFormRoute),
                icon: Icons.edit,
                isFullWidth: true,
              ),
            ),
          ),
          
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSection(
    ThemeData theme, {
    required String title,
    required List<Widget> children,
    required int delayFactor,
    required IconData icon,
  }) {
    return Animate(
      effects: [
        FadeEffect(
          duration: AppConstants.defaultAnimationDuration,
          delay: Duration(milliseconds: delayFactor + 50),
        ),
        MoveEffect(
          begin: const Offset(-20, 0),
          end: const Offset(0, 0),
          duration: AppConstants.defaultAnimationDuration,
          delay: Duration(milliseconds: delayFactor + 50),
        ),
      ],
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.shadow.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Animate(
              effects: [
                FadeEffect(
                  duration: AppConstants.defaultAnimationDuration,
                  delay: Duration(milliseconds: delayFactor),
                ),
              ],
              child: Row(
                children: [
                  Icon(
                    icon,
                    color: theme.colorScheme.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 24),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    ThemeData theme, {
    required IconData icon,
    required String label,
    required String value,
    required int delay,
  }) {
    return Animate(
      effects: [
        FadeEffect(
          duration: AppConstants.defaultAnimationDuration,
          delay: Duration(milliseconds: delay),
        ),
      ],
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: theme.colorScheme.primary,
                size: 18,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                  Text(
                    value,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getInitials(String fullName) {
    if (fullName.isEmpty) return '';
    
    final nameParts = fullName.split(' ');
    if (nameParts.length == 1) return nameParts[0][0].toUpperCase();
    
    return '${nameParts[0][0]}${nameParts[1][0]}'.toUpperCase();
  }
} 