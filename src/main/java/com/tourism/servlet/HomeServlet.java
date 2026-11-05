package com.tourism.servlet;

import com.tourism.model.City;
import com.tourism.model.TouristPlace;
import com.tourism.util.XMLDataException;
import com.tourism.util.XMLDataReader;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

/**
 * Prepares the data for the home page (/home) and the Cities page (/cities).
 * The list of cities comes from the XML file, so adding a city to the XML
 * automatically adds it to both pages.
 *
 * index.jsp and cities.jsp forward here when opened directly, so the
 * welcome page always has its data.
 */
@WebServlet(urlPatterns = {"/home", "/cities"})
public class HomeServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            List<City> cities = XMLDataReader.getCities();
            request.setAttribute("cities", cities);

            if ("/cities".equals(request.getServletPath())) {
                request.getRequestDispatcher("/cities.jsp").forward(request, response);
                return;
            }

            // Home page: the first city in the XML (Hyderabad) is the featured destination.
            List<TouristPlace> featuredPlaces = XMLDataReader.getPlacesByCity(cities.get(0).getName());
            if (featuredPlaces.size() > 3) {
                featuredPlaces = featuredPlaces.subList(0, 3);
            }
            request.setAttribute("featuredPlaces", featuredPlaces);
            request.getRequestDispatcher("/index.jsp").forward(request, response);

        } catch (XMLDataException e) {
            request.setAttribute("errorMessage", "Unable to load tourist data: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
