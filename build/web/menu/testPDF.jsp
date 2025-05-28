<%@page import="org.apache.pdfbox.pdmodel.*" %>
<%@page import="org.apache.pdfbox.pdmodel.font.*" %>
<%@page import="java.io.*" %>

<%
    try {
        PDDocument document = new PDDocument();
        PDPage page = new PDPage();
        document.addPage(page);

        PDPageContentStream content = new PDPageContentStream(document, page);
        content.beginText();
        content.setFont(PDType1Font.HELVETICA_BOLD, 14);
        content.newLineAtOffset(100, 700);
        content.showText("PDF g�n�r� avec succ�s !");
        content.endText();
        content.close();

        String fullPath = application.getRealPath("/") + "factures/test.pdf";
        new File(application.getRealPath("/") + "factures/").mkdirs();
        document.save(fullPath);
        document.close();

        out.println("PDF g�n�r� : <a href='factures/test.pdf' target='_blank'>T�l�charger</a>");
    } catch (Exception e) {
        out.println("Erreur : " + e.getMessage());
    }
%>
