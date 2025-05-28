<%@page import="java.sql.*" %>
<%@page import="util.connectionDB" %>

<%
    String idreserv = request.getParameter("idreserv");
    out.println("ID re�u: " + idreserv);
    try {
        Connection conn = connectionDB.getConnection();
        if (conn != null && idreserv != null && !idreserv.isEmpty()) {
            String sql = "DELETE FROM \"RESERVER\" WHERE idreserv=?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, Integer.parseInt(idreserv));
            ps.executeUpdate();
            out.println("Suppression r�ussie");
        } else {
            out.println("Connexion �chou�e ou ID manquant");
        }
    } catch (Exception e) {
        out.println("Erreur : " + e.getMessage());
    }
%>
