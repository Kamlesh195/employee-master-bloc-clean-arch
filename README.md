# Employee Master App

This is a Flutter application created for managing employee records. I built this app to complete the assignment requirements using clean and functional code.

## Features

- **Login Authentication:** Uses Firebase Authentication. There is no signup page as per the requirement. You can log in using the pre-created test credentials given below.
- **Manage Employees:** Ability to Add, Edit, and Delete employees from the system.
- **View Saved Records:** Displays all the saved employees in a clear list/grid.
- **Search Functionality:** A search bar to filter employees by their exact name or employee code.

## Stored Fields
The employee data structure contains all the requested properties:
- EmpCode (Primary Key)
- EmpName
- Mobile
- DOB
- Date Of Joining
- Salary
- Address
- Remark

## Technical Info

- **State Management:** I used the **BLoC** pattern throughout the app for maintaining states cleanly.
- **Database Used:** The assignment asked to pick either Local Storage (SQLite) or Firebase Database. I have implemented **both**. By default, it runs on Firebase, but the code is structured so the data source can be switched easily.
- **Unique Identifier:** EmpCode is strictly acts as the primary key.

## Extra Add-on Features
- **Dark/Light Theme:** Added a moon/sun icon at the top to toggle the theme.
- **Basic Validations:** Form fields check for valid inputs before saving data (like valid numbers and not leaving fields blank).
- **Responsive Layout:** The design adapts and looks good whether it's running on a mobile screen or web/desktop.

## Steps to Run
1. Make sure you have the Flutter SDK installed.
2. Open terminal in the project folder.
3. Run `flutter pub get` to download the packages.
4. Run the app using `flutter run`.

## Test Login Credentials
Please use this account to login to the app:
- **Email:** admin@test.com
- **Password:** 123456
