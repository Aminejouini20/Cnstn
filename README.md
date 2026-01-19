# CNSTN 2026 - Flutter App (Room & Material Management)

## 🚀 Project Overview

CNSTN 2026 is a Flutter mobile application designed for the **National Nuclear Center of Tunisia (CNSTN)**.  
The application provides a **digital solution for room reservation and material request** inside the institution.  

The goal of this project is to build a **modern management system** that allows:

- **Employees** to reserve meeting rooms and request materials.
- **Admins** to validate or reject requests.
- **Admins** to manage users and their roles.
- A complete authentication system using **Firebase Authentication**.
- A **real-time database** with **Firestore** for data storage.

---

## 🧩 Features

### ✅ User Features
- Register / Login / Reset Password
- Reserve a room
- Request materials
- View their own reservations and requests
- Edit profile (name, email, profile picture)

### 🛠️ Admin Features
- Validate or reject room reservations
- Validate or reject material requests
- View total users, pending reservations, pending requests
- Manage user roles (User ↔ Admin)

---

## 🔥 Technologies Used

- Flutter (Dart)
- Firebase Authentication
- Firebase Firestore
- Firebase Storage
- Flutter UI Components
- State management (simple setState / StreamBuilder)

---

## 🗂️ Firestore Structure (Collections & Documents)

### 1️⃣ Collection: `users`

Each document ID = `uid` (from Firebase Auth)

📌 Fields:

| Field | Type | Description |
|------|------|-------------|
| uid | String | User ID (Firebase Auth) |
| name | String | Full name |
| email | String | Email address |
| role | String | `user` or `admin` |
| profileImage | String | URL of profile image |
| direction | String | Employee department (new field) |
| poste | String | Employee job position (new field) |
| createdAt | Timestamp | Account creation time |

---

### 2️⃣ Collection: `room_reservations`

Each document ID is auto-generated.

📌 Fields:

| Field | Type | Description |
|------|------|-------------|
| userId | String | User who reserved |
| roomId | String | Room identifier |
| date | Timestamp | Reservation date |
| startTime | String | Start time |
| endTime | String | End time |
| status | String | `pending` / `approved` / `rejected` |
| adminComment | String | Admin message |
| createdAt | Timestamp | Request time |

---

### 3️⃣ Collection: `material_requests`

Each document ID is auto-generated.

📌 Fields:

| Field | Type | Description |
|------|------|-------------|
| userId | String | User who requested |
| materialName | String | Material name |
| quantity | int | Quantity requested |
| reason | String | Request reason |
| status | String | `pending` / `approved` / `rejected` |
| adminComment | String | Admin message |
| createdAt | Timestamp | Request time |

---

## 📚 Models (Dart Classes)

### `UserModel`
```dart
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
