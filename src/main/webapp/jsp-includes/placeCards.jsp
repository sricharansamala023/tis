<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%-- Reusable grid of photo cards. The including page sets: <c:set var="cardList" value="..."/> --%>
<div class="pgrid">
    <c:forEach var="p" items="${cardList}">
        <c:url var="cardUrl" value="/place">
            <c:param name="name" value="${p.name}"/>
        </c:url>
        <a class="pcard" href="${cardUrl}">
            <div class="pcard-img img-slot" data-wiki="${p.wikiTitle}" data-img="${p.imageUrl}" data-size="500"></div>
            <div class="pcard-shade"></div>
            <span class="pcard-cat">${p.category}</span>
            <div class="pcard-body">
                <h3>${p.name}</h3>
                <div class="pcard-loc">&#128205; ${p.city}</div>
                <p>${p.shortDescription}</p>
                <span class="pcard-go">View Details &rarr;</span>
            </div>
        </a>
    </c:forEach>
</div>
