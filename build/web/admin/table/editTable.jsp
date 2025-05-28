<%@page import="java.sql.*"%>
<%@page import="util.connectionDB"%>

<%
    String idtable = request.getParameter("idtable");
    String designation = request.getParameter("designation");
    String occupation = request.getParameter("occupation");

    try {
        Connection conn = connectionDB.getConnection();
        if (conn != null && idtable != null && designation != null) {
            String sql = "UPDATE \"TABLE\" SET designation=?, occupation=? WHERE idtable=?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, designation);
            ps.setBoolean(2, Boolean.parseBoolean(occupation));
            ps.setString(3, idtable);
            ps.executeUpdate();
            out.println("Modification reussie !");
        } else {
            out.println("Champs manquants ou connexion échouee.");
        }
    } catch (Exception e) {
        out.println("Erreur: " + e.getMessage());
    }
%>
