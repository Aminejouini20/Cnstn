📱 CNSTN 2026 – Flutter App
Room & Material Management System
🚀 Project Overview

CNSTN 2026 is a Flutter mobile & web application developed for the
Centre National des Sciences et Technologies Nucléaires (CNSTN – Tunisia).

The application provides a digital internal management system for:

🏢 Room reservation

🧰 Material request

👥 User and role management

It replaces manual and paper-based procedures with a secure, real-time, role-based solution built using Flutter and Firebase, following a clean and modular architecture.

🎯 Objectives

Digitize internal administrative processes

Centralize room and material requests

Simplify validation workflows for administrators

Ensure data security and traceability

Provide a modern, scalable Flutter solution

👥 User Roles
👤 Employee

Register and authenticate

Request room reservations

Request materials

Track personal requests and their status

Manage personal profile and information

🛡️ Administrator

View all room reservations

Approve or reject reservations

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

Profile image URLs saved in Firestore

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

Cloudinary (profile image storage)

Material UI

Real-time data streams (StreamBuilder)

🗂️ Firestore Database Structure
📁 Collection: users

Document ID = Firebase Authentication uid

Field	Type	Description
uid	String	User ID
name	String	Full name
email	String	Email address
role	String	admin or employee
profileImage	String	Cloudinary image URL
direction	String	Department
poste	String	Job position
createdAt	Timestamp	Account creation date
📁 Collection: room_reservations
Field	Type	Description
userId	String	Request owner
roomName	String	Room identifier
date	Timestamp	Reservation date
startTime	String	Start time
endTime	String	End time
status	String	pending, approved, rejected
adminComment	String	Admin note
createdAt	Timestamp	Request date
📁 Collection: material_requests
Field	Type	Description
userId	String	Request owner
materialName	String	Material name
quantity	int	Requested quantity
reason	String	Request justification
status	String	pending, approved, rejected
adminComment	String	Admin note
createdAt	Timestamp	Request date
📚 Data Models (Dart)
UserModel
class UserModel {
  final String uid;
  final String name;
  final String email;
  final String role;
  final String profileImage;
  final String direction;
  final String poste;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.role,
    required this.profileImage,
    required this.direction,
    required this.poste,
  });
}

🏗️ Project Architecture (Clean Architecture)
lib/
│
├── models/
│   ├── user_model.dart
│   ├── room_reservation_model.dart
│   └── material_request_model.dart
│
├── services/
│   ├── auth_service.dart
│   ├── firestore_service.dart
│   └── cloudinary_service.dart
│
├── pages/
│   ├── auth/
│   │   ├── login_page.dart
│   │   └── register_page.dart
│   │
│   ├── user/
│   │   ├── home_page.dart
│   │   ├── profile_page.dart
│   │   ├── room_request_page.dart
│   │   └── material_request_page.dart
│   │
│   └── admin/
│       ├── dashboard_page.dart
│       ├── room_validation_page.dart
│       └── material_validation_page.dart
│
├── widgets/
│   ├── custom_button.dart
│   └── custom_textfield.dart
│
└── main.dart

🔐 Security Rules Overview

Users can access only their own data

Admins can validate and manage all requests

Role-based access enforced via Firestore rules

No public write access

📌 Project Status

✔ Core features implemented
✔ Android & Web supported
🚧 UI refinements and performance optimization ongoing

👨‍💻 Author

Mohamed Amine JOUINI
Flutter Developer
Internship Project – CNSTN
