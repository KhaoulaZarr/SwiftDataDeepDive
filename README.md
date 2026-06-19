# SwiftDataDeepDive
A complete SwiftUI and SwiftData learning project that progressively builds a real-world To-Do application while exploring the most important SwiftData concepts.

# Projects 
# MyToDos (To-Do List App in SwiftUI )

# Level: Beginner

# Topics Covered 

## 1. Build a To-Do List App in SwiftUI

Learn how to create a modern To-Do application using SwiftUI and SwiftData from scratch.

# CachingAPIResponseSwiftData

# Level: Beginner

# Topics Covered 

## 2. Persist API Responses
Learn how to save API responses into SwiftData, cache data locally, and store images for offline access.

This project is designed for iOS developers who want to move beyond the basics and gain practical experience with SwiftData through a real-world application.

# RelationShipsTutorial

Expand the To-Do application by introducing relationships, advanced queries, data initialization, and migrations.

# Level: Intermediate

# Topics Covered 

## 3. Relationships in SwiftData

Add categories to your tasks and understand one-to-many relationships between models.

## 4. Search & Filtering

Implement powerful filtering using SwiftUI's searchable modifier and SwiftData queries.

## 5. Sorting Data

Learn multiple ways to sort SwiftData records and create a better user experience with customizable sorting options.

## 6. Preload Default Data

Discover how to populate your app with default categories when the application launches for the first time.

## 7. Import JSON Data
Use JSON and Codable to prefill your SwiftData ModelContainer with sample data.

## 8. Prefill the App with Default To-Dos on First Launch

Learn how to preload SwiftData models that contain relationships and automatically populate the app with default To-Dos and categories when the app launches for the first time.

## 9. How To Use SwiftData with SwiftUI Previews

Explore common SwiftData preview issues, learn how to create preview data, configure preview containers, and discover tips and tricks for building better SwiftUI Previews.

## 10. SwiftData Migrations & Schema Versioning

Learn how to evolve your SwiftData models using VersionedSchema, perform lightweight and custom migrations, and manage schema changes with a MigrationPlan. Discover when to use each migration type and how to safely update your data model as your app grows. 
You can test and inspect your migrations using tools such as SimPholders and SQLite database browsers to verify schema changes and data transformations.

# SwiftDataBackgroundThreads

# Level: Advanced

## 11. SwiftData Background threads

Learn how to improve application performance by using SwiftData Background Tasks.
While SwiftData's @Query macro provides a simple and powerful way to fetch and manage data, all operations run on the main thread by default. This works well for small datasets, but can become a performance bottleneck when fetching or saving large amounts of data. In this project, you'll learn how to use ModelActor and background contexts to perform heavy SwiftData operations off the main thread, keeping your UI responsive and your app running smoothly.
