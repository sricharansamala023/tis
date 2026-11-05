package com.tourism.servlet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.regex.Pattern;

/**
 * Handles the tourist feedback form. Validates every field on the server
 * side (never trusting client-side validation alone), and if valid, saves
 * the feedback as a line in a simple text log under WEB-INF/feedback
 * (the project intentionally avoids a database, per the XML-only data
 * requirement, so feedback is persisted to a flat file instead).
 */
@WebServlet("/feedback")
public class FeedbackServlet extends HttpServlet {

    private static final Pattern EMAIL_PATTERN =
            Pattern.compile("^[\\w.+-]+@[\\w-]+\\.[a-zA-Z]{2,}$");

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Simply show the empty feedback form.
        request.getRequestDispatcher("/feedback.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String name = trim(request.getParameter("name"));
        String email = trim(request.getParameter("email"));
        String cityPlace = trim(request.getParameter("cityPlace"));
        String rating = trim(request.getParameter("rating"));
        String feedbackText = trim(request.getParameter("feedback"));

        // Preserve entered values so the form can redisplay them on error.
        request.setAttribute("nameValue", name);
        request.setAttribute("emailValue", email);
        request.setAttribute("cityPlaceValue", cityPlace);
        request.setAttribute("ratingValue", rating);
        request.setAttribute("feedbackValue", feedbackText);

        StringBuilder errors = new StringBuilder();

        if (name.isEmpty() || name.length() < 2) {
            errors.append("Please enter your full name. ");
        }
        if (email.isEmpty() || !EMAIL_PATTERN.matcher(email).matches()) {
            errors.append("Please enter a valid email address. ");
        }
        if (cityPlace.isEmpty()) {
            errors.append("Please mention the city or place you visited. ");
        }
        int ratingValue = 0;
        try {
            ratingValue = Integer.parseInt(rating);
        } catch (NumberFormatException e) {
            ratingValue = -1;
        }
        if (ratingValue < 1 || ratingValue > 5) {
            errors.append("Please choose a rating between 1 and 5. ");
        }
        if (feedbackText.isEmpty() || feedbackText.length() < 5) {
            errors.append("Please write a short feedback message (at least 5 characters). ");
        }

        if (errors.length() > 0) {
            request.setAttribute("errorMessage", errors.toString().trim());
            request.getRequestDispatcher("/feedback.jsp").forward(request, response);
            return;
        }

        try {
            saveFeedbackToFile(request, name, email, cityPlace, ratingValue, feedbackText);
            request.setAttribute("successMessage",
                    "Thank you, " + name + "! Your feedback about \"" + cityPlace + "\" has been recorded.");
            // Clear the form values after a successful submission.
            request.removeAttribute("nameValue");
            request.removeAttribute("emailValue");
            request.removeAttribute("cityPlaceValue");
            request.removeAttribute("ratingValue");
            request.removeAttribute("feedbackValue");
        } catch (IOException e) {
            request.setAttribute("errorMessage", "Your feedback could not be saved due to a server error. Please try again.");
        }

        request.getRequestDispatcher("/feedback.jsp").forward(request, response);
    }

    private String trim(String value) {
        return value == null ? "" : value.trim();
    }

    /** Appends the submitted feedback as one line in a text file under WEB-INF/feedback. */
    private void saveFeedbackToFile(HttpServletRequest request, String name, String email,
                                     String cityPlace, int rating, String feedbackText) throws IOException {
        String realPath = request.getServletContext().getRealPath("/WEB-INF/feedback");
        File folder = new File(realPath != null ? realPath : "feedback");
        if (!folder.exists()) {
            folder.mkdirs();
        }
        File file = new File(folder, "feedback.txt");

        String timestamp = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date());
        String line = String.format("[%s] Name: %s | Email: %s | Place: %s | Rating: %d/5 | Feedback: %s%n",
                timestamp, name, email, cityPlace, rating, feedbackText.replace("\n", " "));

        try (FileWriter fw = new FileWriter(file, true);
             PrintWriter pw = new PrintWriter(fw)) {
            pw.print(line);
        }
    }
}
