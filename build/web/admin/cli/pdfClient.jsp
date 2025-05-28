<%@page import="java.sql.*" %>
<%@page import="util.connectionDB" %>
<%@page import="org.apache.pdfbox.pdmodel.*" %>
<%@page import="org.apache.pdfbox.pdmodel.font.*" %>
<%@page import="org.apache.pdfbox.pdmodel.PDPageContentStream" %>
<%@page import="java.io.*" %>

<%
    String nomcli = request.getParameter("nomcli");
    System.out.println("nomcli = " + nomcli);
    response.setContentType("application/pdf");
    response.setHeader("Content-Disposition", "inline; filename=" + nomcli + "_commande.pdf");

    PDDocument document = null;
    Connection connex = null;

    try {
        connex = connectionDB.getConnection();

        String psql = "SELECT c.idcom, c.idplat, m.nomplat, m.pu, c.unite, c.datecom, c.idtable " +
                      "FROM \"COMMANDE\" c " +
                      "JOIN \"MENU\" m ON c.idplat = m.idplat " +
                      "WHERE c.nomcli = ?";
        PreparedStatement pst = connex.prepareStatement(psql);
        pst.setString(1, nomcli);
        ResultSet rst = pst.executeQuery();

        document = new PDDocument();
        PDPage pages = new PDPage();
        document.addPage(pages);

        PDFont font = new PDType1Font(Standard14Fonts.FontName.COURIER_BOLD);
        PDFont fontNormal = new PDType1Font(Standard14Fonts.FontName.COURIER);

        PDPageContentStream contentStream = new PDPageContentStream(document, pages);
        contentStream.beginText();
        contentStream.setFont(font, 12);
        contentStream.setLeading(18f);
        contentStream.newLineAtOffset(50, 750);

        // Première ligne centrée
        contentStream.newLineAtOffset(150, 0);
        contentStream.showText("G_RESTO");
        contentStream.newLine();
        contentStream.newLine();

        rst.next(); // On avance à la première ligne
        String idcom = rst.getString("idcom");
        String idtable = rst.getString("idtable");

        contentStream.setFont(fontNormal, 11);
        contentStream.newLineAtOffset(-150, 0); // Retour à gauche
        contentStream.showText("Code Commande : " + idcom);
        contentStream.newLine();
        contentStream.showText("Nom du client : " + nomcli);
        contentStream.newLine();
        contentStream.showText("Table : " + idtable);
        contentStream.newLine();
        contentStream.newLine();
        contentStream.setFont(font, 11);
        contentStream.showText("Votre facture en détail :");
        contentStream.newLine();
        contentStream.setFont(fontNormal, 10);
        contentStream.showText(String.format("%-20s %-10s %-10s %-10s", "Menu", "PU", "Unité", "Total"));
        contentStream.newLine();

        // Variables à recalculer
        double totalGeneral = 0;

        do {
            String nomplat = rst.getString("nomplat");
            int pu = rst.getInt("pu");
            int unite = rst.getInt("unite");
            double total = pu * unite;
            totalGeneral += total;

            contentStream.showText(String.format("%-20s %-10d %-10d %-10.2f", nomplat, pu, unite, total));
            contentStream.newLine();

        } while (rst.next());

        contentStream.newLine();
        contentStream.setFont(font, 11);
        contentStream.showText(String.format("%50s %.2f Ar", "TOTAL :", totalGeneral));

        contentStream.endText();
        contentStream.close();

        document.save(response.getOutputStream());

    } catch (Exception e) {
        System.err.println("Erreur PDF : " + e.getMessage());
        e.printStackTrace();
    } finally {
        if (document != null) document.close();
        if (connex != null) connex.close();
    }
%>

