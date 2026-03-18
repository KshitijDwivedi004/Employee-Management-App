<%@ taglib prefix="c"    uri="jakarta.tags.core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ include file="fragments/header.jsp" %>

<div class="container">
    <div class="row justify-content-center">
        <div class="col-md-7">

            <!-- Breadcrumb -->
            <nav aria-label="breadcrumb" class="mb-3">
                <ol class="breadcrumb">
                    <li class="breadcrumb-item"><a href="/employees">Employees</a></li>
                    <li class="breadcrumb-item active">${formTitle}</li>
                </ol>
            </nav>

            <div class="card shadow-sm">
                <div class="card-header bg-primary text-white">
                    <h6 class="mb-0">
                        <c:choose>
                            <c:when test="${employeeDTO.id != null}">
                                <i class="bi bi-pencil-fill me-2"></i>${formTitle}
                            </c:when>
                            <c:otherwise>
                                <i class="bi bi-person-plus-fill me-2"></i>${formTitle}
                            </c:otherwise>
                        </c:choose>
                    </h6>
                </div>

                <div class="card-body">
                    <%--
                        Spring's <form:form> binds to the "employeeDTO" model attribute.
                        - modelAttribute must match the key used in model.addAttribute()
                        - action comes from the "formAction" model attribute set in controller
                        - method="post" is always used; PUT/DELETE not natively supported in HTML
                    --%>
                    <form:form modelAttribute="employeeDTO"
                               action="${formAction}"
                               method="post"
                               id="employeeForm"
                               novalidate="true">

                        <!-- Name -->
                        <div class="mb-3">
                            <label for="name" class="form-label fw-semibold">
                                Full Name <span class="text-danger">*</span>
                            </label>
                            <form:input path="name" id="name"
                                        cssClass="form-control"
                                        placeholder="e.g. Arjun Sharma"
                                        maxlength="100"/>
                            <%-- Shows server-side Bean Validation error for 'name' field --%>
                            <form:errors path="name" cssClass="text-danger small mt-1" element="div"/>
                            <%-- Client-side error placeholder --%>
                            <div id="nameError" class="text-danger small mt-1" style="display:none;"></div>
                        </div>

                        <!-- Email -->
                        <div class="mb-3">
                            <label for="email" class="form-label fw-semibold">
                                Email Address <span class="text-danger">*</span>
                            </label>
                            <form:input path="email" id="email"
                                        cssClass="form-control"
                                        placeholder="e.g. arjun@example.com"
                                        maxlength="150"/>
                            <form:errors path="email" cssClass="text-danger small mt-1" element="div"/>
                            <div id="emailError" class="text-danger small mt-1" style="display:none;"></div>
                        </div>

                        <!-- Department -->
                        <div class="mb-3">
                            <label for="department" class="form-label fw-semibold">
                                Department <span class="text-danger">*</span>
                            </label>
                            <%-- Dropdown with common departments; user can also type custom --%>
                            <form:select path="department" id="department" cssClass="form-select">
                                <form:option value="" label="-- Select Department --"/>
                                <form:option value="Engineering"  label="Engineering"/>
                                <form:option value="HR"           label="HR"/>
                                <form:option value="Finance"      label="Finance"/>
                                <form:option value="Marketing"    label="Marketing"/>
                                <form:option value="Operations"   label="Operations"/>
                                <form:option value="Sales"        label="Sales"/>
                                <form:option value="Legal"        label="Legal"/>
                            </form:select>
                            <form:errors path="department" cssClass="text-danger small mt-1" element="div"/>
                            <div id="deptError" class="text-danger small mt-1" style="display:none;"></div>
                        </div>

                        <!-- Salary -->
                        <div class="mb-4">
                            <label for="salary" class="form-label fw-semibold">
                                Salary (₹) <span class="text-danger">*</span>
                            </label>
                            <div class="input-group">
                                <span class="input-group-text">₹</span>
                                <form:input path="salary" id="salary"
                                            cssClass="form-control"
                                            placeholder="e.g. 75000.00"
                                            type="number" step="0.01" min="1"/>
                            </div>
                            <form:errors path="salary" cssClass="text-danger small mt-1" element="div"/>
                            <div id="salaryError" class="text-danger small mt-1" style="display:none;"></div>
                        </div>

                        <!-- Submit / Cancel -->
                        <div class="d-flex gap-2">
                            <button type="submit" class="btn btn-primary" id="submitBtn">
                                <i class="bi bi-save me-1"></i>
                                <c:choose>
                                    <c:when test="${employeeDTO.id != null}">Update Employee</c:when>
                                    <c:otherwise>Save Employee</c:otherwise>
                                </c:choose>
                            </button>
                            <a href="/employees" class="btn btn-outline-secondary">
                                <i class="bi bi-x-circle me-1"></i>Cancel
                            </a>
                        </div>

                    </form:form>
                </div><!-- card-body -->
            </div><!-- card -->
        </div>
    </div>
</div>

<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script>
    /**
     * Client-side validation runs BEFORE the form is submitted.
     * This is a first line of defence — Bean Validation on the server
     * is still the source of truth.
     */
    $('#employeeForm').on('submit', function (e) {
        let valid = true;

        // Helper: show or clear an inline error
        function showError(fieldId, errorId, message) {
            const field = $('#' + fieldId);
            const error = $('#' + errorId);
            if (message) {
                field.addClass('is-invalid');
                error.text(message).show();
                valid = false;
            } else {
                field.removeClass('is-invalid').addClass('is-valid');
                error.hide();
            }
        }

        // --- Name ---
        const name = $('#name').val().trim();
        showError('name', 'nameError',
            name.length < 2 ? 'Name must be at least 2 characters.' : null);

        // --- Email ---
        const email = $('#email').val().trim();
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        showError('email', 'emailError',
            !emailRegex.test(email) ? 'Please enter a valid email address.' : null);

        // --- Department ---
        const dept = $('#department').val();
        showError('department', 'deptError',
            !dept ? 'Please select a department.' : null);

        // --- Salary ---
        const salary = parseFloat($('#salary').val());
        showError('salary', 'salaryError',
            isNaN(salary) || salary <= 0 ? 'Salary must be a positive number.' : null);

        if (!valid) {
            e.preventDefault();  // stop form submission
        }
    });

    // Clear error styling as user corrects fields
    $('#employeeForm input, #employeeForm select').on('input change', function () {
        $(this).removeClass('is-invalid is-valid');
    });
</script>
</body>
</html>
