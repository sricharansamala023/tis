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
 * Handles category-based filtering (Historical, Monument, Palace, Museum,
 * Beach, Religious, Nature, Heritage, Adventure, Entertainment).
 * If no category is supplied, forwards the full list of available
 * categories so the user can pick one on category.jsp.
 */
@WebServlet("/category")
public class CategoryServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String categoryName = request.getParameter("name");

        try {
            List<String> allCategories = XMLDataReader.getAllCategories();
            request.setAttribute("allCategories", allCategories);

            if (categoryName == null || categoryName.trim().isEmpty()) {
                // No category chosen yet: just show the list of categories to pick from.
                request.setAttribute("categoryName", null);
                request.getRequestDispatcher("/category.jsp").forward(request, response);
                return;
            }

            List<TouristPlace> results = XMLDataReader.getPlacesByCategory(categoryName);

            if (results.isEmpty()) {
                request.setAttribute("categoryMessage", "No tourist places were found under the category \"" + categoryName.trim() + "\".");
            }

            request.setAttribute("results", results);
            request.setAttribute("categoryName", categoryName.trim());
            request.getRequestDispatcher("/category.jsp").forward(request, response);

        } catch (XMLDataException e) {
            request.setAttribute("errorMessage", "Unable to load category data: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
