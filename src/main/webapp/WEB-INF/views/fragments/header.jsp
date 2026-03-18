<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Employee Management System - Manage your employees effectively">
    <title>Employee Management</title>

    <!-- Bootstrap 5 CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
          rel="stylesheet">

    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css"
          rel="stylesheet">

    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">

    <style>
        * {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
        }

        body {
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            min-height: 100vh;
            background-attachment: fixed;
            color: #2c3e50;
        }

        /* Navbar Styling */
        .navbar {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%) !important;
            box-shadow: 0 4px 20px rgba(102, 126, 234, 0.3);
            padding: 1rem 0;
        }

        .navbar-brand {
            font-weight: 700;
            letter-spacing: 0.5px;
            font-size: 1.4rem;
            color: white !important;
            transition: all 0.3s ease;
        }

        .navbar-brand:hover {
            transform: scale(1.05);
        }

        .navbar-brand i {
            color: #fff;
            font-size: 1.6rem;
        }

        /* Add button in navbar */
        .navbar .btn {
            transition: all 0.3s ease;
            font-weight: 600;
            letter-spacing: 0.3px;
        }

        .navbar .btn-light {
            background-color: rgba(255, 255, 255, 0.95);
            border: none;
            color: #667eea;
        }

        .navbar .btn-light:hover {
            background-color: white;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
            transform: translateY(-2px);
        }

        /* Container adjustments */
        .container {
            padding: 2rem 1rem;
        }

        /* Table improvements */
        .table {
            font-size: 0.95rem;
        }

        .table thead th {
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            font-size: 0.85rem;
        }

        .table tbody tr {
            transition: all 0.2s ease;
            border-bottom: 1px solid #ecf0f1;
        }

        .table tbody tr:hover {
            background-color: #f8f9ff;
            transform: scale(1.001);
        }

        /* Badge styling */
        .badge {
            padding: 0.5rem 0.75rem;
            border-radius: 8px;
            font-weight: 600;
            font-size: 0.85rem;
        }

        .bg-info {
            background-color: #e3f2fd !important;
            color: #1565c0 !important;
        }

        /* Form improvements */
        .form-control, .form-select {
            border-radius: 8px;
            border: 2px solid #e9ecef;
            transition: all 0.3s ease;
            font-size: 0.95rem;
        }

        .form-control:focus, .form-select:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.15);
        }

        /* Button improvements */
        .btn {
            border-radius: 8px;
            font-weight: 600;
            letter-spacing: 0.3px;
            transition: all 0.3s ease;
        }

        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(102, 126, 234, 0.3);
        }

        .btn-primary:active {
            transform: translateY(0);
        }

        .btn-outline-danger:hover {
            background-color: #dc3545;
        }

        .btn-outline-primary:hover {
            background-color: #667eea;
            border-color: #667eea;
            color: white;
        }

        /* Alert improvements */
        .alert {
            border: none;
            border-radius: 12px;
            font-weight: 500;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
        }

        .alert-success {
            background-color: #d4edda;
            color: #155724;
        }

        .alert-danger {
            background-color: #f8d7da;
            color: #721c24;
        }

        /* Card improvements */
        .card {
            border: none;
            border-radius: 12px;
            transition: all 0.3s ease;
            overflow: hidden;
        }

        .card:hover {
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
        }

        /* Breadcrumb */
        .breadcrumb {
            background-color: transparent;
            padding: 0;
        }

        .breadcrumb-item.active {
            color: #667eea;
            font-weight: 600;
        }

        .breadcrumb-item a {
            color: #667eea;
            text-decoration: none;
            transition: all 0.3s ease;
        }

        .breadcrumb-item a:hover {
            color: #764ba2;
            text-decoration: underline;
        }

        /* Text utility classes */
        .text-muted {
            color: #7f8c8d !important;
        }

        .text-success {
            color: #27ae60 !important;
        }

        /* Spinner enhanced */
        .spinner-border {
            border-width: 3px;
        }

        /* Smooth transitions */
        * {
            transition: background-color 0.2s ease, color 0.2s ease;
        }

        /* Utility for search box */
        .search-box {
            max-width: 320px;
            border-radius: 25px;
            border: 2px solid #e9ecef;
            padding: 10px 20px;
            transition: all 0.3s ease;
        }

        .search-box:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.15);
        }

        /* Animations */
        @keyframes slideDown {
            from {
                opacity: 0;
                transform: translateY(-10px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .animate-slide-down {
            animation: slideDown 0.3s ease-in;
        }

        /* Loading animation */
        .loading {
            pointer-events: none;
            opacity: 0.6;
        }

        /* Responsive adjustments */
        @media (max-width: 768px) {
            .navbar {
                padding: 0.75rem 0;
            }

            .navbar-brand {
                font-size: 1.2rem;
            }

            .container {
                padding: 1rem 0.5rem;
            }

            .btn-sm {
                padding: 0.35rem 0.65rem;
                font-size: 0.8rem;
            }

            .table {
                font-size: 0.85rem;
            }

            .table thead th {
                font-size: 0.75rem;
            }
        }

        /* Dark mode support (optional) */
        @media (prefers-color-scheme: dark) {
            body {
                background: linear-gradient(135deg, #2c3e50 0%, #34495e 100%);
                color: #ecf0f1;
            }

            .card {
                background-color: #34495e;
                color: #ecf0f1;
            }

            .form-control, .form-select {
                background-color: #2c3e50;
                color: #ecf0f1;
                border-color: #34495e;
            }

            .table {
                color: #ecf0f1;
            }

            .table tbody tr:hover {
                background-color: #2c3e50;
            }
        }
    </style>
</head>
<body>

<!-- Navbar -->
<nav class="navbar navbar-expand-lg navbar-dark sticky-top">
    <div class="container-fluid">
        <a class="navbar-brand" href="/employees">
            <i class="bi bi-people-fill me-2"></i>EmpManage
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" 
                aria-controls="navbarNav" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav ms-auto">
                <li class="nav-item">
                    <a class="nav-link active" href="/employees">
                        <i class="bi bi-house-fill me-1"></i>Home
                    </a>
                </li>
            </ul>
        </div>
    </div>
</nav>
