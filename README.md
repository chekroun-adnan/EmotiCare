# EmotiCare

**EmotiCare** is a comprehensive mental health support platform designed to provide accessible and secure emotional well-being resources. This project consists of a robust Spring Boot backend and a responsive Flutter mobile application.

## 🚀 Key Features

*   **Secure Authentication**: User registration and login utilizing JWT (JSON Web Tokens) for secure session management.
*   **Mental Health Resources**: Access to curated content and tools for emotional support.
*   **Mobile First**: Native mobile experience built with Flutter for iOS and Android.
*   **RESTful API**: Scalable backend architecture.

## 🛠 Technology Stack

### Backend (`/EmotiCare`)
*   **Language**: Java 21
*   **Framework**: Spring Boot 3.5.7
*   **Database**: MongoDB
*   **Security**: Spring Security, JWT (io.jsonwebtoken)
*   **Documentation**: SpringDoc OpenAPI (Swagger UI)
*   **Build Tool**: Maven

### Frontend (`/Frontend`)
*   **Framework**: Flutter (SDK 3.9.2+)
*   **State Management**: Riverpod
*   **Routing**: Go Router
*   **Networking**: Dio
*   **Storage**: Flutter Secure Storage

## 🏁 Getting Started

### Prerequisites
*   **Java 21**: Ensure JDK 21 is installed and `JAVA_HOME` is set.
*   **Flutter SDK**: [Install Flutter](https://docs.flutter.dev/get-started/install).
*   **MongoDB**: A running MongoDB instance (local or Atlas).

### Backend Setup
1.  Navigate to the backend directory:
    ```bash
    cd EmotiCare
    ```
2.  Configure your environment variables (if required) or ensure MongoDB is running on the default port.
3.  Run the application using the Maven wrapper:
    ```bash
    ./mvnw spring-boot:run
    ```
    *(On Windows CMD use `mvnw spring-boot:run`)*

### Frontend Setup
1.  Navigate to the frontend directory:
    ```bash
    cd Frontend/emoticare_frontend
    ```
2.  Install dependencies:
    ```bash
    flutter pub get
    ```
3.  Run the application:
    ```bash
    flutter run
    ```

## 🤝 Contributing
Contributions are welcome! Please fork the repository and submit a pull request for any enhancements or bug fixes.
