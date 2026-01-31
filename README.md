📱 CNSTN 2026 – Flutter App

Room & Material Management System

🚀 Project Overview

CNSTN 2026 is a Flutter mobile and web application developed for the Centre National des Sciences et Technologies Nucléaires (CNSTN – Tunisia).

It provides a digital internal management system for:

🏢 Room Reservations

🧰 Material Requests

👥 User and Role Management

The app replaces manual, paper-based processes with a secure, real-time, role-based solution, built with Flutter and Firebase, following a clean and modular architecture.

🎯 Objectives

Digitize internal administrative processes

Centralize room and material requests

Simplify validation workflows for administrators

Ensure data security and traceability

Provide a modern, scalable Flutter solution

👥 User Roles
👤 Employee

Register, login, and reset password

Submit room reservations

Submit material requests

Track personal requests and their status

Update personal profile and information

🛡️ Administrator

View all room reservations

Approve or reject room reservations

View all material requests

Approve or reject material requests

Manage users and roles (Admin / Employee)

🧩 Features
✅ Authentication & Security

User registration & login

Password reset

Role-based access control

Firebase Authentication

👤 Profile Management

Update personal information

Upload and update profile image

Profile images stored using Cloudinary

Image URLs saved in Firestore

🏢 Room Reservation Management

Submit room reservation requests

Select date and time slots

Admin validation (approve / reject)

Request status tracking

🧰 Material Request Management

Submit material requests

Specify quantity and reason

Admin validation (approve / reject)

Request status tracking

🔥 Technologies Used

Flutter (Dart)

Firebase Authentication

Cloud Firestore

Cloudinary (for profile image storage)

Material UI

Real-time data streams using StreamBuilder

🗂️ Firestore Database Structure

📁 Collection: users
Field	Type	Description
id / uid	String	Firebase Authentication uid
name	String	Full name
email	String	Email address
role	String	admin / employee
profileImage	String	Cloudinary image URL
direction	String	Department
position	String	Job position
createdAt	Timestamp	Account creation date

📁 Collection: room_reservations

Field	Type	Description
id	String	Document ID
userId	String	Request owner
requesterName	String	User full name
direction	String	User direction
reason	String	Purpose of reservation
timeSlot	String	Reserved time slot
participants	int	Number of participants
status	String	pending / approved / rejected
adminComment	String	Admin note
reservationDate	Timestamp	Requested date
createdAt	Timestamp	Request creation date

📁 Collection: material_requests

Field	Type	Description
id	String	Document ID
userId	String	Request owner
requesterName	String	User full name
direction	String	User direction
article	String	Requested material
technicalDetails	String	Technical details / specs
justification	String	Reason for request
status	String	pending / approved / rejected
adminComment	String	Admin note
createdAt	Timestamp	Request creation date

📚 Data Models (Dart)

UserModel
class UserModel {
  final String id;
  final String name;
  final String email;
  final String role;
  final String profileImage;
  final String direction;
  final String position;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.profileImage,
    required this.direction,
    required this.position,
  });
}

RoomReservationModel
class RoomReservationModel {
  final String id;
  final String userId;
  final String requesterName;
  final String direction;
  final String reason;
  final String timeSlot;
  final int participants;
  final String status;
  final String adminComment;
  final DateTime reservationDate;
  final DateTime createdAt;
}

MaterialRequestModel
class MaterialRequestModel {
  final String id;
  final String userId;
  final String requesterName;
  final String direction;
  final String article;
  final String technicalDetails;
  final String justification;
  final String status;
  final String adminComment;
  final DateTime createdAt;
}

🏗️ Project Architecture (Clean Architecture)
lib/
│
├── main.dart
│
├── core/
│   ├── theme.dart                # App theming (colors, fonts, styles)
│   ├── app_routes.dart            # Named routes for navigation
│   └── widgets/
│       ├── app_button.dart        # Custom button widget
│       └── app_text_field.dart    # Custom text field widget
│
├── services/
│   ├── auth_service.dart          # Firebase Authentication logic
│   ├── firestore_service.dart     # CRUD operations for Firestore
│   ├── firestore_seed.dart        # Optional: initial data seeding
│   └── cloudinary_service.dart    # Upload profile images to Cloudinary
│
├── models/
│   ├── user_model.dart
│   ├── material_request_model.dart
│   └── room_reservation_model.dart
│
├── pages/
│   ├── auth/
│   │   ├── login_page.dart
│   │   ├── register_page.dart
│   │   └── reset_password_page.dart
│   │
│   ├── user/
│   │   ├── user_home_page.dart
│   │   ├── user_dashboard_page.dart
│   │   ├── material_request_form.dart
│   │   ├── my_material_requests_page.dart
│   │   ├── room_reservation_form.dart
│   │   └── my_room_reservations_page.dart
│   │
│   └── admin/
│       ├── admin_home_page.dart
│       ├── admin_users_page.dart
│       ├── admin_material_requests_page.dart
│       ├── material_requests_validation_page.dart
│       ├── admin_room_reservations_page.dart
│       └── room_reservations_validation_page.dart
├── utils/
    ├── constants.dart             # Colors, strings, Cloudinary URL
    └── helpers.dar
🔐 Security Rules Overview

Users can access only their own requests

Users can delete only pending requests

Admins have full access for validation and user management

Role-based access control is enforced via Firestore rules

📌 Project Status

✔ Core features implemented
✔ Android & Web supported
🚧 UI refinements and performance optimization ongoing

👨‍💻 Author

Mohamed Amine JOUINI
Flutter Developer
Internship Project – CNSTN 2026
