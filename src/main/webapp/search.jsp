<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<c:set var="pageTitle" value="Search | Tourist Information System"/>
<c:set var="bgWiki" value="Hawa Mahal"/>
<%@ include file="/jsp-includes/header.jsp" %>

<section class="page-hero">
    <div class="hero-bg img-slot" data-wiki="Hawa Mahal" data-size="1920"></div>
    <div class="hero-shade"></div>
    <div class="page-hero-inner">
        <div class="crumbs"><a href="${pageContext.request.contextPath}/home">Home</a> / Search</div>
        <h1>Search Tourist Places</h1>
        <p>Search by city, place name or category &mdash; try "Fort", "Beach" or "Hyderabad".</p>
        <form class="hero-search" action="${pageContext.request.contextPath}/search" method="get">
            <input type="text" name="query" value="<c:out value='${query}'/>" placeholder="Search..." required>
            <button type="submit">Search</button>
        </form>
    </div>
</section>

<section class="section">
    <div class="wrap">
        <c:if test="${not empty searchMessage}">
            <div class="alert alert-info"><c:out value="${searchMessage}"/></div>
        </c:if>

        <c:if test="${not empty results}">
            <p class="result-count">Found ${fn:length(results)} result(s) for "<strong><c:out value="${query}"/></strong>"</p>
            <c:set var="cardList" value="${results}"/>
            <%@ include file="/jsp-includes/placeCards.jsp" %>
        </c:if>
    </div>
</section>

<%@ include file="/jsp-includes/footer.jsp" %>
