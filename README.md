# Calorie Tracker App 
### Created by Lifu Zhang and Jami Huang

Cal Tracker is a cross-platform mobile application developed using Flutter to allow users to sign in using google sign-in, create recipes, input food entries, and use a barcode scanner to find out how many calories are contained in each food item they scan. 

To get the nutrition facts on each food item, the [FDA API](https://fdc.nal.usda.gov/api-guide.html) was used.


## Demo Video
The demo video can be accessed in this [link](https://youtu.be/TM1U6o_KR0Q).

## Agile Development

### Sprints
We divided our work flow into 3 sprints:

1) Building the App Template: We spent the first two working sessions learning how react and flutter work, as this was the first time both of us were working with front-end. Because we are first time app developers, we decided to try React first. We  working on our iPhone 11. However, when trying to implement Google Sign In, we were having a lot of trouble, as it is depracated on Expo Go. Because of this issue, we decided to start from scratch with Flutter and built the app template.

2) Adding Google Sign-In Capability, Firebase Storage : We added the google sign in button, as well as email sign in. These users were able to be stored in our firebase database, as shown in the demo video.

3) Implementing Camera, API Calls, Daily Intake Page: We were able to route the button to go to the barcode scanner. We also added the ability to call from the FDA API and added an daily intake page with shows all of the food entries from each day. 

4) Testing, Fixing Bugs, Improving UI: We had some bugs with getting the right number of calories from the API and updating correctly. After changing the order of code, we were able to fix thiss. We also added an onboarding page with an image of a heart and a "get started" button.

## Project Diagram
![MiniProject](https://user-images.githubusercontent.com/36130616/133674965-4e17602c-2675-4e7e-aa6f-d0ca7c349499.png)

## Project structure
Folders are grouped by feature/page. Each feature may define its own models and view models.

Services and routing classes are defined at the root, along with constants and common widgets shared by multiple features.

/lib
  /app
    /home
      /account
      /entries
      /models
      /recipe_entries
      /recipes
    /onboarding
    /sign_in
  /common_widgets
  /constants
  /routing
  /services

## Running the project with Firebase

To use this project with Firebase, some configuration steps are required. We did not upload the `GoogleService-Info.plist` file nor the reversed Client ID in the `Info.plist` onto the GitHub because we wanted to keep our API keys secure.

- Create a new project with the Firebase console.
- Add iOS and Android apps in the Firebase project settings.
- On Android, use `com.example.starter_architecture_flutter_firebase` as the package name.
- then, [download and copy](https://firebase.google.com/docs/flutter/setup#configure_an_android_app) `google-services.json` into `android/app`.
- On iOS, use `com.example.calorieTracker2021` as the bundle ID.
- Then [download and copy](https://firebase.google.com/docs/flutter/setup#configure_an_ios_app) `GoogleService-Info.plist` into `iOS/Runner`, and add it to the Runner target in Xcode.
- Also, add the google reversed clietn ID found on the firebase into the appropriate line on the `Info.plist` file. It is found under the "<key>CFBundleURLSchemes</key>" line.
- finally, enable the Email/Password Authentication Sign-in provider in the Firebase Console (Authentication > Sign-in method > Email/Password > Edit > Enable > Save)

See this page for full instructions:

- [FlutterFire Overview](https://firebase.flutter.dev/docs/overview) 

## Challenges
- GITHUB SECRETS: We attempted to use GitHub secrets to store the API keys that we wanted to keep secure. We tried writing a script in GitHub workflow under GitHub actions, referencing the secrets made using ${{SECRET KEY}}. However, we were unable to make this work in the interest of time. For this reason, we did not upload the Google reversed client ID onto GitHub and instead prompted the user to input it manually when running the program. 

## Packages

- `firebase_auth` for authentication
- `cloud_firestore` for the remote database
- `flutter_riverpod` for dependency injection and propagating stream values down the widget tree
- `rxdart` for combining multiple Firestore collections as needed
- `intl` for currency, date, time formatting
- `mockito` for testing
- `equatable` to reduce boilerplate code in model classes

Also imported from the [flutter_core_packages repo](https://github.com/bizz84/flutter_core_packages):

- `firestore_service`
- `custom_buttons`
- `alert_dialogs`
- `email_password_sign_in_ui`

## UI Designs
![IMG_5606](https://user-images.githubusercontent.com/36130616/133692868-d67782c3-5462-4ae2-9888-4b2e0524e9bb.JPG)

## Sources

The following were used as resources in our project:

- [Starter Architecture Demo for Flutter & Firebase Realtime App ](https://github.com/bizz84/starter_architecture_flutter_firebase
)
- [Flutter Barcode Scanner Tutorial](https://pub.dev/packages/flutter_barcode_scanner)
- [Article about GitHub Secrets and Actions](https://dev.to/n3wt0n/how-secrets-work-in-github-and-how-to-manage-them-p4o)
- [Flutter Button Article](https://www.javatpoint.com/flutter-buttons)




