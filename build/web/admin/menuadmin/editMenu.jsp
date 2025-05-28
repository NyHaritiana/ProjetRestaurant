<%@page import="java.sql.*"%>
<%@page import="util.connectionDB"%>

<%
    String idplat = request.getParameter("idplat");
    String nomplat = request.getParameter("nomplat");
    String pu = request.getParameter("pu");

    try {
        Connection conn = connectionDB.getConnection();
        if (conn != null && idplat != null && nomplat != null) {
            String sql = "UPDATE \"MENU\" SET nomplat=?, pu=? WHERE idplat=?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, nomplat);
            ps.setInt(2, Integer.parseInt(pu));
            ps.setString(3, idplat);
            ps.executeUpdate();
            out.println("Modification reussie !");
        } else {
            out.println("Champs manquants ou connexion échouee.");
        }
    } catch (Exception e) {
        out.println("Erreur: " + e.getMessage());
    }
%>
