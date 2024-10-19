# WhatsApp Clone

[![WhatsApp Clone Demo](https://github.com/user-attachments/assets/487f662b-9eaf-449c-ac2c-14d9f48894c9)

## Overview
This is a fully functional WhatsApp clone built using **SwiftUI**, **Firebase**, and **Combine**. The app allows users to chat in real-time, share images, and maintain a persistent message history, leveraging Firebase for authentication, real-time data storage, and media handling. We also use **Kingfisher** for image caching and downloading, ensuring smooth image loading in chat.

## Features
- User Authentication (Sign Up, Sign In, Sign Out)
- Real-time messaging using Firebase Realtime Database
- Image uploading & caching with Kingfisher
- Firebase Push Notifications
- SwiftUI-based modern UI/UX
- Combine framework for reactive programming

## Technologies Used
- **SwiftUI**: For building the user interface
- **Firebase**: Backend for authentication, real-time database, and cloud storage
- **Combine**: For managing asynchronous data streams
- **Kingfisher**: For handling image caching and downloading

## Installation

### Prerequisites
- Xcode 14.0+
- Swift 5.7+
- A Firebase account
- Cocoapods installed (if not installed, [click here to install](https://cocoapods.org))

### Step 1: Clone the Repository
"zsh"
git clone https://github.com/your-username/whatsapp-clone.git
cd whatsapp-clone

### Step 2: Install Dependencies

#### Firebase Setup

1. Go to [Firebase Console](https://console.firebase.google.com/) and create a new project.
2. Add an iOS app to your Firebase project. You'll need to provide the iOS bundle ID (you can find this in your Xcode project settings).
3. Download the `GoogleService-Info.plist` file and add it to your Xcode project by dragging it into the project navigator.
4. Enable the following Firebase services:
   - **Authentication**
   - **Cloud Firestore**
   - **Cloud Storage**
5. Install Firebase package via Swift Package Manager


