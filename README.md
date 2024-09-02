# missible

The test project "Missible"

## The key points

This project is a Flutter application with using a row of tools:

- BLoC state managment
- mobile_scanner for QR codes scanning
- animated widget
- custom painted widget
- get_it dependency injection (locator) service
- Shared preferences to mock "Local Secret database"

The project immitates the working with data repository. To do this the AppResository interface is created and its Mocked local implementation. Now it is possible to create a remote implementation to work with real API and inject its to the app though GetIt service.
