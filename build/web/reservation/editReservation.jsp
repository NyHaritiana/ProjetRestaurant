<%@page import="java.sql.*"%>
<%@page import="util.connectionDB"%>

<%
    String idreserv = request.getParameter("idreserv");
    String datereserv = request.getParameter("datereserv");
    String idtable = request.getParameter("idtable");
    String nomcli = request.getParameter("nomcli");
    boolean success = false;
    String message = "";

    if (datereserv != null && datereserv.contains("T")) {
        datereserv = datereserv.replace("T", " ") + ":00";
    }
    try {
        Connection conn = connectionDB.getConnection();
        if (conn != null && idreserv != null && nomcli != null) {
            String sql = "UPDATE \"RESERVER\" SET datereserv=?, idtable=?, nomcli=? WHERE idreserv=?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setTimestamp(1, Timestamp.valueOf(datereserv));
            ps.setString(2, idtable);
            ps.setString(3, nomcli);
            ps.setInt(4, Integer.parseInt(idreserv));
            ps.executeUpdate();
            success = true;
            message = "Modification reussie !";
        } else {
            out.println("Champs manquants ou connexion échouee.");
        }
    } catch (Exception e) {
        out.println("Erreur: " + e.getMessage());
    }
%>

<script>
    alert("<%= message.replace("\"", "\\\"") %>");
    <% if(success) { %>
        window.location.href = "./reservation.jsp?reset=true";
    <% } else { %>
        window.history.back();
    <% } %>
</script>