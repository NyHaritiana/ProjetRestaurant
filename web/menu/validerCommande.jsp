<%@page import="java.sql.*" %>
<%@page import="util.connectionDB" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.io.*" %>

<%
    String idcom = request.getParameter("idcom");
    String nomcli = request.getParameter("nomcli");
    String datecom = request.getParameter("datecom");
    String idtable = request.getParameter("idtable");
    String idreserv = request.getParameter("idreserv");
    boolean success = false;
    String message = "";

    String[] plats = request.getParameterValues("plats[]");
    String[] unites = request.getParameterValues("unites[]");

    Connection conn = connectionDB.getConnection();

    if (conn != null) {
        String sql = "INSERT INTO \"COMMANDE\" (idcom, idplat, nomcli, unite, idtable, datecom) VALUES (?, ?, ?, ?, ?, ?)";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            for (int i = 0; i < plats.length; i++) {
                ps.setString(1, idcom);
                ps.setString(2, plats[i]);
                ps.setString(3, nomcli);
                ps.setInt(4, Integer.parseInt(unites[i]));
                ps.setString(5, idtable);
                ps.setDate(6, Date.valueOf(datecom));
                ps.executeUpdate();
                
                if (idreserv != null && !idreserv.isEmpty()) {
                String deleteRes = "DELETE FROM \"RESERVER\" WHERE idreserv = ?";
                ps = conn.prepareStatement(deleteRes);
                ps.setInt(1, Integer.parseInt(idreserv));
                ps.executeUpdate();
                ps.close();
            }
                success = true;
                message = "Commande ajoutée avec succès !";
            }
        } catch (Exception e) {
            out.println("Erreur lors de l'insertion : " + e.getMessage());
        }
    } else {
        out.println("Connexion échouée");
    }
%>

<script>
    alert("<%= message.replace("\"", "\\\"") %>");
    <% if(success) { %>
        window.location.href = "./menu.jsp?reset=true";
    <% } else { %>
        window.history.back();
    <% } %>
</script>