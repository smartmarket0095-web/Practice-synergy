IF DB_ID(N'TourismWeb') IS NULL
    CREATE DATABASE TourismWeb;
GO

USE TourismWeb;
GO

IF OBJECT_ID(N'dbo.Orders', N'U') IS NOT NULL DROP TABLE dbo.Orders;
IF OBJECT_ID(N'dbo.Tours', N'U') IS NOT NULL DROP TABLE dbo.Tours;
IF OBJECT_ID(N'dbo.Clients', N'U') IS NOT NULL DROP TABLE dbo.Clients;
IF OBJECT_ID(N'dbo.TourTypes', N'U') IS NOT NULL DROP TABLE dbo.TourTypes;
GO

CREATE TABLE dbo.TourTypes (
    TourTypeId INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(80) NOT NULL UNIQUE,
    Description NVARCHAR(255) NULL
);

CREATE TABLE dbo.Clients (
    ClientId INT IDENTITY(1,1) PRIMARY KEY,
    FullName NVARCHAR(150) NOT NULL,
    Phone NVARCHAR(30) NOT NULL UNIQUE,
    Email NVARCHAR(120) NULL
);

CREATE TABLE dbo.Tours (
    TourId INT IDENTITY(1,1) PRIMARY KEY,
    TourTypeId INT NOT NULL,
    Name NVARCHAR(150) NOT NULL,
    Destination NVARCHAR(120) NOT NULL,
    StartDate DATE NOT NULL,
    EndDate DATE NOT NULL,
    Price DECIMAL(10,2) NOT NULL,
    SeatsTotal INT NOT NULL,
    CONSTRAINT FK_Tours_TourTypes
        FOREIGN KEY (TourTypeId) REFERENCES dbo.TourTypes(TourTypeId),
    CONSTRAINT CK_Tours_Dates CHECK (EndDate >= StartDate),
    CONSTRAINT CK_Tours_Price CHECK (Price >= 0),
    CONSTRAINT CK_Tours_Seats CHECK (SeatsTotal > 0)
);

CREATE TABLE dbo.Orders (
    OrderId INT IDENTITY(1,1) PRIMARY KEY,
    ClientId INT NOT NULL,
    TourId INT NOT NULL,
    OrderDate DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    Persons INT NOT NULL,
    Status NVARCHAR(30) NOT NULL DEFAULT N'Новый',
    TotalAmount DECIMAL(10,2) NOT NULL,
    CONSTRAINT FK_Orders_Clients FOREIGN KEY (ClientId) REFERENCES dbo.Clients(ClientId),
    CONSTRAINT FK_Orders_Tours FOREIGN KEY (TourId) REFERENCES dbo.Tours(TourId)
);
GO

INSERT INTO dbo.TourTypes (Name, Description) VALUES
(N'Пляжный отдых', N'Отдых на море'),
(N'Экскурсионный', N'Экскурсии и культурные программы'),
(N'Горный', N'Активный отдых');

INSERT INTO dbo.Tours
(TourTypeId, Name, Destination, StartDate, EndDate, Price, SeatsTotal)
VALUES
(1, N'Отдых в Анталье', N'Анталья', '2026-06-10', '2026-06-17', 850, 30),
(2, N'Экскурсия по Праге', N'Прага', '2026-07-05', '2026-07-10', 720, 20),
(3, N'Горный тур', N'Алматы', '2026-08-15', '2026-08-18', 450, 15);
GO
