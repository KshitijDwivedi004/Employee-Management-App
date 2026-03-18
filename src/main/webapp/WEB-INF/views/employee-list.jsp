<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ include file="fragments/header.jsp" %>

<div class="container mt-4">

    <!-- Flash messages -->
    <c:if test="${not empty successMessage}">
        <div class="alert alert-success alert-dismissible fade show animate-fade-in" role="alert">
            <div class="d-flex align-items-center">
                <i class="bi bi-check-circle-fill me-2"></i>
                <strong>Success!</strong>&nbsp;${successMessage}
            </div>
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <!-- Page header with controls -->
    <div class="row mb-4">
        <div class="col-md-6">
            <h3 class="fw-bold mb-0">
                <i class="bi bi-people me-2 text-primary"></i>Employee Directory
            </h3>
        </div>
        <div class="col-md-6 d-flex gap-2 justify-content-end">
            <div class="search-wrapper" style="flex: 1; max-width: 350px;">
                <div class="input-group search-input-group">
                    <span class="input-group-text search-icon">
                        <i class="bi bi-search"></i>
                    </span>
                    <input type="text" id="searchInput" class="form-control search-input"
                           placeholder="Search by name, email, or department…"
                           autocomplete="off">
                    <button class="btn btn-search-clear clear-search" id="clearBtn" 
                            style="display: none;" type="button" title="Clear search">
                        <i class="bi bi-x-circle-fill"></i>
                    </button>
                </div>
                <div id="searchStatus" class="small mt-2 search-status-text" style="display: none;"></div>
            </div>
        </div>
    </div>

    <!-- Loading spinner -->
    <div id="loadingSpinner" class="d-none" style="text-align: center; padding: 20px;">
        <div class="spinner-border text-primary" role="status">
            <span class="visually-hidden">Searching...</span>
        </div>
        <p class="mt-2 text-muted">Searching employees...</p>
    </div>

    <!-- Employee count and controls -->
    <div class="d-flex justify-content-between align-items-center mb-3">
        <p class="mb-0 text-muted">
            <strong id="resultCount">0</strong> employee(s) found
        </p>
        <a href="/employees/new" class="btn btn-primary btn-sm">
            <i class="bi bi-plus-circle me-1"></i>Add New Employee
        </a>
    </div>

    <!-- Employee table card -->
    <div class="card shadow-sm border-0 overflow-hidden">
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover table-striped mb-0" id="employeeTable">
                    <thead class="table-light sticky-top">
                        <tr>
                            <th style="width: 5%">#</th>
                            <th style="width: 20%">Name</th>
                            <th style="width: 20%">Email</th>
                            <th style="width: 18%">Department</th>
                            <th style="width: 17%; text-align: right;">Salary (&#8377;)</th>
                            <th style="width: 20%; text-align: center;">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${empty employees}">
                                <tr class="empty-state">
                                    <td colspan="6" class="text-center py-5">
                                        <i class="bi bi-inbox fs-1 text-muted d-block mb-3"></i>
                                        <h5 class="text-muted">No Employees Yet</h5>
                                        <p class="text-muted small">Get started by adding your first employee</p>
                                        <a href="/employees/new" class="btn btn-primary btn-sm mt-2">
                                            <i class="bi bi-person-plus me-1"></i>Add Employee
                                        </a>
                                    </td>
                                </tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="emp" items="${employees}" varStatus="loop">
                                    <c:set var="rowNumber" value="${(currentPage * pageSize) + loop.index + 1}" />
                                    <tr class="table-row-animate" data-emp-id="${emp.id}">
                                        <td><small class="text-muted">${rowNumber}</small></td>
                                        <td>
                                            <div class="fw-semibold text-dark">${emp.name}</div>
                                        </td>
                                        <td>
                                            <small class="text-muted">${emp.email}</small>
                                        </td>
                                        <td>
                                            <span class="badge bg-info bg-opacity-10 text-info mx-1" 
                                                  style="font-weight: 500; padding: 6px 12px;">${emp.department}</span>
                                        </td>
                                        <td style="text-align: right;">
                                            <span class="fw-semibold text-success">
                                                &#8377;<fmt:formatNumber value="${emp.salary}"
                                                                  type="number" minFractionDigits="2" maxFractionDigits="2"/>
                                            </span>
                                        </td>
                                        <td class="text-center">
                                            <div class="action-btn-wrap" role="group" aria-label="Employee actions">
                                                <a href="/employees/${emp.id}/edit"
                                                   class="btn btn-outline-primary action-btn edit-btn"
                                                   title="Edit ${emp.name}">
                                                    <i class="bi bi-pencil"></i>
                                                </a>
                                                <form action="/employees/${emp.id}" method="post" class="d-inline js-delete-form" data-employee-name="${emp.name}">
                                                    <input type="hidden" name="_method" value="DELETE" />
                                                    <button type="submit"
                                                            class="btn btn-outline-danger action-btn delete-btn"
                                                            title="Delete ${emp.name}">
                                                        <i class="bi bi-trash"></i>
                                                    </button>
                                                </form>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <c:if test="${totalPages > 1}">
        <nav aria-label="Employee list pagination" id="paginationNav" class="mt-3 d-flex justify-content-center">
            <ul class="pagination pagination-sm mb-0">
                <li class="page-item ${hasPrevious ? '' : 'disabled'}">
                    <a class="page-link" href="/employees?page=${currentPage - 1}&size=${pageSize}" aria-label="Previous">
                        <span aria-hidden="true">&laquo;</span>
                    </a>
                </li>

                <c:forEach var="pageIndex" begin="0" end="${totalPages - 1}">
                    <li class="page-item ${pageIndex == currentPage ? 'active' : ''}">
                        <a class="page-link" href="/employees?page=${pageIndex}&size=${pageSize}">${pageIndex + 1}</a>
                    </li>
                </c:forEach>

                <li class="page-item ${hasNext ? '' : 'disabled'}">
                    <a class="page-link" href="/employees?page=${currentPage + 1}&size=${pageSize}" aria-label="Next">
                        <span aria-hidden="true">&raquo;</span>
                    </a>
                </li>
            </ul>
        </nav>
    </c:if>

</div>

<!-- jQuery CDN -->
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script>
    let searchTimer;
    let allEmployees = [];
    
    // Initialize with all employees
    function initializeEmployees() {
        const tbody = $('#employeeTable tbody');
        tbody.find('tr.table-row-animate').each(function() {
            const row = $(this);
            allEmployees.push({
                id: row.data('emp-id'),
                name: row.find('td').eq(1).text().trim(),
                email: row.find('td').eq(2).text().trim(),
                department: row.find('td').eq(3).text().trim(),
                salary: row.find('td').eq(4).text().trim()
            });
        });
        updateResultCount();
    }

    // Update result counter
    function updateResultCount() {
        const rows = $('#employeeTable tbody tr:not(.empty-state)').length;
        $('#resultCount').text(rows);
    }

    // Search functionality with debouncing
    $('#searchInput').on('keyup', function () {
        clearTimeout(searchTimer);
        const keyword = $(this).val().trim();
        
        // Show/hide clear button
        if (keyword.length > 0) {
            $('#clearBtn').show();
            togglePagination(false);
        } else {
            $('#clearBtn').hide();
            resetTable();
            return;
        }

        // Show loading spinner
        if (keyword.length >= 2) {
            $('#loadingSpinner').removeClass('d-none');
            $('#searchStatus').html('<i class="bi bi-hourglass-split me-1 animate-spin"></i>Searching...').show();

            searchTimer = setTimeout(function () {
                $.ajax({
                    url: '/employees/search',
                    type: 'GET',
                    data: { keyword: keyword },
                    dataType: 'json',
                    success: function (data) {
                        $('#loadingSpinner').addClass('d-none');
                        displaySearchResults(data, keyword);
                    },
                    error: function (xhr, status, error) {
                        $('#loadingSpinner').addClass('d-none');
                        $('#searchStatus').html('<i class="bi bi-exclamation-triangle"></i> Error: Could not complete search').addClass('text-danger').show();
                        console.error('Search error:', error);
                    }
                });
            }, 300);
        }
    });

    // Clear search
    $('#clearBtn').on('click', function() {
        $('#searchInput').val('').focus();
        $('#searchStatus').hide();
        $('#clearBtn').hide();
        resetTable();
        updateResultCount();
    });

    // Display search results
    function displaySearchResults(data, keyword) {
        const tbody = $('#employeeTable tbody');
        tbody.empty();

        if (data.length === 0) {
            tbody.append(
                '<tr class="empty-state">' +
                '<td colspan="6" class="text-center py-5">' +
                '<i class="bi bi-search fs-1 text-muted d-block mb-3"></i>' +
                '<h5 class="text-muted">No Results Found</h5>' +
                '<p class="text-muted small">No employees match "<strong>' + escapeHtml(keyword) + '</strong>"</p>' +
                '</td>' +
                '</tr>'
            );
            $('#searchStatus').html('<i class="bi bi-info-circle me-1"></i>0 results for this search').removeClass('text-danger').show();
        } else {
            data.forEach(function (emp, index) {
                tbody.append(
                    '<tr class="table-row-animate" data-emp-id="' + emp.id + '">' +
                    '<td><small class="text-muted">' + (index + 1) + '</small></td>' +
                    '<td><div class="fw-semibold text-dark">' + escapeHtml(emp.name) + '</div></td>' +
                    '<td><small class="text-muted">' + escapeHtml(emp.email) + '</small></td>' +
                    '<td><span class="badge bg-info bg-opacity-10 text-info mx-1" style="font-weight: 500; padding: 6px 12px;">' + escapeHtml(emp.department) + '</span></td>' +
                    '<td style="text-align: right;"><span class="fw-semibold text-success">&#8377;' + parseFloat(emp.salary).toLocaleString('en-IN', {minimumFractionDigits: 2}) + '</span></td>' +
                    '<td class="text-center">' +
                    '<div class="action-btn-wrap" role="group" aria-label="Employee actions">' +
                    '<a href="/employees/' + emp.id + '/edit" class="btn btn-outline-primary action-btn edit-btn">' +
                    '<i class="bi bi-pencil"></i></a>' +
                    '<form action="/employees/' + emp.id + '" method="post" class="d-inline js-delete-form" data-employee-name="' + escapeHtml(emp.name) + '">' +
                    '<input type="hidden" name="_method" value="DELETE" />' +
                    '<button type="submit" class="btn btn-outline-danger action-btn delete-btn">' +
                    '<i class="bi bi-trash"></i></button>' +
                    '</form>' +
                    '</div>' +
                    '</td>' +
                    '</tr>'
                );
            });
            $('#searchStatus').html('<i class="bi bi-check-circle me-1"></i>' + data.length + ' result(s) found').removeClass('text-danger').show();
        }
        updateResultCount();
    }

    // Reset table to show all employees
    function resetTable() {
        location.reload();
    }

    function togglePagination(show) {
        const nav = $('#paginationNav');
        if (!nav.length) {
            return;
        }
        if (show) {
            nav.show();
        } else {
            nav.hide();
        }
    }

    // Confirm delete before submitting the form
    $(document).on('submit', '.js-delete-form', function (e) {
        const employeeName = $(this).data('employee-name') || 'this employee';
        if (!confirm('Are you sure you want to delete ' + employeeName + '?\n\nThis action cannot be undone.')) {
            e.preventDefault();
        }
    });

    // Escape HTML to prevent XSS
    function escapeHtml(text) {
        const map = {
            '&': '&amp;',
            '<': '&lt;',
            '>': '&gt;',
            '"': '&quot;',
            "'": '&#039;'
        };
        return text.replace(/[&<>"']/g, function(m) { return map[m]; });
    }

    // Initialize on page load
    $(document).ready(function() {
        initializeEmployees();
        
        // Auto-dismiss alerts after 3 seconds
        $('.alert').each(function() {
            const alert = new bootstrap.Alert(this);
            setTimeout(function() {
                alert.close();
            }, 3000);
        });
    });
</script>

<style>
    /* Animations */
    @keyframes fadeIn {
        from {
            opacity: 0;
            transform: translateY(10px);
        }
        to {
            opacity: 1;
            transform: translateY(0);
        }
    }

    @keyframes spin {
        from {
            transform: rotate(0deg);
        }
        to {
            transform: rotate(360deg);
        }
    }

    .animate-spin {
        animation: spin 2s linear infinite;
    }

    .animate-fade-in {
        animation: fadeIn 0.3s ease-in;
    }

    .table-row-animate {
        animation: fadeIn 0.3s ease-in;
    }

    /* Search styling */
    .search-wrapper {
        position: relative;
    }

    .search-input-group {
        border-radius: 12px;
        box-shadow: 0 4px 15px rgba(102, 126, 234, 0.2);
        transition: all 0.3s ease;
        border: 2px solid transparent;
        overflow: hidden;
        background: white;
    }

    .search-input-group:focus-within {
        box-shadow: 0 8px 25px rgba(102, 126, 234, 0.3);
        border-color: #667eea;
        transform: translateY(-2px);
    }

    .search-icon {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        border: none;
        color: white;
        font-size: 1.1rem;
        font-weight: 600;
        padding: 10px 16px;
    }

    .search-input {
        border: none !important;
        border-left: none !important;
        font-size: 0.95rem;
        font-weight: 500;
        color: #2c3e50;
        padding: 10px 16px;
        background: white;
    }

    .search-input::placeholder {
        color: #95a5a6;
        font-weight: 400;
    }

    .search-input:focus {
        background: white;
        color: #2c3e50;
        box-shadow: none;
    }

    .btn-search-clear {
        border: none;
        background: white;
        color: #667eea;
        padding: 10px 14px;
        transition: all 0.2s ease;
        font-size: 1rem;
    }

    .btn-search-clear:hover {
        background: #f0f2f7;
        color: #764ba2;
        transform: rotate(90deg);
    }

    .btn-search-clear:active {
        transform: rotate(90deg) scale(0.95);
    }

    .search-status-text {
        color: #667eea;
        font-weight: 500;
        margin-top: 0.5rem !important;
    }

    .search-status-text.text-danger {
        color: #e74c3c !important;
    }

    /* Table improvements */
    .table-responsive {
        border-radius: 8px;
    }

    .action-btn {
        transition: all 0.2s ease;
    }

    .action-btn:hover {
        transform: scale(1.1);
    }

    .edit-btn:hover {
        background-color: #0d6efd;
        border-color: #0d6efd;
        color: white;
    }

    .delete-btn:hover {
        background-color: #dc3545;
        border-color: #dc3545;
        color: white;
    }

    .empty-state {
        background-color: #f8f9fa;
    }

    /* Badge styling */
    .badge {
        font-size: 0.85rem;
        border-radius: 6px;
    }

    /* Sticky header */
    .sticky-top {
        background-color: #f8f9fa;
        border-bottom: 2px solid #dee2e6;
    }
</style>

</body>
</html>
