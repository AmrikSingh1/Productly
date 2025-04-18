# Productly

A beautiful, modern Flutter application showcasing product listings, form handling, and audio playback.

## Features

### Product Listing from API
- Fetches product data from the [Fake Store API](https://fakestoreapi.com/products)
- Displays products in a responsive grid view with images, titles, and prices
- Uses BLoC pattern for state management (loading, success, error states)
- Beautiful UI with Material 3 design, Google Fonts, rounded corners, and animations

### Product Detail Screen
- Shows detailed product information when tapping a product
- Displays product image, title, price, rating, and full description
- "Add to Cart" button with feedback (visual only)
- Smooth transition animations

### User Form Screen
- Comprehensive user form with various field types:
  - Full Name (Text)
  - Email (Text with validation)
  - Phone (Text with validation)
  - Gender (Dropdown)
  - Country, State, City (Cascading dropdowns)
- Form validation with proper error messages
- Success dialog on form submission
- State management using BLoC pattern

### Audio Player
- Simple audio player using the just_audio package
- Playback controls (play, pause, seek)
- Progress bar with time display
- Visualizer with animated waveform

## Architecture

The app follows Clean Architecture principles:
- **Presentation Layer**: BLoC, Pages, Widgets
- **Domain Layer**: Entities, Use Cases, Repository Interfaces
- **Data Layer**: Models, Repository Implementations, Data Sources

## Tech Stack & Libraries

- **Flutter 3.x**: UI framework
- **BLoC/Cubit**: State management
- **Go Router**: Navigation
- **HTTP**: API communication
- **Just Audio**: Audio playback
- **Flutter Form Builder**: Form management
- **Google Fonts**: Typography
- **Flutter Animate**: Animation
- **GetIt**: Dependency injection
- **Equatable**: Value equality
- **Dartz**: Functional programming

## Getting Started

1. Clone the repository
2. Run `flutter pub get` to install dependencies
3. Run `flutter run` to start the app

## Screenshots

*Screenshots will be added here*

## License

This project is for demonstration purposes only.

## Credits

- Product data from [Fake Store API](https://fakestoreapi.com/)
- Sample audio from [SoundHelix](https://www.soundhelix.com/)
