<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*" %>
<%@page import="util.connectionDB" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Superadmin Dashboard</title>
    <link rel="stylesheet" href="../../css/tailwind.min.css"/>
    <script src="https://cdn.tailwindcss.com"></script>
    <script defer src="https://cdn.jsdelivr.net/npm/alpinejs@3.x.x/dist/cdn.min.js"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body class="bg-gray-100 font-sans">
    <div class="min-h-screen flex">

        <!-- Sidebar -->
        <aside class="fixed inset-y-0 left-0 z-50 w-64 bg-gray-800 transform transition-transform duration-300 ease-in-out md:translate-x-0"
               :class="{ 'translate-x-0': sidebarOpen, '-translate-x-full': !sidebarOpen }">
            <div class="flex items-center h-16 px-4 bg-gray-900">
                <img src="../../images/gresto.png" alt="Logo" class="h-10">
                <span class="text-white text-lg font-bold mx-2">Superadmin</span>
            </div>
            <nav class="overflow-y-auto h-[calc(100vh-4rem)]">
                <a href="../admin.jsp" class="flex border-b border-gray-900/10 items-center px-4 py-2 text-gray-100 hover:bg-gray-700">
                    <i class="fas fa-tachometer-alt mr-3"></i>Tableau
                </a>
                <a href="#" class="flex border-b border-gray-900/10 items-center px-4 py-2 text-gray-100 hover:bg-gray-700">
                    <i class="fas fa-users mr-3"></i>Client
                </a>
                <div class="border-b border-gray-900/10">
                    <div class="w-full flex items-center justify-between px-4 py-2 text-gray-100">
                        <div class="flex items-center">
                            <i class="fa-solid fa-table mr-3"></i>Table
                        </div>
                        <i class="fas" :class="open ? 'fa-chevron-up' : 'fa-chevron-down'"></i>
                    </div>
                    <div class="bg-gray-700">
                        <a href="../table/nouveauTable.html" class="block px-8 py-2 text-gray-200 hover:bg-gray-600">Nouveau</a>
                        <a href="../table/listeTable.jsp" class="block px-8 py-2 text-gray-200 hover:bg-gray-600">Listes</a>
                    </div>
                </div>
                <div class="border-b border-gray-900/10">
                    <div class="w-full flex items-center justify-between px-4 py-2 text-gray-100">
                        <div class="flex items-center">
                            <i class="fa-solid fa-list mr-3"></i>Menu
                        </div>
                        <i class="fas" :class="open ? 'fa-chevron-up' : 'fa-chevron-down'"></i>
                    </div>
                    <div class="bg-gray-700">
                        <a href="./nouveauMenu.html" class="block px-8 py-2 text-gray-200 hover:bg-gray-600">Nouveau</a>
                        <a href="#" class="block px-8 py-2 text-gray-200 hover:bg-gray-600">Listes</a>
                    </div>
                </div>

                <a href="../../index.jsp" class="flex items-center px-4 py-2 text-gray-100 hover:bg-gray-700">
                    <i class="fas fa-sign-out-alt mr-3"></i>Deconnexion
                </a>
            </nav>
        </aside>

        <!-- Main Content -->
        <div class="flex-1 flex flex-col md:ml-64">
            <header class="bg-white shadow-sm h-20 flex flex-col justify-center px-4 fixed top-0 right-0 left-0 md:left-64 z-30">
                <form method="get" class="flex flex-wrap items-center space-x-4">
                    <label class="text-sm font-medium">Date exacte :</label>
                    <input type="date" name="date_exacte"
                           class="pl-2 pr-4 py-2 rounded-lg border focus:outline-none focus:ring-2 focus:ring-blue-500" />

                    <label class="text-sm font-medium">Entre :</label>
                    <input type="date" name="date_debut"
                           class="pl-2 pr-4 py-2 rounded-lg border focus:outline-none focus:ring-2 focus:ring-blue-500" />
                    <label class="text-sm font-medium">-</label>
                    <input type="date" name="date_fin"
                           class="pl-2 pr-4 py-2 rounded-lg border focus:outline-none focus:ring-2 focus:ring-blue-500" />

                    <button type="submit" class="bg-blue-600 text-white px-4 py-2 rounded-lg">Rechercher</button>
                </form>
            </header>

            <main class="p-6 mt-28 flex-1 overflow-y-auto">
                <%
                    try {
                        Connection conn = connectionDB.getConnection();
                        if (conn != null) {
                            String dateExacte = request.getParameter("date_exacte");
                            String dateDebut = request.getParameter("date_debut");
                            String dateFin = request.getParameter("date_fin");

                            String sql = "SELECT nomcli, datecom, idplat FROM \"COMMANDE\" WHERE 1=1";
                            if (dateExacte != null && !dateExacte.isEmpty()) {
                                sql += " AND datecom = ?";
                            } else if (dateDebut != null && !dateDebut.isEmpty() && dateFin != null && !dateFin.isEmpty()) {
                                sql += " AND datecom BETWEEN ? AND ?";
                            }
                            sql += " ORDER BY nomcli, datecom";

                            PreparedStatement ps = conn.prepareStatement(sql);
                            int paramIndex = 1;
                            if (dateExacte != null && !dateExacte.isEmpty()) {
                                ps.setDate(paramIndex++, java.sql.Date.valueOf(dateExacte));
                            } else if (dateDebut != null && !dateDebut.isEmpty() && dateFin != null && !dateFin.isEmpty()) {
                                ps.setDate(paramIndex++, java.sql.Date.valueOf(dateDebut));
                                ps.setDate(paramIndex++, java.sql.Date.valueOf(dateFin));
                            }

                            ResultSet rs = ps.executeQuery();
                %>

                <table class="min-w-full divide-y divide-gray-200">
                    <thead>
                        <tr>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Nom</th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Date</th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Commande</th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Action</th>
                        </tr>
                    </thead>
                    <tbody class="bg-white divide-y divide-gray-200">
                        <%
                            String previousNom = "";
                            java.sql.Date previousDate = null;

                            while (rs.next()) {
                                String currentNom = rs.getString("nomcli");
                                java.sql.Date currentDate = rs.getDate("datecom");
                                String commande = rs.getString("idplat");

                                boolean showNom = !currentNom.equals(previousNom);
                                boolean showDate = showNom || (previousDate == null || !currentDate.equals(previousDate));
                        %>
                        <tr<%= showNom ? " class='border-t border-gray-300'" : "" %>>
                            <td class="px-6 py-4 whitespace-nowrap"><%= showNom ? currentNom : "" %></td>
                            <td class="px-6 py-4 whitespace-nowrap"><%= showDate ? currentDate : "" %></td>
                            <td class="px-6 py-4 whitespace-nowrap"><%= commande %></td>
                            <td class="px-6 py-4 whitespace-nowrap">
                                <% if (showNom) { %>
                                    <form method="post" action="pdfClient.jsp" target="_blank">
                                        <input type="hidden" name="nomcli" value="<%= showNom ? currentNom : "" %>">
                                        <button type="submit" class="bg-blue-600 text-white px-3 py-1 rounded">
                                            Générer PDF
                                        </button>
                                    </form>
                                <% } %>
                            </td>
                        </tr>
                        <%
                                previousNom = currentNom;
                                previousDate = currentDate;
                            }
                        %>
                    </tbody>
                </table>

                <%
                        } else {
                            out.println("Connexion échouée");
                        }
                    } catch (Exception e) {
                        out.println("Erreur : " + e.getMessage());
                    }
                %>
            </main>
        </div>
    </div>
</body>
</html>