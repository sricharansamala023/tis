<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<c:set var="pageTitle" value="${place.name} | Tourist Information System"/>
<c:set var="bgWiki" value="${place.wikiTitle}"/>
<%@ include file="/jsp-includes/header.jsp" %>

<%-- ========== Full-screen hero for the place ========== --%>
<section class="dhero">
    <div class="hero-bg img-slot" data-wiki="${place.wikiTitle}" data-img="${place.imageUrl}" data-size="1920"></div>
    <div class="hero-shade"></div>

    <aside class="rail">
        <span class="vtext">${place.city} &middot; Beautiful Places</span>
        <span class="line"></span>
        <span class="year">2026</span>
    </aside>

    <div class="dhero-content stage-content in">
        <div class="stage-num">${placeNumber}</div>
        <div class="eyebrow">${place.city} &middot; ${place.category}</div>
        <h1>${place.name}</h1>
        <p class="lead">${place.description}</p>
        <div class="btn-row">
            <a class="btn" href="#about">Read More &rsaquo;</a>
            <a class="btn btn-ghost" href="${pageContext.request.contextPath}/city?name=${place.city}">Back to ${place.city}</a>
        </div>
    </div>

    <aside class="facts">
        <h4>Quick Facts</h4>
        <dl>
            <dt>Location</dt><dd>${place.location}</dd>
            <dt>Best Time to Visit</dt><dd>${place.bestTime}</dd>
            <dt>Recommended Duration</dt><dd>${place.duration}</dd>
        </dl>
    </aside>

    <div class="strip-wrap">
        <div class="strip-head"><span class="label">More in ${place.city}</span></div>
        <div class="strip">
            <c:forEach var="cp" items="${cityPlaces}" varStatus="st">
                <c:url var="thumbUrl" value="/place">
                    <c:param name="name" value="${cp.name}"/>
                </c:url>
                <a class="thumb ${cp.name eq place.name ? 'active' : ''}" href="${thumbUrl}">
                    <span class="thumb-img img-slot" data-wiki="${cp.wikiTitle}" data-img="${cp.imageUrl}" data-size="500"></span>
                    <span class="cap"><small>${st.count lt 10 ? '0' : ''}${st.count}</small>${cp.name}</span>
                </a>
            </c:forEach>
        </div>
    </div>
</section>

<%-- ========== Organised detail cards ========== --%>
<section class="section" id="about">
    <div class="wrap">
        <div class="cards2">
            <div class="card wide">
                <h2>About ${place.name}</h2>
                <p>${place.description}</p>
            </div>
            <div class="card">
                <h2>Historical Background</h2>
                <p>${place.history}</p>
            </div>
            <div class="card">
                <h2>Visiting Information</h2>
                <p>${place.visitingInfo}</p>
            </div>
            <div class="card">
                <h2>Visitor Tips</h2>
                <p>${place.tips}</p>
            </div>
            <div class="card">
                <h2>At a Glance</h2>
                <p><strong>City:</strong> ${place.city}<br>
                   <strong>Category:</strong> ${place.category}<br>
                   <strong>Location:</strong> ${place.location}<br>
                   <strong>Best time:</strong> ${place.bestTime}<br>
                   <strong>Duration:</strong> ${place.duration}</p>
            </div>
            <div class="card wide">
                <h2>Nearby Attractions</h2>
                <div class="chips">
                    <c:forEach var="n" items="${fn:split(place.nearby, ',')}">
                        <c:url var="nearUrl" value="/search">
                            <c:param name="query" value="${fn:trim(n)}"/>
                        </c:url>
                        <a class="chip" href="${nearUrl}">&#128204; ${fn:trim(n)}</a>
                    </c:forEach>
                </div>
            </div>
        </div>
        <div class="btn-row" style="justify-content:center; margin-top:34px;">
            <a class="btn btn-dark" href="${pageContext.request.contextPath}/city?name=${place.city}">&larr; All places in ${place.city}</a>
            <a class="btn btn-outline" href="${pageContext.request.contextPath}/feedback">Share your feedback</a>
        </div>
    </div>
</section>

<%@ include file="/jsp-includes/footer.jsp" %>
