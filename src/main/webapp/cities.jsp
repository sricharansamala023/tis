<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%-- Opened directly? Let HomeServlet load the cities from the XML first. --%>
<c:if test="${empty cities}"><jsp:forward page="/cities"/></c:if>
<c:set var="pageTitle" value="All Cities | Tourist Information System"/>
<c:set var="bgWiki" value="India Gate"/>
<%@ include file="/jsp-includes/header.jsp" %>

<section class="page-hero">
    <div class="hero-bg img-slot" data-wiki="India Gate" data-size="1920"></div>
    <div class="hero-shade"></div>
    <div class="page-hero-inner">
        <div class="crumbs"><a href="${pageContext.request.contextPath}/home">Home</a> / Cities</div>
        <h1>All Destinations</h1>
        <p>Pick one of ten Indian cities to see its ten best tourist places, history and visitor tips.</p>
    </div>
</section>

<section class="section">
    <div class="wrap">
        <div class="pgrid">
            <c:forEach var="ct" items="${cities}" varStatus="st">
                <c:url var="ctUrl" value="/city"><c:param name="name" value="${ct.name}"/></c:url>
                <a class="pcard" href="${ctUrl}">
                    <div class="pcard-img img-slot" data-wiki="<c:out value='${ct.coverWiki}'/>" data-size="960"></div>
                    <div class="pcard-shade"></div>
                    <span class="pcard-cat"><c:choose><c:when test="${st.first}">&#9733; Featured</c:when><c:otherwise><c:out value="${ct.state}"/></c:otherwise></c:choose></span>
                    <div class="pcard-body">
                        <h3><c:out value="${ct.name}"/></h3>
                        <div class="pcard-loc"><c:out value="${ct.tagline}"/> &middot; ${ct.placeCount} places</div>
                        <p><c:out value="${ct.description}"/></p>
                        <span class="pcard-go">View Places &rarr;</span>
                    </div>
                </a>
            </c:forEach>
        </div>
    </div>
</section>

<%@ include file="/jsp-includes/footer.jsp" %>
