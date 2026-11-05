package com.tourism.util;

import com.tourism.model.City;
import com.tourism.model.TouristPlace;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Set;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

/**
 * Reads and parses tourist_places.xml using the DOM API and serves the
 * parsed data to every Servlet in the application.
 *
 * The XML file is bundled on the classpath (src/main/resources/data) so it
 * is found the same way whether the app is run from an IDE or a deployed
 * WAR file. The parsed lists are cached in memory after the first successful
 * read, since the data does not change while the application is running.
 */
public class XMLDataReader {

    private static final String XML_CLASSPATH_LOCATION = "/data/tourist_places.xml";

    /** In-memory caches built once from the XML file. */
    private static List<TouristPlace> cachedPlaces = null;
    private static List<City> cachedCities = null;

    private XMLDataReader() {
        // utility class - no instances
    }

    /** Loads the XML once (thread-safe); later calls reuse the cached data. */
    private static synchronized void ensureLoaded() throws XMLDataException {
        if (cachedPlaces == null || cachedCities == null) {
            loadFromXml();
        }
    }

    /** Returns every tourist place across all cities. */
    public static List<TouristPlace> getAllPlaces() throws XMLDataException {
        ensureLoaded();
        return cachedPlaces;
    }

    /** Returns every city with its description, tagline and cover photo title. */
    public static List<City> getCities() throws XMLDataException {
        ensureLoaded();
        return cachedCities;
    }

    /** Returns the city with the given name (case-insensitive), or null if there is none. */
    public static City getCityByName(String name) throws XMLDataException {
        if (name == null || name.trim().isEmpty()) {
            return null;
        }
        for (City city : getCities()) {
            if (city.getName().equalsIgnoreCase(name.trim())) {
                return city;
            }
        }
        return null;
    }

    /** Returns every place belonging to the given city (case-insensitive). */
    public static List<TouristPlace> getPlacesByCity(String city) throws XMLDataException {
        List<TouristPlace> result = new ArrayList<>();
        if (city == null || city.trim().isEmpty()) {
            return result;
        }
        for (TouristPlace place : getAllPlaces()) {
            if (place.getCity().equalsIgnoreCase(city.trim())) {
                result.add(place);
            }
        }
        return result;
    }

    /** Returns a single place matched by exact name (case-insensitive), or null if not found. */
    public static TouristPlace getPlaceByName(String name) throws XMLDataException {
        if (name == null || name.trim().isEmpty()) {
            return null;
        }
        for (TouristPlace place : getAllPlaces()) {
            if (place.getName().equalsIgnoreCase(name.trim())) {
                return place;
            }
        }
        return null;
    }

    /** Returns every place matching the given category (case-insensitive). */
    public static List<TouristPlace> getPlacesByCategory(String category) throws XMLDataException {
        List<TouristPlace> result = new ArrayList<>();
        if (category == null || category.trim().isEmpty()) {
            return result;
        }
        for (TouristPlace place : getAllPlaces()) {
            if (place.getCategory().equalsIgnoreCase(category.trim())) {
                result.add(place);
            }
        }
        return result;
    }

    /**
     * Simple keyword search across place name, city and category, which
     * covers examples such as "Fort", "Beach" and "Hyderabad".
     */
    public static List<TouristPlace> search(String query) throws XMLDataException {
        List<TouristPlace> result = new ArrayList<>();
        if (query == null || query.trim().isEmpty()) {
            return result;
        }
        String lowerQuery = query.trim().toLowerCase();
        for (TouristPlace place : getAllPlaces()) {
            if (place.getName().toLowerCase().contains(lowerQuery)
                    || place.getCity().toLowerCase().contains(lowerQuery)
                    || place.getCategory().toLowerCase().contains(lowerQuery)) {
                result.add(place);
            }
        }
        return result;
    }

    /** Returns the distinct list of city names in the order they appear in the XML. */
    public static List<String> getAllCities() throws XMLDataException {
        List<String> names = new ArrayList<>();
        for (City city : getCities()) {
            names.add(city.getName());
        }
        return names;
    }

    /** Returns the distinct list of categories in the order they first appear in the XML. */
    public static List<String> getAllCategories() throws XMLDataException {
        Set<String> categories = new LinkedHashSet<>();
        for (TouristPlace place : getAllPlaces()) {
            categories.add(place.getCategory());
        }
        return new ArrayList<>(categories);
    }

    /**
     * Performs the actual DOM parse of tourist_places.xml. Called only once;
     * fills both caches.
     */
    private static void loadFromXml() throws XMLDataException {
        List<TouristPlace> places = new ArrayList<>();
        List<City> cities = new ArrayList<>();

        try (InputStream xmlStream = XMLDataReader.class.getResourceAsStream(XML_CLASSPATH_LOCATION)) {
            if (xmlStream == null) {
                throw new XMLDataException("Tourist data file not found on classpath: " + XML_CLASSPATH_LOCATION);
            }

            DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
            // Basic hardening: no DOCTYPE / external entities needed for a static local file.
            factory.setFeature("http://apache.org/xml/features/disallow-doctype-decl", true);
            DocumentBuilder builder = factory.newDocumentBuilder();
            Document document = builder.parse(xmlStream);
            document.getDocumentElement().normalize();

            NodeList cityNodes = document.getElementsByTagName("city");

            for (int i = 0; i < cityNodes.getLength(); i++) {
                Node cityNode = cityNodes.item(i);
                if (cityNode.getNodeType() != Node.ELEMENT_NODE) {
                    continue;
                }
                Element cityElement = (Element) cityNode;
                String cityName = cityElement.getAttribute("name");

                City city = new City();
                city.setName(cityName);
                city.setState(cityElement.getAttribute("state"));
                city.setTagline(cityElement.getAttribute("tagline"));
                city.setCoverWiki(cityElement.getAttribute("cover"));
                city.setDescription(getTagValue(cityElement, "summary"));

                int count = 0;
                NodeList placeNodes = cityElement.getElementsByTagName("place");
                for (int j = 0; j < placeNodes.getLength(); j++) {
                    Node placeNode = placeNodes.item(j);
                    if (placeNode.getNodeType() != Node.ELEMENT_NODE) {
                        continue;
                    }
                    Element placeElement = (Element) placeNode;

                    TouristPlace place = new TouristPlace();
                    place.setCity(cityName);
                    place.setName(getTagValue(placeElement, "name"));
                    place.setCategory(getTagValue(placeElement, "category"));
                    place.setLocation(getTagValue(placeElement, "location"));
                    place.setDescription(getTagValue(placeElement, "description"));
                    place.setHistory(getTagValue(placeElement, "history"));
                    place.setVisitingInfo(getTagValue(placeElement, "visitingInfo"));
                    place.setBestTime(getTagValue(placeElement, "bestTime"));
                    place.setDuration(getTagValue(placeElement, "duration"));
                    place.setNearby(getTagValue(placeElement, "nearby"));
                    place.setTips(getTagValue(placeElement, "tips"));
                    place.setWikiTitle(getTagValue(placeElement, "wikiTitle"));
                    place.setImageUrl(getTagValue(placeElement, "image"));

                    places.add(place);
                    count++;
                }
                city.setPlaceCount(count);
                cities.add(city);
            }
        } catch (XMLDataException e) {
            throw e;
        } catch (Exception e) {
            throw new XMLDataException("Failed to parse tourist data XML: " + e.getMessage(), e);
        }

        if (places.isEmpty() || cities.isEmpty()) {
            throw new XMLDataException("Tourist data XML was parsed but contained no places.");
        }

        cachedPlaces = places;
        cachedCities = cities;
    }

    /** Reads the text content of the first descendant element with the given tag name. */
    private static String getTagValue(Element parent, String tagName) {
        NodeList nodeList = parent.getElementsByTagName(tagName);
        if (nodeList.getLength() == 0) {
            return "";
        }
        Node node = nodeList.item(0).getFirstChild();
        return node == null ? "" : node.getNodeValue().trim();
    }
}
