# Riverpod WebSocket Auth App

This is a Flutter application that demonstrates how to use Riverpod for state management, WebSockets for real-time communication, and a token-based authentication system.

## Features

*   **Login Screen**: Users can enter their credentials to log in or sign in with Google.
*   **Sign Up Screen**: Users can create a new account.
*   **Home Screen**: Displays the user's balance and a list of products.
*   **Chat Screen**: A real-time chat interface.
*   **Authentication**: The app uses a token-based authentication system. The token is securely stored on the device.
*   **State Management**: Riverpod is used for managing the application's state.
*   **Real-time Communication**: WebSockets are used for real-time chat functionality.
*   **Modern UI**: The app has a modern glassmorphic design with a video background on the login and sign-up screens.

## Project Structure

*   **main.dart**: The main entry point of the application.
*   **screens/**: Contains the different screens of the application (Login, Sign Up, Home, Chat).
*   **providers/**: Contains the Riverpod providers for managing the app's state.
*   **services/**: Contains the services for interacting with the API and WebSocket server.
*   **models/**: Contains the data models for the application.
*   **widgets/**: Contains reusable widgets.

## API Service

The `ApiService` class handles all the communication with the backend API. It uses the `dio` package for making HTTP requests and `flutter_secure_storage` for securely storing the authentication token.

### Functions

*   `login(username, password)`: Authenticates the user and retrieves a token.
*   `signUp(username, password)`: Creates a new user account.
*   `googleSignIn(idToken)`: Authenticates the user with Google and retrieves a token.
*   `fetchProducts()`: Fetches the list of products from the Darsh Store.
*   `fetchBalance()`: Fetches the user's balance and profile information.
*   `sendMessage(text)`: Sends a message to the chat.
