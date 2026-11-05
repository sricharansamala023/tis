<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="pageTitle" value="Feedback | Tourist Information System"/>
<c:set var="bgWiki" value="Hussain Sagar"/>
<%@ include file="/jsp-includes/header.jsp" %>

<section class="page-hero" style="min-height:48vh;">
    <div class="hero-bg img-slot" data-wiki="Hussain Sagar" data-size="1920"></div>
    <div class="hero-shade"></div>
    <div class="page-hero-inner" style="padding-bottom:110px;">
        <div class="crumbs"><a href="${pageContext.request.contextPath}/home">Home</a> / Feedback</div>
        <h1>Tourist Feedback</h1>
        <p>Visited one of our cities? Tell us about your experience.</p>
    </div>
</section>

<div class="form-card">
    <c:if test="${not empty successMessage}">
        <div class="alert alert-success"><c:out value="${successMessage}"/></div>
    </c:if>
    <c:if test="${not empty errorMessage}">
        <div class="alert alert-error"><c:out value="${errorMessage}"/></div>
    </c:if>

    <form action="${pageContext.request.contextPath}/feedback" method="post">
        <div class="form-group">
            <label for="name">Full Name</label>
            <input type="text" id="name" name="name" value="<c:out value='${nameValue}'/>" placeholder="e.g. Priya Sharma" required>
        </div>
        <div class="form-group">
            <label for="email">Email Address</label>
            <input type="email" id="email" name="email" value="<c:out value='${emailValue}'/>" placeholder="e.g. priya@example.com" required>
        </div>
        <div class="form-group">
            <label for="cityPlace">City / Place Visited</label>
            <input type="text" id="cityPlace" name="cityPlace" value="<c:out value='${cityPlaceValue}'/>" placeholder="e.g. Charminar, Hyderabad" required>
        </div>
        <div class="form-group">
            <label for="rating">Rating</label>
            <select id="rating" name="rating" required>
                <option value="">-- Select a rating --</option>
                <option value="5" ${ratingValue == '5' ? 'selected' : ''}>5 - Excellent</option>
                <option value="4" ${ratingValue == '4' ? 'selected' : ''}>4 - Very Good</option>
                <option value="3" ${ratingValue == '3' ? 'selected' : ''}>3 - Good</option>
                <option value="2" ${ratingValue == '2' ? 'selected' : ''}>2 - Fair</option>
                <option value="1" ${ratingValue == '1' ? 'selected' : ''}>1 - Poor</option>
            </select>
        </div>
        <div class="form-group">
            <label for="feedback">Your Feedback</label>
            <textarea id="feedback" name="feedback" placeholder="Share your experience..."><c:out value="${feedbackValue}"/></textarea>
        </div>
        <button type="submit" class="btn btn-block">Submit Feedback</button>
    </form>
</div>

<%@ include file="/jsp-includes/footer.jsp" %>
