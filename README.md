# Tourist Information System (PBLJ Project No. 16)

A multi-city **Tourist Information System for India** built strictly with **Java Servlets, JSP and XML**
(Project No. 16, Travel domain). **10 cities x 10 places = 100 tourist places**, with photographs, details,
search, category filters and a feedback form, in a translucent "glass" interface over full-screen photos.

Cities: Hyderabad (featured), Jaipur, Chennai, Visakhapatnam, Delhi, Mumbai, Agra, Varanasi, Kolkata, Goa.

## Objective
Offer tourists detailed and organised information through an efficient, user-friendly system.

## Features
- Full-screen home page with a city slider, numbered thumbnail strip, "Explore India" city cards, featured destination, categories, footer
- Translucent glass interface: one fixed blurred photo behind every page, frosted-glass navigation, cards and forms
- City selection, 10 place cards per city, and detailed place pages (history, visiting info, best time, duration, nearby, tips)
- Servlet-processed search (city / place / category) and category filtering (10 categories)
- Feedback form with server-side validation (saved to a text file)
- Friendly error pages (invalid city/place, empty search, no results, missing/invalid XML, bad feedback)
- Responsive layout for desktop and mobile

## Technologies
Java 25 LTS, Servlet 4.0, JSP 2.3 + JSTL 1.2, XML (DOM parser), HTML5/CSS3, a little vanilla JavaScript, Maven, Tomcat 9. **No database.**

## Project Structure
```
TouristInformationSystem/
├── pom.xml
├── README.md
└── src/main/
    ├── java/com/tourism/
    │   ├── servlet/  HomeServlet, CityServlet, TouristServlet, SearchServlet, CategoryServlet, FeedbackServlet
    │   ├── model/    TouristPlace, City
    │   └── util/     XMLDataReader, XMLDataException
    ├── resources/data/tourist_places.xml     <- the data source (10 cities, 100 places)
    └── webapp/
        ├── index.jsp, cities.jsp, places.jsp, details.jsp, search.jsp, category.jsp, feedback.jsp, error.jsp
        ├── jsp-includes/  header.jsp, footer.jsp, placeCards.jsp
        ├── css/style.css
        ├── js/app.js
        └── WEB-INF/web.xml
```

## How XML Works
`tourist_places.xml` holds every city and place:
```xml
<city name="Hyderabad" state="Telangana" tagline="City of Pearls" cover="Charminar">
    <summary>...</summary>
    <place>
        <name>Charminar</name> <category>Historical</category> <location>...</location>
        <description>...</description> <history>...</history> <visitingInfo>...</visitingInfo>
        <bestTime>...</bestTime> <duration>...</duration> <nearby>...</nearby> <tips>...</tips>
        <wikiTitle>Charminar</wikiTitle>   <!-- Wikipedia article used for the photo -->
        <image></image>                    <!-- optional direct image URL override -->
    </place>
</city>
```
`XMLDataReader` parses it with the **DOM API** into `City` and `TouristPlace` objects (cached after the first read).
Servlets never read the file directly. **To add a city or place, just edit the XML** - the pages update automatically.

## How Servlets Work
| Servlet | URL | Purpose |
|---|---|---|
| HomeServlet | `/home`, `/cities` | city list for the home page and Cities page |
| CityServlet | `/city?name=Goa` | the 10 places of one city |
| TouristServlet | `/place?name=Taj%20Mahal` | full details + other places in the same city |
| SearchServlet | `/search?query=Fort` | search name / city / category |
| CategoryServlet | `/category?name=Beach` | filter by category |
| FeedbackServlet | `/feedback` (POST) | validate and store feedback |

Each servlet reads parameters, asks `XMLDataReader` for data, sets request attributes and forwards to a JSP.

## How JSP Works
JSP pages only display data using EL and JSTL (`${...}`, `<c:forEach>`, `<c:url>`). `header.jsp`, `footer.jsp`
and `placeCards.jsp` are shared includes. There are no business-logic scriptlets.

## Photographs
`js/app.js` asks the Wikipedia REST API for each article's lead image and sets it as the card/hero background
(if an article title is not found it falls back to a Wikipedia search). **The computer needs internet access to see
photos**; without it every page still works and cards show a teal-to-gold gradient. To use your own picture for a place,
paste an image URL into its `<image></image>` tag in the XML. Photos come from Wikipedia / Wikimedia Commons (free licences).

## How to Run
Use **Tomcat 9** (not 10+): the project uses the `javax.servlet` namespace.
Build and run with a Java 25 JDK.

### VS Code / any terminal (no separate Tomcat install)
From the folder that contains `pom.xml`:
```
mvn clean package cargo:run -Pcargo
```
then open `http://localhost:8080/TouristInformationSystem/`. Press Ctrl+C to stop (always stop it before rerunning).

### Maven + your own Tomcat
```
mvn clean package
```
Copy `target/TouristInformationSystem.war` to Tomcat's `webapps`, start Tomcat and open the same URL.

### Eclipse / NetBeans / IntelliJ
Import as a Maven project, add Tomcat 9, Run on Server.

## Sample URLs
```
/home            /cities
/city?name=Goa
/place?name=Golconda%20Fort
/search?query=Fort        /search?query=Beach        /search?query=Mumbai
/category?name=Entertainment
/feedback
```

## Expected Output
- Home: full-screen photo of Hyderabad with a 10-city thumbnail strip; clicking a thumbnail switches the city and the page background.
- City page: photo hero plus 10 place cards. Detail page: full-screen photo, quick-facts glass panel, "More in <city>" strip, glass info cards.
- "Fort" lists forts in several cities; "Beach" lists beaches in Chennai, Visakhapatnam, Mumbai and Goa.

## Future Enhancements
Admin page to edit the XML, maps, multi-language support, user accounts and saved itineraries, local photo galleries.
