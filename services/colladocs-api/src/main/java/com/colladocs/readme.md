# what the folders mean

```commandline
└── colladocs
    ├── dto                   # Data Transfer Objects for client communication
    │   ├── DocumentDto.java
    │   └── UserDto.java
    ├── dao                   # Data Access Objects for database interactions
    │   ├── DocumentDao.java
    │   └── UserDao.java
    ├── model                 # Internal data models/entities
    │   ├── Document.java
    │   └── User.java
    ├── service               # Business logic layer
    │   ├── DocumentService.java
    │   └── UserService.java
    └── controller            # RESTful API endpoints
```


## DAOs:

DAOs interact with the database directly, performing CRUD (Create, Read, Update, Delete) operations.
DAOs return and receive model objects (e.g., Document, User) rather than DTOs.
This separation of data access from business logic keeps the code organized and more manageable, especially when database schemas change.
DTOs:

DTOs are used in the controller layer to structure data sent to or received from clients.
DTOs isolate the internal model from external API exposure, allowing control over what data is accessible to clients.
In the service layer, DTOs are typically converted to model objects before interacting with DAOs.