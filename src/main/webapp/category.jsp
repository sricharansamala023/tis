<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<c:set var="pageTitle" value="Categories | Tourist Information System"/>
<c:set var="bgWiki" value="Humayun's Tomb"/>
<%@ include file="/jsp-includes/header.jsp" %>

<section class="page-hero">
    <div class="hero-bg img-slot" data-wiki="Humayun's Tomb" data-size="1920"></div>
    <div class="hero-shade"></div>
    <div class="page-hero-inner">
        <div class="crumbs"><a href="${pageContext.request.contextPath}/home">Home</a> / Categories</div>
        <h1><c:choose><c:when test="${not empty categoryName}">${categoryName}</c:when><c:otherwise>Browse by Category</c:otherwise></c:choose></h1>
        <p>
            <c:choose>
                <c:when test="${not empty categoryName}">Tourist places filed under "${categoryName}" across all cities.</c:when>
                <c:otherwise>Pick a category to see matching tourist places across all cities.</c:otherwise>
            </c:choose>
        </p>
    </div>
</section>

<section class="section">
    <div class="wrap">
        <div class="cat-grid" style="margin-bottom:44px;">
            <c:forEach var="cat" items="${allCategories}">
                <a class="cat-tile ${cat eq categoryName ? 'active' : ''}"
                   href="${pageContext.request.contextPath}/category?name=${cat}">${cat}</a>
            </c:forEach>
        </div>

        <c:if test="${not empty categoryMessage}">
            <div class="alert alert-info"><c:out value="${categoryMessage}"/></div>
        </c:if>

        <c:if test="${not empty results}">
            <p class="result-count">${fn:length(results)} place(s) found</p>
            <c:set var="cardList" value="${results}"/>
            <%@ include file="/jsp-includes/placeCards.jsp" %>
        </c:if>

        <c:if test="${empty categoryName}">
            <div class="empty-state"><p>Select a category above to view matching tourist places.</p></div>
        </c:if>
    </div>
</section>

<%@ include file="/jsp-includes/footer.jsp" %>
