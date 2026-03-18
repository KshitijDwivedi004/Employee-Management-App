<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Employee Management</title>

    <!-- Bootstrap 5 CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
          rel="stylesheet">

    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css"
          rel="stylesheet">

    <style>
        body { background-color: #f8f9fa; }
        .navbar-brand { font-weight: 600; letter-spacing: 0.5px; }
        .table-hover tbody tr:hover { background-color: #e8f0fe; }
        .search-box { max-width: 320px; }
        .badge-dept {
            background-color: #e3f2fd;
            color: #1565c0;
            font-weight: 500;
            padding: 4px 10px;
            border-radius: 12px;
        }
    </style>
</head>
<body>

<!-- Navbar -->
<nav class="navbar navbar-expand-lg navbar-dark bg-primary mb-4 shadow-sm">
    <div class="container">
        <a class="navbar-brand" href="/employees">
            <i class="bi bi-people-fill me-2"></i>Employee Management
        </a>
        <div class="ms-auto">
            <a href="/employees/new" class="btn btn-light btn-sm">
                <i class="bi bi-person-plus-fill me-1"></i>Add Employee
            </a>
        </div>
    </div>
</nav>
