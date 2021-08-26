A lot of files in this project are not commited into the repo and you have to set them up properly first.

- `android/app/src/main/AndroidManifest.xml` - rename the sample file provided in the same path.
- `android/app/google-services.json` - create this from Firebase console. This is for push notification and google sign-in.
- `android/app/key.jks` - apk signing key, [you can create this by yourself](https://developer.android.com/studio/publish/app-signing).
- `android/key.properties` - credentials for the key above. [guide here](https://developer.android.com/studio/publish/app-signing#secure-shared-keystore).
- `lib/src/core/in-app-purchase.dart` - rename the sample file provided in the same path.
- `lib/src/core/mal.client.dart` - rename the sample file provided in the same path.
- `lib/src/core/api_key.dart` - rename the sample file provided in the same path.

Once you have all the files set up. You can try to run `flutter run` or `flutter build`

**NOTE**: This flutter app has not been set up for iOS yet.

# Backend API
The backend for this app is currently closed-source. I provided mock data using mock services in the code. You can test the functions through them instead.

I will also try to update the mock data from time to time.

# Push Notifications
You can send push notification through FCM api.

# Contributions
Since the backend is closed-source, the type of contribution you'll probably be able to do are mostly frontend stuffs. Like design improvements or user-experience.