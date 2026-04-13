# Employee Master App

This is a Flutter application submitted as part of the assignment. I have implemented all the requested features and kept the UI responsive and clean.

## Features Implemented

- **Login Screen:** Built using Firebase Authentication. As requested, there is no registration page in the app. You can log in using the pre-created valid credentials provided below.
- **Manage Employees:** You can add, edit, and delete employee records directly from the main screen.
- **Employee List:** Displays all the saved employees in the database.
- **Search:** Added a search bar at the top to easily filter employees by their name or employee code.

## Database Fields
The employee data structure includes the exact fields requested:
- EmpCode (Used as the Primary Key)
- EmpName
- Mobile
- DOB
- Date Of Joining
- Salary
- Address
- Remark

## Technical Details

- **State Management:** I used the **BLoC** state management library across the project.
- **Database Storage:** The assignment mentioned choosing either Local Storage (SQLite) or Firebase Database. I have actually set up **both**. The app relies on Firebase by default, but it's structured using clean architecture so the data source can be switched.
- **Primary Key:** EmpCode is strictly used as the unique identifier/primary key for storing and updating records.

## Add-on / Extra Features
- **Dark & Light Mode:** Added a theme switch button in the app bar.
- **Form Validations:** The add/edit form includes standard validations for mobile logic, dates, and required fields to prevent bad data submission.
- **Responsive UI:** The design adjusts nicely whether you run it on a mobile device or a larger desktop/web screen.

## How to Run
1. Make sure Flutter SDK is installed and set up.
2. Open the project directory in your terminal.
3. Run `flutter pub get` to install the packages.
4. Run the app using `flutter run`.

## Test Login Credentials
Please use this account to log in and test the app:
- **Email:** admin@test.com
- **Password:** 123456
