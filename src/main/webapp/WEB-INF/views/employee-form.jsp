<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"    uri="jakarta.tags.core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ include file="fragments/header.jsp" %>

<div class="container mt-5">
    <div class="row justify-content-center">
        <div class="col-lg-6 col-md-8">

            <!-- Breadcrumb -->
            <nav aria-label="breadcrumb" class="mb-4">
                <ol class="breadcrumb">
                    <li class="breadcrumb-item"><a href="/employees" class="text-decoration-none">Employees</a></li>
                    <li class="breadcrumb-item active fw-medium">${formTitle}</li>
                </ol>
            </nav>

            <div class="card shadow-lg border-0 rounded-3">
                
                <!-- Card Header -->
                <div class="card-header bg-gradient text-white rounded-top-3" 
                     style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); padding: 2rem;">
                    <h4 class="mb-0 d-flex align-items-center">
                        <c:choose>
                            <c:when test="${employeeDTO.id != null}">
                                <i class="bi bi-pencil-square me-2 fs-5"></i>
                                <span>Edit Employee</span>
                            </c:when>
                            <c:otherwise>
                                <i class="bi bi-person-plus me-2 fs-5"></i>
                                <span>Add New Employee</span>
                            </c:otherwise>
                        </c:choose>
                    </h4>
                </div>

                <!-- Card Body -->
                <div class="card-body p-4">
                    <form:form modelAttribute="employeeDTO"
                               action="${formAction}"
                               method="post"
                               id="employeeForm"
                               novalidate="true"
                               class="needs-validation">

                        <c:if test="${employeeDTO.id != null}">
                            <input type="hidden" name="_method" value="PUT" />
                        </c:if>

                        <!-- Name -->
                        <div class="mb-4">
                            <label for="name" class="form-label fw-semibold mb-2">
                                <i class="bi bi-person me-2 text-primary"></i>Full Name
                                <span class="text-danger">*</span>
                            </label>
                            <form:input path="name" id="name"
                                        cssClass="form-control form-control-lg"
                                        placeholder="e.g. Arjun Sharma"
                                        maxlength="100"/>
                            <form:errors path="name" cssClass="text-danger small mt-2 d-block" element="div"/>
                            <div id="nameError" class="text-danger small mt-2" style="display:none;"></div>
                            <small class="text-muted d-block mt-1">At least 2 characters required</small>
                        </div>

                        <!-- Email -->
                        <div class="mb-4">
                            <label for="email" class="form-label fw-semibold mb-2">
                                <i class="bi bi-envelope me-2 text-primary"></i>Email Address
                                <span class="text-danger">*</span>
                            </label>
                            <form:input path="email" id="email"
                                        cssClass="form-control form-control-lg"
                                        placeholder="e.g. arjun@example.com"
                                        type="email"
                                        maxlength="150"/>
                            <form:errors path="email" cssClass="text-danger small mt-2 d-block" element="div"/>
                            <div id="emailError" class="text-danger small mt-2" style="display:none;"></div>
                            <small class="text-muted d-block mt-1">Must be a valid email address</small>
                        </div>

                        <!-- Department -->
                        <div class="mb-4">
                            <label for="department" class="form-label fw-semibold mb-2">
                                <i class="bi bi-building me-2 text-primary"></i>Department
                                <span class="text-danger">*</span>
                            </label>
                            <form:select path="department" id="department" cssClass="form-select form-select-lg">
                                <form:option value="" label="-- Select Department --"/>
                                <form:option value="Engineering"  label="Engineering"/>
                                <form:option value="HR"           label="HR"/>
                                <form:option value="Finance"      label="Finance"/>
                                <form:option value="Marketing"    label="Marketing"/>
                                <form:option value="Operations"   label="Operations"/>
                                <form:option value="Sales"        label="Sales"/>
                                <form:option value="Legal"        label="Legal"/>
                            </form:select>
                            <form:errors path="department" cssClass="text-danger small mt-2 d-block" element="div"/>
                            <div id="deptError" class="text-danger small mt-2" style="display:none;"></div>
                        </div>

                        <!-- Salary -->
                        <div class="mb-4">
                            <label for="salary" class="form-label fw-semibold mb-2">
                                <i class="bi bi-currency-rupee me-2 text-primary"></i>Salary (&#8377;)
                                <span class="text-danger">*</span>
                            </label>
                            <div class="input-group input-group-lg">
                                <span class="input-group-text">&#8377;</span>
                                <form:input path="salary" id="salary"
                                            cssClass="form-control"
                                            placeholder="e.g. 75000.00"
                                            type="number" step="0.01" min="0"/>
                            </div>
                            <form:errors path="salary" cssClass="text-danger small mt-2 d-block" element="div"/>
                            <div id="salaryError" class="text-danger small mt-2" style="display:none;"></div>
                            <small class="text-muted d-block mt-1">Must be a positive number</small>
                        </div>

                        <!-- Form Actions -->
                        <div class="d-grid gap-2 d-md-flex pt-3">
                            <button type="submit" class="btn btn-primary btn-lg flex-grow-1" id="submitBtn">
                                <i class="bi bi-check-circle me-2"></i>
                                <c:choose>
                                    <c:when test="${employeeDTO.id != null}">Update Employee</c:when>
                                    <c:otherwise>Save Employee</c:otherwise>
                                </c:choose>
                            </button>
                            <a href="/employees" class="btn btn-outline-secondary btn-lg">
                                <i class="bi bi-arrow-left me-2"></i>Cancel
                            </a>
                        </div>

                    </form:form>

                    <!-- Or section for quick navigation -->
                    <div class="text-center mt-4 pt-3 border-top">
                        <p class="text-muted small mb-0">
                            <a href="/employees" class="text-decoration-none">← Back to employee list</a>
                        </p>
                    </div>
                </div>
            </div>

        </div>
    </div>
</div>

<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script>
    /**
     * Client-side validation with real-time feedback
     */
    const form = $('#employeeForm');
    
    // Helper: show or clear an inline error
    function showError(fieldId, errorId, message) {
        const field = $('#' + fieldId);
        const error = $('#' + errorId);
        if (message) {
            field.addClass('is-invalid').removeClass('is-valid');
            error.text(message).show();
            return false;
        } else {
            field.removeClass('is-invalid').addClass('is-valid');
            error.hide();
            return true;
        }
    }

    // Validation handlers
    const validators = {
        name: function() {
            const val = $('#name').val().trim();
            return showError('name', 'nameError',
                val.length < 2 ? '✗ Name must be at least 2 characters' : 
                val.length > 100 ? '✗ Name must not exceed 100 characters' : null);
        },
        email: function() {
            const val = $('#email').val().trim();
            const regex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            return showError('email', 'emailError',
                !regex.test(val) ? '✗ Please enter a valid email address' : 
                val.length > 150 ? '✗ Email must not exceed 150 characters' : null);
        },
        department: function() {
            const val = $('#department').val();
            return showError('department', 'deptError',
                !val ? '✗ Please select a department' : null);
        },
        salary: function() {
            const val = parseFloat($('#salary').val());
            return showError('salary', 'salaryError',
                isNaN(val) || val < 0 ? '✗ Salary must be a positive number' : null);
        }
    };

    // Real-time validation on blur and input
    $('#name, #email, #salary').on('blur input', function() {
        const fieldId = $(this).attr('id');
        if (validators[fieldId]) {
            validators[fieldId]();
        }
    });

    $('#department').on('change blur', function() {
        validators.department();
    });

    // Form submission with full validation
    form.on('submit', function (e) {
        let valid = true;
        
        // Validate all fields
        if (!validators.name()) valid = false;
        if (!validators.email()) valid = false;
        if (!validators.department()) valid = false;
        if (!validators.salary()) valid = false;

        if (!valid) {
            e.preventDefault();
            // Scroll to first error
            const firstError = form.find('.is-invalid').first();
            if (firstError.length) {
                $('html, body').animate({
                    scrollTop: firstError.offset().top - 100
                }, 300);
            }
        }
    });

    // Clear validation on input start
    form.find('input, select').on('focus', function() {
        $(this).removeClass('is-invalid is-valid');
    });

    // Initialize validation on page load if in edit mode
    $(document).ready(function() {
        // Add a subtle animation to form load
        form.addClass('fadeIn');
    });
</script>

<style>
    @keyframes fadeIn {
        from {
            opacity: 0;
            transform: translateY(20px);
        }
        to {
            opacity: 1;
            transform: translateY(0);
        }
    }

    @keyframes slideInLeft {
        from {
            opacity: 0;
            transform: translateX(-10px);
        }
        to {
            opacity: 1;
            transform: translateX(0);
        }
    }

    .fadeIn {
        animation: fadeIn 0.5s ease-in-out;
    }

    /* Enhanced form styling */
    .form-control, .form-select {
        border: 2px solid #e9ecef;
        transition: all 0.3s ease;
        border-radius: 10px;
        font-size: 0.95rem;
        font-weight: 500;
        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.03);
    }

    .form-control:focus, .form-select:focus {
        border-color: #667eea;
        box-shadow: 0 4px 20px rgba(102, 126, 234, 0.25);
        transform: translateY(-2px);
    }

    .form-control.is-valid, .form-select.is-valid {
        border-color: #28a745;
        background-image: none;
        box-shadow: 0 4px 12px rgba(40, 167, 69, 0.15);
    }

    .form-control.is-invalid, .form-select.is-invalid {
        border-color: #dc3545;
        background-image: none;
        box-shadow: 0 4px 12px rgba(220, 53, 69, 0.15);
    }

    .form-control::placeholder {
        color: #95a5a6;
        font-weight: 400;
    }

    .form-label {
        color: #2c3e50;
        font-size: 0.95rem;
        font-weight: 600;
    }

    .input-group-text {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        border: none;
        color: white;
        font-weight: 600;
        border-radius: 10px 0 0 10px;
        padding: 10px 16px;
    }

    .input-group .form-control {
        border-radius: 0 10px 10px 0;
        border-left: none;
        border-color: #e9ecef;
    }

    .input-group .form-control:focus {
        border-left-color: #667eea;
    }

    /* Button styling */
    .btn-primary {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        border: none;
        font-weight: 600;
        letter-spacing: 0.5px;
        transition: all 0.3s ease;
    }

    .btn-primary:hover {
        transform: translateY(-2px);
        box-shadow: 0 8px 20px rgba(102, 126, 234, 0.3);
    }

    .btn-primary:active {
        transform: translateY(0);
    }

    .btn-lg {
        padding: 0.75rem 1.5rem;
        font-size: 1rem;
    }

    /* Card styling */
    .card {
        transition: all 0.3s ease;
        border-radius: 16px;
        overflow: hidden;
    }

    .card:hover {
        box-shadow: 0 20px 40px rgba(0, 0, 0, 0.12) !important;
        transform: translateY(-4px);
    }

    .card-header {
        border-radius: 16px 16px 0 0 !important;
    }

    .card-body {
        padding: 2rem !important;
        background: white;
    }

    .rounded-top-3 {
        border-radius: 1rem 1rem 0 0;
    }

    /* Form group animations */
    .mb-4 {
        animation: slideInLeft 0.3s ease-out backwards;
    }

    .mb-4:nth-child(1) { animation-delay: 0.1s; }
    .mb-4:nth-child(2) { animation-delay: 0.2s; }
    .mb-4:nth-child(3) { animation-delay: 0.3s; }
    .mb-4:nth-child(4) { animation-delay: 0.4s; }

    /* Error message styling */
    .text-danger {
        color: #e74c3c !important;
        font-weight: 500;
        animation: slideInLeft 0.2s ease-out;
    }

    /* Helper text styling */
    small {
        display: block;
        margin-top: 0.5rem;
        color: #7f8c8d;
        font-size: 0.85rem;
    }

    /* Validation feedback */
    .form-control.is-valid {
        border-color: #27ae60;
    }

    .form-control.is-invalid {
        border-color: #e74c3c;
    }
</style>

</body>
</html>
