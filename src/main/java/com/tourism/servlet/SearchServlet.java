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
 * Handles the search feature. A visitor can search by city name, place
 * name, or category from a single search box; this servlet performs the
 * matching against the XML-backed data and forwards results to search.jsp.
 */
@WebServlet("/search")
public class SearchServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String query = request.getParameter("query");
        request.setAttribute("query", query == null ? "" : query.trim());

        if (query == null || query.trim().isEmpty()) {
            request.setAttribute("searchMessage", "Please enter a search term (a city, place name, or category).");
            request.getRequestDispatcher("/search.jsp").forward(request, response);
            return;
        }

        try {
            List<TouristPlace> results = XMLDataReader.search(query);

            if (results.isEmpty()) {
                request.setAttribute("searchMessage", "No tourist places matched \"" + query.trim() + "\". Try a different city, place or category name.");
            }

            request.setAttribute("results", results);
            request.getRequestDispatcher("/search.jsp").forward(request, response);

        } catch (XMLDataException e) {
            request.setAttribute("errorMessage", "Unable to perform search: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
