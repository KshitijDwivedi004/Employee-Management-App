<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ include file="fragments/header.jsp" %>

<div class="container">
    <div class="row justify-content-center mt-5">
        <div class="col-md-6 text-center">
            <div class="card border-danger shadow-sm">
                <div class="card-body py-5">
                    <i class="bi bi-exclamation-triangle-fill text-danger" style="font-size:3rem"></i>
                    <h4 class="mt-3 fw-semibold">
                        <c:out value="${errorTitle}" default="Error"/>
                    </h4>
                    <p class="text-muted">
                        <c:out value="${errorMessage}" default="An unexpected error occurred."/>
                    </p>
                    <a href="/employees" class="btn btn-primary btn-sm mt-2">
                        <i class="bi bi-house-fill me-1"></i>Back to Home
                    </a>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
