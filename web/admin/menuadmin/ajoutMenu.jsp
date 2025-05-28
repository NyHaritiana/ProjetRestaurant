<%@page import="java.sql.*" %>
<%@page import="util.connectionDB" %>

<%
    String idplat = request.getParameter("idplat");
    String nomplat = request.getParameter("nomplat");
    String puStr = request.getParameter("pu");
    boolean success = false;
    String message = "";
    int pu = 0;
    try{
        pu = Integer.parseInt(puStr);
    } catch(NumberFormatException e){
        e.printStackTrace();
    }
    Connection conn = connectionDB.getConnection();
    if(conn != null){
        String sql = "INSERT INTO \"MENU\" (idplat,nomplat,pu) VALUES (?,?,?)";
        try{
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, idplat);
            ps.setString(2, nomplat);
            ps.setInt(3, pu);
            ps.executeUpdate();
            success = true;
            message = "Plat ajoutée avec succès !";
        } catch(Exception e){
            out.println(e.getMessage());
        }
    } else {
        out.println("connexion echouee");
    }
%>

<script>
    alert("<%= message.replace("\"", "\\\"") %>");
    <% if(success) { %>
        window.location.href = "./nouveauMenu.html?reset=true";
    <% } else { %>
        window.history.back();
    <% } %>
</script>