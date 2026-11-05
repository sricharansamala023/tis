<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<c:set var="pageTitle" value="${cityName} | Tourist Information System"/>
<c:set var="bgWiki" value="${places[0].wikiTitle}"/>
<%@ include file="/jsp-includes/header.jsp" %>

<section class="page-hero">
    <c:if test="${not empty places}">
        <div class="hero-bg img-slot" data-wiki="${places[0].wikiTitle}" data-img="${places[0].imageUrl}" data-size="1920"></div>
    </c:if>
    <div class="hero-shade"></div>
    <div class="page-hero-inner">
        <div class="crumbs">
            <a href="${pageContext.request.contextPath}/home">Home</a> /
            <a href="${pageContext.request.contextPath}/cities">Cities</a> / ${cityName}
        </div>
        <h1>${cityName}</h1>
        <p><c:out value="${cityInfo.description}"/></p>
        <p style="margin-top:6px;">${fn:length(places)} tourist places &middot; ${cityInfo.state}</p>
    </div>
</section>

<section class="section">
    <div class="wrap">
        <c:choose>
            <c:when test="${empty places}">
                <div class="empty-state">
                    <h3>No tourist places found for ${cityName}.</h3>
                    <a class="btn btn-dark" href="${pageContext.request.contextPath}/cities">Browse other cities</a>
                </div>
            </c:when>
            <c:otherwise>
                <c:set var="cardList" value="${places}"/>
                <%@ include file="/jsp-includes/placeCards.jsp" %>
            </c:otherwise>
        </c:choose>
    </div>
</section>

<%@ include file="/jsp-includes/footer.jsp" %>
