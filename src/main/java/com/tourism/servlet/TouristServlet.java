package com.tourism.servlet;

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
 * Handles requests for a single tourist place's full detail page.
 * Receives the place name as a request parameter, looks it up via
 * XMLDataReader, and forwards the result to details.jsp.
 */
@WebServlet("/place")
public class TouristServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String placeName = request.getParameter("name");

        if (placeName == null || placeName.trim().isEmpty()) {
            request.setAttribute("errorMessage", "No tourist place was specified.");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
            return;
        }

        try {
            TouristPlace place = XMLDataReader.getPlaceByName(placeName);

            if (place == null) {
                request.setAttribute("errorMessage",
                        "The tourist place '" + placeName + "' could not be found in our records.");
                request.getRequestDispatcher("/error.jsp").forward(request, response);
                return;
            }

            // Other places of the same city (thumbnail strip) and this place's position in that list.
            List<TouristPlace> cityPlaces = XMLDataReader.getPlacesByCity(place.getCity());
            int position = 1;
            for (int i = 0; i < cityPlaces.size(); i++) {
                if (cityPlaces.get(i).getName().equalsIgnoreCase(place.getName())) {
                    position = i + 1;
                    break;
                }
            }

            request.setAttribute("place", place);
            request.setAttribute("cityPlaces", cityPlaces);
            request.setAttribute("placeNumber", String.format("%02d", position));
            request.getRequestDispatcher("/details.jsp").forward(request, response);

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
