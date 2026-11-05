<footer class="footer">
    <div class="wrap">
        <div class="footer-grid">
            <div>
                <h4>Tourist Information System</h4>
                <p>An academic PBLJ project that offers detailed, organised information about ten major Indian cities, built with Java Servlets, JSP and XML.</p>
            </div>
            <div>
                <h4>Explore Cities</h4>
                <ul>
                    <li><a href="${pageContext.request.contextPath}/city?name=Hyderabad">Hyderabad</a></li>
                    <li><a href="${pageContext.request.contextPath}/city?name=Jaipur">Jaipur</a></li>
                    <li><a href="${pageContext.request.contextPath}/city?name=Chennai">Chennai</a></li>
                    <li><a href="${pageContext.request.contextPath}/city?name=Visakhapatnam">Visakhapatnam</a></li>
                    <li><a href="${pageContext.request.contextPath}/city?name=Delhi">Delhi</a></li>
                    <li><a href="${pageContext.request.contextPath}/cities">All 10 cities &rarr;</a></li>
                </ul>
            </div>
            <div>
                <h4>Quick Links</h4>
                <ul>
                    <li><a href="${pageContext.request.contextPath}/search.jsp">Search Places</a></li>
                    <li><a href="${pageContext.request.contextPath}/category">Browse Categories</a></li>
                    <li><a href="${pageContext.request.contextPath}/feedback">Give Feedback</a></li>
                </ul>
            </div>
        </div>
        <div class="footer-bottom">
            &copy; 2026 Tourist Information System &mdash; PBLJ Project No. 16 &middot; Java &middot; Servlets &middot; JSP &middot; XML.
            Photographs are loaded from Wikipedia / Wikimedia Commons.
        </div>
    </div>
</footer>
<script src="${pageContext.request.contextPath}/js/app.js"></script>
</body>
</html>
