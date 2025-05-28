<%@page import="java.sql.*" %>
<%@page import="util.connectionDB" %>

<%
    String idreserv = request.getParameter("idreserv");
    out.println("ID reçu: " + idreserv);
    try {
        Connection conn = connectionDB.getConnection();
        if (conn != null && idreserv != null && !idreserv.isEmpty()) {
            String sql = "DELETE FROM \"RESERVER\" WHERE idreserv=?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, Integer.parseInt(idreserv));
            ps.executeUpdate();
            out.println("Suppression réussie");
        } else {
            out.println("Connexion échouée ou ID manquant");
        }
    } catch (Exception e) {
        out.println("Erreur : " + e.getMessage());
    }
%>
