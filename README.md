# ControlX

## Overview
ControlX is a Flutter-based mobile application that allows users to remotely control their laptop over a local network. The app communicates with a Node.js server running on the laptop to execute system commands and retrieve real-time system information. It is built using Clean Architecture with BLoC for scalable and maintainable development.

---

## Features
- Authentication using Firebase Authentication  
- Secure device connection over local network (LAN)  
- Remote command execution (open apps, shutdown, restart, lock screen)  
- Real-time connection and system updates using WebSockets  
- System monitoring (CPU, RAM, OS info)  
- Clean Architecture with modular structure  
- Responsive UI using Material 3  

---

## Screenshots


## Tech Stack

### Frontend
- Flutter  
- flutter_bloc (State Management)  
- Dio (API communication)  
- socket_io_client (Real-time communication)  
- Firebase Authentication (Google Sign-In)  

### Backend
- Node.js  
- Express.js  
- Socket.io  
- child_process (system command execution)  
- os module (system information)  

---

## Project Structure
```text
lib/
├── core/
├── features/
│ └── control/
│ ├── data/
│ ├── domain/
│ └── presentation/
├── injection_container.dart
└── main.dart
```


---

## Workflow
1. Start the Node.js server on the laptop.  
2. Connect mobile and laptop to the same WiFi network.  
3. Login using Firebase Sign-In.  
4. Enter the laptop IP address and establish connection.  
5. Send commands from the mobile app.  
6. Node.js server executes commands on the laptop.  
7. Real-time system data is sent back and displayed in the app.  

---

## Setup Instructions

### Backend (Node.js)
```bash
cd Backend
npm install
node server.js
```

### Frontend
```bash
flutter pub get
flutter run
```

---

## Development
Control X uses the `dev` branch for active feature development and `main` for stable releases.