<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${empty pageTitle ? 'Tourist Information System' : pageTitle}</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<%-- Fixed, blurred photo behind the whole page (set per page with <c:set var="bgWiki" .../>) --%>
<div class="site-bg img-slot" data-wiki="${bgWiki}" data-size="1280" aria-hidden="true"></div>
<div class="site-bg-shade" aria-hidden="true"></div>

<header class="nav">
    <div class="nav-left">
        <a class="logo" href="${pageContext.request.contextPath}/home" title="Tourist Information System">TIS</a>
        <form class="nav-search" action="${pageContext.request.contextPath}/search" method="get">
            <input type="text" name="query" placeholder="Search city, place, category" aria-label="Search" autocomplete="off">
            <button type="submit" aria-label="Search">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round"><circle cx="11" cy="11" r="7"/><line x1="16.5" y1="16.5" x2="21" y2="21"/></svg>
            </button>
        </form>
    </div>
    <button class="nav-toggle" id="navToggle" type="button" aria-label="Menu" aria-expanded="false">&#9776;</button>
    <nav class="nav-links" id="navLinks">
        <a href="${pageContext.request.contextPath}/home">Home</a>
        <a href="${pageContext.request.contextPath}/cities">Cities</a>
        <a href="${pageContext.request.contextPath}/category">Categories</a>
        <a href="${pageContext.request.contextPath}/feedback">Feedback</a>
    </nav>
</header>
