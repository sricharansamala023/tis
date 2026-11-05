package com.tourism.model;

/**
 * Simple POJO describing one city (read from the XML file).
 * Used on the home page and the "Cities" page to build the city cards.
 */
public class City {

    private String name;
    private String state;
    private String tagline;
    private String description;
    /** Wikipedia article title whose photo is used as the city's cover picture. */
    private String coverWiki;
    private int placeCount;

    public City() {
    }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getState() { return state; }
    public void setState(String state) { this.state = state; }

    public String getTagline() { return tagline; }
    public void setTagline(String tagline) { this.tagline = tagline; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getCoverWiki() { return coverWiki; }
    public void setCoverWiki(String coverWiki) { this.coverWiki = coverWiki; }

    public int getPlaceCount() { return placeCount; }
    public void setPlaceCount(int placeCount) { this.placeCount = placeCount; }

    @Override
    public String toString() {
        return "City{name='" + name + "', places=" + placeCount + "}";
    }
}
