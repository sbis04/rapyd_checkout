# Slibro [![Codemagic build status](https://api.codemagic.io/apps/6240c24a66f743ede7aca591/android-workflow/status_badge.svg)](https://codemagic.io/apps/6240c24a66f743ede7aca591/android-workflow/latest_build)

![](screenshots/slibro-dev-cover.png)

**Slibro** is a story writing platform that supports short and long format stories. [Flutter](https://flutter.dev/) and [Appwrite](https://appwrite.io/) is used to create this amazing cross-platform experience.

> Try out the app on Android from [here](https://appdistribution.firebase.dev/i/3fc14b5839069d3c).

![](screenshots/slibro-cross-platform-2.png)

## Usage

To run this from your system, you should have:

1. [Flutter SDK](https://docs.flutter.dev/get-started/install) installed and configured on your system.
2. Setup Appwrite using Docker.
3. Host the server locally using [ngrok](https://ngrok.com/).
4. Under `lib` directory, create a `secret.dart` file, and add the server URL and Appwrite project ID to it. Example:

    ```dart
    class Secrets {
      static String hostname = 'https://127b-203-163-244-125.in.ngrok.io/v1';
      static String projectID = '6276341092e81e829ab0';
    }
    ```
5. Run using the following command:

   ```sh
   flutter run
   ```

## App Overview

The app now has full-fledged **story editor** (rich text - markdown), **story reader**, and **story management system** (to manage published/unpublished stories and explore other publisher's stories).

Some glimpses of Slibro's user interface are as follows:

![Slibro Auth Screens](screenshots/slibro-auth-screens.png)

The above four screens cover the authentication flow on the app using email/password method. These screens help a user to either create a new account or login using an existing account. Once a user signs up to the app, it navigates to the story creation flow.
 
![Slibro Story Detail Screens](screenshots/slibro-screens-2.png)

These screens help a user to create the first story as a draft in the Slibro app. The user can also publish the story if wanted.

![Slibro Editor and Reader Screens](screenshots/slibro-screens-3.1.png)

The editor and the reader screens are the most important ones, the editor also has rich text support using Markdown.

![Slibro Dashboard Screens](screenshots/slibro-screens-4.png)

The three screens (Home, My Stories, and My Profile) shown above are part of the dashboard of the app, user can navigate to any of these using the Navigation bar accessible from these pages.

Navigation bar has a subtle animation to improve the UX of the app:

![Navigation bar animation](screenshots/navbar-anim.gif)

## Appwrite APIs

Three of the major Appwrite APIs are used:

* [Account API](https://appwrite.io/docs/client/account?sdk=flutter-default): Used for implementing user authentication and user data management.
* [Database API](https://appwrite.io/docs/client/database?sdk=flutter-default): Used for storing app data related to stories and chapters.
* [Storage API](https://appwrite.io/docs/client/storage?sdk=flutter-default): Used for storing the Rich Text story file in JSON format.

## Flutter packages

The following Flutter packages are used to build this app:

* [appwrite](https://pub.dev/packages/appwrite)
* [flutter_quill](https://pub.dev/packages/flutter_quill)
* [path_provider](https://pub.dev/packages/path_provider)
* [shared_preferences](https://pub.dev/packages/shared_preferences)
* [google_nav_bar](https://pub.dev/packages/google_nav_bar)
* [tuple](https://pub.dev/packages/tuple)

## License

Copyright (c) 2022 Souvik Biswas

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
