<%@page import="java.nio.file.StandardCopyOption"%>
<%@page import="java.nio.file.Files"%>
<%@page import="java.io.*, javax.servlet.*, javax.servlet.http.*"%>
<%@page import="java.util.*"%>
<%@page import="javax.imageio.ImageIO"%>
<%@page import="java.awt.image.BufferedImage"%>

<%
    response.setContentType("text/plain");

    // File upload directory (make sure this directory exists and is writable)
    String uploadPath = application.getRealPath("/") + "uploads/";

    // Create the uploads directory if it doesn't exist
    File uploadDir = new File(uploadPath);
    if (!uploadDir.exists()) {
        uploadDir.mkdirs();
    }

    String fileName = null;
    try {
        // Handle file upload
        Part filePart = request.getPart("file"); // Retrieves <input type="file" name="file">
        fileName = System.currentTimeMillis() + "_" + filePart.getSubmittedFileName(); // Generate a unique file name
        File file = new File(uploadPath + fileName);
        try (InputStream fileContent = filePart.getInputStream()) {
            Files.copy(fileContent, file.toPath(), StandardCopyOption.REPLACE_EXISTING);
        }

        // Respond with the path to the uploaded file
        out.print("upload/" + fileName); // Return the path of the uploaded image
    } catch (Exception e) {
        e.printStackTrace();
        out.print("error"); // Return error if upload fails
    }
%>
