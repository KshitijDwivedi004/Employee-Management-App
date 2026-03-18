<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ include file="fragments/header.jsp" %>

<div class="container">

    <!-- Flash messages (will be wired in Phase 3) -->
    <c:if test="${not empty successMessage}">
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            <i class="bi bi-check-circle-fill me-2"></i>${successMessage}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <!-- Page header + search -->
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h5 class="mb-0 fw-semibold">
            <i class="bi bi-table me-2 text-primary"></i>All Employees
        </h5>
        <input type="text" id="searchInput" class="form-control search-box"
               placeholder="Search by name or department…">
    </div>

    <!-- Employee table -->
    <div class="card shadow-sm">
        <div class="card-body p-0">
            <table class="table table-hover table-bordered mb-0" id="employeeTable">
                <thead class="table-primary">
                    <tr>
                        <th>#</th>
                        <th>Name</th>
                        <th>Email</th>
                        <th>Department</th>
                        <th>Salary (₹)</th>
                        <th class="text-center">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${empty employees}">
                            <tr>
                                <td colspan="6" class="text-center text-muted py-4">
                                    <i class="bi bi-inbox fs-4 d-block mb-1"></i>
                                    No employees found. <a href="/employees/new">Add one?</a>
                                </td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="emp" items="${employees}" varStatus="loop">
                                <tr>
                                    <td>${loop.count}</td>
                                    <td>${emp.name}</td>
                                    <td>${emp.email}</td>
                                    <td><span class="badge-dept">${emp.department}</span></td>
                                    <td>
                                        <fmt:formatNumber value="${emp.salary}"
                                                          type="number" minFractionDigits="2"/>
                                    </td>
                                    <td class="text-center">
                                        <a href="/employees/edit/${emp.id}"
                                           class="btn btn-warning btn-sm me-1">
                                            <i class="bi bi-pencil-fill"></i>
                                        </a>
                                        <a href="/employees/delete/${emp.id}"
                                           class="btn btn-danger btn-sm"
                                           onclick="return confirm('Delete ${emp.name}?')">
                                            <i class="bi bi-trash-fill"></i>
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>
    </div>

    <p class="text-muted mt-2 small">
        Showing <strong>${employees.size()}</strong> employee(s)
    </p>
</div>

<!-- jQuery CDN -->
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script>
    /**
     * Live search — fires on every keystroke with a 300ms debounce.
     * Calls GET /employees/search?keyword=... and re-renders the tbody.
     * Full implementation with proper row templating will be in Phase 4.
     */
    let searchTimer;
    $('#searchInput').on('keyup', function () {
        clearTimeout(searchTimer);
        const keyword = $(this).val().trim();

        if (keyword.length < 2) {
            location.reload();
            return;
        }

        searchTimer = setTimeout(function () {
            $.getJSON('/employees/search', { keyword: keyword }, function (data) {
                const tbody = $('#employeeTable tbody');
                tbody.empty();

                if (data.length === 0) {
                    tbody.append(
                        '<tr><td colspan="6" class="text-center text-muted py-3">' +
                        '<i class="bi bi-search me-1"></i>No results for "' + keyword + '"' +
                        '</td></tr>'
                    );
                    return;
                }

                data.forEach(function (emp, index) {
                    tbody.append(
                        '<tr>' +
                        '<td>' + (index + 1) + '</td>' +
                        '<td>' + emp.name + '</td>' +
                        '<td>' + emp.email + '</td>' +
                        '<td><span class="badge-dept">' + emp.department + '</span></td>' +
                        '<td>' + parseFloat(emp.salary).toFixed(2) + '</td>' +
                        '<td class="text-center">' +
                          '<a href="/employees/edit/' + emp.id + '" class="btn btn-warning btn-sm me-1">' +
                            '<i class="bi bi-pencil-fill"></i></a>' +
                          '<a href="/employees/delete/' + emp.id + '" class="btn btn-danger btn-sm" ' +
                            'onclick="return confirm(\'Delete ' + emp.name + '?\')">' +
                            '<i class="bi bi-trash-fill"></i></a>' +
                        '</td>' +
                        '</tr>'
                    );
                });
            });
        }, 300);
    });
</script>

</body>
</html>
