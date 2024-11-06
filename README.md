# SMS Watcher Plugin

A Flutter plugin to listen to incoming SMS messages and fetch stored messages on Android devices. This plugin allows you to receive SMS updates in real-time and retrieve SMS history for various use cases.

## Features

- Listen for incoming SMS messages in real-time.
- Fetch SMS messages stored on the device.
- Simple integration with both Stream and Future-based data handling.

## Installation

Add this to your `pubspec.yaml`:

```
dependencies:
  smswatcher: ^0.0.1
```

Then, run the command:

```
flutter pub get
```

## Usage

### Import the Package

```
import 'package:smswatcher/smswatcher.dart';
```

### Initialize the Plugin

Create an instance of `Smswatcher`:

```
final _smswatcher = Smswatcher();
```

### Listening to Incoming SMS Messages

Use a `StreamBuilder` to listen for incoming SMS in real-time:

```
StreamBuilder(
  stream: _smswatcher.getStreamOfSMS(),
  builder: (context, snapshot) {
    if (snapshot.hasData) {
      final sms = snapshot.data;
      return ListTile(
        title: Text(sms?["sender"] ?? "Unknown Sender"),
        subtitle: Text(sms?["body"] ?? "No content"),
      );
    } else {
      return Text("No new messages");
    }
  },
)
```

### Fetching SMS History

To fetch all stored SMS messages:

```
FutureBuilder(
  future: _smswatcher.getAllSMS(),
  builder: (context, snapshot) {
    if (snapshot.hasData) {
      final smsList = snapshot.data as List;
      return ListView.builder(
        itemCount: smsList.length,
        itemBuilder: (context, index) {
          final sms = smsList[index];
          return ListTile(
            title: Text(sms["sender"] ?? "Unknown Sender"),
            subtitle: Text(sms["body"] ?? "No content"),
          );
        },
      );
    } else {
      return CircularProgressIndicator();
    }
  },
)
```

## Permissions

### Android

Ensure your `AndroidManifest.xml` includes the following permissions to receive and read SMS messages:

```
<uses-permission android:name="android.permission.RECEIVE_SMS"/>
<uses-permission android:name="android.permission.READ_SMS"/>
```

For runtime permissions, consider using the `permission_handler` package.

## Issues & Contributing

Please file issues or feature requests through GitHub issues. Contributions are welcome!
