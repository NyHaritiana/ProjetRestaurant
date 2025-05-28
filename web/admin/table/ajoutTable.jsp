<%@page import="java.sql.*" %>
<%@page import="util.connectionDB" %>

<%
    String idtable = request.getParameter("idtable");
    String designation = request.getParameter("designation");
    String occupation = request.getParameter("occupation");
    Connection conn = connectionDB.getConnection();
    boolean success = false;
    String message = "";
    
    if(conn != null){
        String sql = "INSERT INTO \"TABLE\" (idtable,designation,occupation) VALUES (?,?,?)";
        try{
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, idtable);
            ps.setString(2, designation);
            ps.setBoolean(3, Boolean.parseBoolean(occupation));
            ps.executeUpdate();
            success = true;
            message = "Table ajoutée avec succès !";
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
        window.location.href = "./nouveauTable.html?reset=true";
    <% } else { %>
        window.history.back();
    <% } %>
</script>
