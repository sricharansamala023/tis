package com.tourism.model;

/**
 * Simple POJO representing a single tourist place.
 * Instances are created by XMLDataReader after parsing tourist_places.xml
 * and are passed to JSP pages through request attributes.
 */
public class TouristPlace {

    private String name;
    private String category;
    private String city;
    private String location;
    private String description;
    private String history;
    private String visitingInfo;
    private String bestTime;
    private String duration;
    private String nearby;
    private String tips;
    /** English Wikipedia article title used to fetch the place photo. */
    private String wikiTitle;
    /** Optional direct image URL that overrides the Wikipedia photo. */
    private String imageUrl;

    public TouristPlace() {
    }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }

    public String getCity() { return city; }
    public void setCity(String city) { this.city = city; }

    public String getLocation() { return location; }
    public void setLocation(String location) { this.location = location; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getHistory() { return history; }
    public void setHistory(String history) { this.history = history; }

    public String getVisitingInfo() { return visitingInfo; }
    public void setVisitingInfo(String visitingInfo) { this.visitingInfo = visitingInfo; }

    public String getBestTime() { return bestTime; }
    public void setBestTime(String bestTime) { this.bestTime = bestTime; }

    public String getDuration() { return duration; }
    public void setDuration(String duration) { this.duration = duration; }

    public String getNearby() { return nearby; }
    public void setNearby(String nearby) { this.nearby = nearby; }

    public String getTips() { return tips; }
    public void setTips(String tips) { this.tips = tips; }

    public String getWikiTitle() { return wikiTitle; }
    public void setWikiTitle(String wikiTitle) { this.wikiTitle = wikiTitle; }

    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }

    /** Short description used on listing cards so the card layout stays compact. */
    public String getShortDescription() {
        if (description == null) {
            return "";
        }
        if (description.length() <= 105) {
            return description;
        }
        return description.substring(0, 105).trim() + "...";
    }

    @Override
    public String toString() {
        return "TouristPlace{name='" + name + "', city='" + city + "', category='" + category + "'}";
    }
}
