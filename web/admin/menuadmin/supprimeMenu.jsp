<%@page import="java.sql.*" %>
<%@page import="util.connectionDB" %>

<%
    String idplat = request.getParameter("idplat");
    out.println("ID reçu: " + idplat);
    try {
        Connection conn = connectionDB.getConnection();
        if (conn != null && idplat != null && !idplat.isEmpty()) {
            String sql = "DELETE FROM \"MENU\" WHERE idplat=?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, idplat);
            ps.executeUpdate();
            out.println("Suppression réussie");
        } else {
            out.println("Connexion échouée ou ID manquant");
        }
    } catch (Exception e) {
        out.println("Erreur : " + e.getMessage());
    }
%>
