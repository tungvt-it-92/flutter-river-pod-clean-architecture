## flutter-river-pod-clean-architecture
A Flutter To-Do application built using the clean architecture concept, leveraging `riverpod` for state management<br/>

#### First, we need to run following command to generate the necessary files for
* `objectbox`: generating database scheme
* `mockito`: creating mock test files
```bash
dart run build_runner build --delete-conflicting-outputs
```
#### Run application: <br/>
```bash
flutter run
```

#### Run unit test: <br/>
```bash
flutter test
```

#### Run integration test: <br/>
```bash
flutter test integration_test/*
```