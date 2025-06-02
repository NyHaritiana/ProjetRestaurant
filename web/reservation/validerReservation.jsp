<%@page import="java.sql.*" %>
<%@page import="util.connectionDB" %>

<%
    String datedereserv = request.getParameter("datedereserv");
    String datereserv = request.getParameter("datereserv");
    String idtable = request.getParameter("idtable");
    String nomcli = request.getParameter("nomcli");
    boolean success = false;
    String message = "";

    if (datedereserv != null && datedereserv.contains("T")) {
        datedereserv = datedereserv.replace("T", " ") + ":00";
    }
    if (datereserv != null && datereserv.contains("T")) {
        datereserv = datereserv.replace("T", " ") + ":00";
    }

    Connection conn = connectionDB.getConnection();
    
    if(conn != null){
        String sql = "INSERT INTO \"RESERVER\" (idtable, datedereserv, datereserv, nomcli) VALUES (?, ?, ?, ?)";

        try{
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, idtable);
            ps.setTimestamp(2, Timestamp.valueOf(datedereserv));
            ps.setTimestamp(3, Timestamp.valueOf(datereserv));
            ps.setString(4, nomcli);
            ps.executeUpdate();
            success = true;
            message = "Rerervation confirmée !";
        } catch(Exception e){
            out.println("Erreur : " + e.getMessage());
            message = "Cette table est deja prise pour cette date";
        }
    } else {
        message = "Cette table est deja prise pour cette date";
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