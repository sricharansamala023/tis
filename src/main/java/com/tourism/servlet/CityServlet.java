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
 * Handles city selection. Receives a city name as a request parameter,
 * fetches every tourist place belonging to that city from the XML data,
 * and forwards the result to places.jsp for display.
 */
@WebServlet("/city")
public class CityServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String cityName = request.getParameter("name");

        if (cityName == null || cityName.trim().isEmpty()) {
            request.setAttribute("errorMessage", "No city was specified. Please choose a city from the home page.");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
            return;
        }

        try {
            City city = XMLDataReader.getCityByName(cityName);

            if (city == null) {
                request.setAttribute("errorMessage",
                        "'" + cityName + "' is not a recognised city in this system. Please select a city from the list.");
                request.getRequestDispatcher("/error.jsp").forward(request, response);
                return;
            }

            List<TouristPlace> places = XMLDataReader.getPlacesByCity(city.getName());

            request.setAttribute("places", places);
            request.setAttribute("cityName", city.getName());
            request.setAttribute("cityInfo", city);
            request.getRequestDispatcher("/places.jsp").forward(request, response);

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
