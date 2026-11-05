<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="pageTitle" value="Something went wrong | Tourist Information System"/>
<c:set var="bgWiki" value="Charminar"/>
<%@ include file="/jsp-includes/header.jsp" %>

<section class="page-hero" style="min-height:70vh;">
    <div class="hero-shade" style="background:linear-gradient(135deg,#0b2b33,#12525c);"></div>
    <div class="page-hero-inner" style="text-align:center;">
        <div style="font-size:3.4rem;">&#128506;&#65039;</div>
        <h1>Lost your way?</h1>
        <p style="margin:0 auto 24px;">
            <c:choose>
                <c:when test="${not empty errorMessage}"><c:out value="${errorMessage}"/></c:when>
                <c:otherwise>The page you requested could not be found or an unexpected error occurred.</c:otherwise>
            </c:choose>
        </p>
        <a class="btn" href="${pageContext.request.contextPath}/home">&larr; Back to Home</a>
    </div>
</section>

<%@ include file="/jsp-includes/footer.jsp" %>
