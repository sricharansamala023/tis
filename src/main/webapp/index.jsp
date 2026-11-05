<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%-- Opened directly (welcome file)? Let HomeServlet load the cities from the XML first. --%>
<c:if test="${empty cities}"><jsp:forward page="/home"/></c:if>
<c:set var="pageTitle" value="Tourist Information System | Explore India"/>
<c:set var="first" value="${cities[0]}"/>
<c:set var="bgWiki" value="${first.coverWiki}"/>
<%@ include file="/jsp-includes/header.jsp" %>

<%-- ========== Full-screen city stage ========== --%>
<section class="stage" id="stage">
    <div class="stage-bg" id="bgA"></div>
    <div class="stage-bg" id="bgB"></div>
    <div class="stage-shade"></div>

    <aside class="rail">
        <span class="vtext">India &middot; Beautiful Places</span>
        <span class="line"></span>
        <span class="year">2026</span>
    </aside>

    <div class="stage-content in" id="stageContent">
        <div class="stage-num" id="stageNum">01</div>
        <div class="eyebrow" id="stageTag"><c:out value="${first.tagline}"/></div>
        <h1 id="stageTitle"><c:out value="${first.name}"/></h1>
        <p class="lead" id="stageDesc"><c:out value="${first.description}"/></p>
        <div class="stars">&#9733;&#9733;&#9733;&#9733;&#9733;</div>
        <div class="btn-row">
            <c:url var="firstUrl" value="/city"><c:param name="name" value="${first.name}"/></c:url>
            <a class="btn" id="stageLink" href="${firstUrl}">Explore <c:out value="${first.name}"/> &rsaquo;</a>
            <a class="btn btn-ghost" href="#explore">All Cities</a>
        </div>
    </div>

    <div class="strip-wrap">
        <div class="strip-head">
            <span class="label">City Gallery</span>
            <div class="arrows">
                <button class="arrow" id="stagePrev" type="button" aria-label="Previous city">&lsaquo;</button>
                <button class="arrow" id="stageNext" type="button" aria-label="Next city">&rsaquo;</button>
            </div>
        </div>
        <div class="strip" id="stageStrip">
            <c:forEach var="ct" items="${cities}" varStatus="st">
                <c:url var="ctUrl" value="/city"><c:param name="name" value="${ct.name}"/></c:url>
                <button type="button" class="thumb ${st.first ? 'active' : ''}"
                        data-city="<c:out value='${ct.name}'/>" data-tag="<c:out value='${ct.tagline}'/>"
                        data-wiki="<c:out value='${ct.coverWiki}'/>" data-href="${ctUrl}"
                        data-desc="<c:out value='${ct.description}'/>">
                    <span class="thumb-img img-slot" data-wiki="<c:out value='${ct.coverWiki}'/>" data-size="500"></span>
                    <span class="cap"><small>${st.count lt 10 ? '0' : ''}${st.count}</small><c:out value="${ct.name}"/></span>
                </button>
            </c:forEach>
        </div>
    </div>
</section>

<%-- ========== Explore India: city cards ========== --%>
<section class="section" id="explore">
    <div class="wrap">
        <div class="section-head">
            <div class="kicker">Explore India</div>
            <h2>Ten Cities, Endless Stories</h2>
            <p>Choose a destination to see its ten best tourist places, history and visitor tips &mdash; all read live from our XML data.</p>
        </div>
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
                        <span class="pcard-go">Explore <c:out value="${ct.name}"/> &rarr;</span>
                    </div>
                </a>
            </c:forEach>
        </div>
    </div>
</section>

<%-- ========== Featured destination ========== --%>
<section class="section white feature">
    <div class="wrap feature-grid">
        <div class="feature-text">
            <div class="kicker">Featured Destination &middot; 01</div>
            <h2><c:out value="${first.name}"/></h2>
            <div class="sub"><c:out value="${first.tagline}"/> &middot; <c:out value="${first.state}"/></div>
            <p class="body"><c:out value="${first.description}"/> Our home city in this guide, with ${first.placeCount} places to explore &mdash; from fortresses and palaces to lakes, museums and film-studio tours.</p>
            <div class="btn-row">
                <a class="btn" href="${firstUrl}">Read More &rsaquo;</a>
                <a class="btn btn-ghost" href="${pageContext.request.contextPath}/category">Browse Categories</a>
            </div>
            <div class="feature-thumbs">
                <c:forEach var="fp" items="${featuredPlaces}">
                    <c:url var="fpUrl" value="/place"><c:param name="name" value="${fp.name}"/></c:url>
                    <a class="square" href="${fpUrl}">
                        <span class="img-slot" data-wiki="<c:out value='${fp.wikiTitle}'/>" data-img="<c:out value='${fp.imageUrl}'/>" data-size="500"></span>
                        <span><c:out value="${fp.name}"/></span>
                    </a>
                </c:forEach>
            </div>
        </div>
        <div class="feature-photo img-slot" data-wiki="<c:out value='${first.coverWiki}'/>" data-size="1280"></div>
    </div>
</section>

<%-- ========== Categories ========== --%>
<section class="section">
    <div class="wrap">
        <div class="section-head">
            <div class="kicker">Categories</div>
            <h2>Browse by Experience</h2>
            <p>Looking for something specific? Filter tourist places by type across every city.</p>
        </div>
        <div class="cat-grid">
            <a class="cat-tile" href="${pageContext.request.contextPath}/category?name=Historical"><span class="ico">&#128220;</span>Historical</a>
            <a class="cat-tile" href="${pageContext.request.contextPath}/category?name=Monument"><span class="ico">&#127963;&#65039;</span>Monument</a>
            <a class="cat-tile" href="${pageContext.request.contextPath}/category?name=Palace"><span class="ico">&#128081;</span>Palace</a>
            <a class="cat-tile" href="${pageContext.request.contextPath}/category?name=Museum"><span class="ico">&#128444;&#65039;</span>Museum</a>
            <a class="cat-tile" href="${pageContext.request.contextPath}/category?name=Beach"><span class="ico">&#127958;&#65039;</span>Beach</a>
            <a class="cat-tile" href="${pageContext.request.contextPath}/category?name=Religious"><span class="ico">&#128725;</span>Religious</a>
            <a class="cat-tile" href="${pageContext.request.contextPath}/category?name=Nature"><span class="ico">&#127807;</span>Nature</a>
            <a class="cat-tile" href="${pageContext.request.contextPath}/category?name=Heritage"><span class="ico">&#127984;</span>Heritage</a>
            <a class="cat-tile" href="${pageContext.request.contextPath}/category?name=Adventure"><span class="ico">&#129495;</span>Adventure</a>
            <a class="cat-tile" href="${pageContext.request.contextPath}/category?name=Entertainment"><span class="ico">&#127914;</span>Entertainment</a>
        </div>
    </div>
</section>

<%@ include file="/jsp-includes/footer.jsp" %>
