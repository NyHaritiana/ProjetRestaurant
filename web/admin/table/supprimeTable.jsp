<%@page import="java.sql.*" %>
<%@page import="util.connectionDB" %>

<%
    String idtable = request.getParameter("idtable");
    out.println("ID re�u: " + idtable);
    try {
        Connection conn = connectionDB.getConnection();
        if (conn != null && idtable != null && !idtable.isEmpty()) {
            String sql = "DELETE FROM \"TABLE\" WHERE idtable=?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, idtable);
            ps.executeUpdate();
            out.println("Suppression r�ussie");
        } else {
            out.println("Connexion �chou�e ou ID manquant");
        }
    } catch (Exception e) {
        out.println("Erreur : " + e.getMessage());
    }
%>
