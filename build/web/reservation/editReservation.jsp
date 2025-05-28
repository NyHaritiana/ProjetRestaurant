<%@page import="java.sql.*"%>
<%@page import="util.connectionDB"%>

<%
    String idreserv = request.getParameter("idreserv");
    String datereserv = request.getParameter("datereserv");
    String idtable = request.getParameter("idtable");
    String nomcli = request.getParameter("nomcli");

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
            out.println("Modification reussie !");
        } else {
            out.println("Champs manquants ou connexion échouee.");
        }
    } catch (Exception e) {
        out.println("Erreur: " + e.getMessage());
    }
%>
