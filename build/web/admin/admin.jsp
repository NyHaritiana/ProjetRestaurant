<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*" %>
<%@page import="util.connectionDB" %>
<%@ page import="java.io.File" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.format.TextStyle" %>
<%@ page import="java.util.Locale" %>


<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Superadmin Dashboard</title>
    <link rel="stylesheet" href="../css/tailwind.min.css"/>
    <script src="https://cdn.tailwindcss.com"></script>
    <script defer src="https://cdn.jsdelivr.net/npm/alpinejs@3.x.x/dist/cdn.min.js"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body class="bg-gray-100 font-sans">
    <div class="min-h-screen flex">

        <!-- Sidebar -->
        <aside class="fixed inset-y-0 left-0 z-50 w-64 bg-gray-800 transform transition-transform duration-300 ease-in-out md:translate-x-0"
               :class="{ 'translate-x-0': sidebarOpen, '-translate-x-full': !sidebarOpen }">
            <div class="flex items-center justify-between h-16 px-4 bg-gray-900">
                <span class="text-white text-lg font-bold">Superadmin</span>
            </div>
            <nav class="overflow-y-auto h-[calc(100vh-4rem)]">
                <a href="#" class="flex border-b border-gray-900/10 items-center px-4 py-2 text-gray-100 hover:bg-gray-700">
                    <i class="fas fa-tachometer-alt mr-3"></i>Tableau
                </a>
                <a href="cli/listeClient.jsp" class="flex border-b border-gray-900/10 items-center px-4 py-2 text-gray-100 hover:bg-gray-700">
                    <i class="fas fa-users mr-3"></i>Client
                </a>
                <div class="border-b border-gray-900/10">
                    <div class="w-full flex items-center justify-between px-4 py-2 text-gray-100">
                        <div class="flex items-center">
                            <i class="fa-solid fa-table mr-3"></i></i>Table
                        </div>
                        <i class="fas" :class="open ? 'fa-chevron-up' : 'fa-chevron-down'"></i>
                    </div>
                    <div class="bg-gray-700">
                        <a href="table/nouveauTable.html" class="block px-8 py-2 text-gray-200 hover:bg-gray-600">Nouveau</a>
                        <a href="table/listeTable.jsp" class="block px-8 py-2 text-gray-200 hover:bg-gray-600">Listes</a>
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
                        <a href="menuadmin/nouveauMenu.html" class="block px-8 py-2 text-gray-200 hover:bg-gray-600">Nouveau</a>
                        <a href="menuadmin/listeMenu.jsp" class="block px-8 py-2 text-gray-200 hover:bg-gray-600">Listes</a>
                    </div>
                </div>

                <a href="../index.jsp" class="flex items-center px-4 py-2 text-gray-100 hover:bg-gray-700">
                    <i class="fas fa-sign-out-alt mr-3"></i>Deconnexion
                </a>
            </nav>
        </aside>

        <!-- Main Content -->
        <div class="flex-1 flex flex-col md:ml-64">
            <header class="bg-white shadow-sm h-16 flex items-center justify-between px-4 fixed top-0 right-0 left-0 md:left-64 z-30">
                <button class="text-gray-500 md:hidden" aria-label="Open sidebar">
                    <i class="fas fa-bars text-2xl"></i>
                </button>
                <div class="flex items-center">
                    <div class="relative">
                        <input type="text" placeholder="Rechercher..."
                               class="pl-10 pr-4 py-2 rounded-lg border focus:outline-none focus:ring-2 focus:ring-blue-500"
                               aria-label="Search">
                    </div>
                </div>
            </header>

            <main class="p-6 mt-16 flex-1 overflow-y-auto">
                <!-- Dashboard Content -->
                <div>
                    <%
                        int totalClients = 0;
                        int totalTables = 0;
                        int totalMenus = 0;
                        double totalRecette = 0;

                        try {
                            Connection conn = connectionDB.getConnection();

                            PreparedStatement ps1 = conn.prepareStatement("SELECT COUNT(DISTINCT nomcli) FROM \"COMMANDE\"");
                            ResultSet rs1 = ps1.executeQuery();
                            if (rs1.next()) totalClients = rs1.getInt(1);

                            PreparedStatement ps2 = conn.prepareStatement("SELECT COUNT(*) FROM \"TABLE\"");
                            ResultSet rs2 = ps2.executeQuery();
                            if (rs2.next()) totalTables = rs2.getInt(1);

                            PreparedStatement ps3 = conn.prepareStatement("SELECT COUNT(*) FROM \"MENU\"");
                            ResultSet rs3 = ps3.executeQuery();
                            if (rs3.next()) totalMenus = rs3.getInt(1);

                            PreparedStatement ps4 = conn.prepareStatement(
                                "SELECT SUM(c.unite * m.pu) FROM \"COMMANDE\" c JOIN \"MENU\" m ON c.idplat = m.idplat"
                            );
                            ResultSet rs4 = ps4.executeQuery();
                            if (rs4.next()) totalRecette = rs4.getDouble(1);
                    %>

                    <h1 class="text-2xl font-bold mb-6">Aperçu des activités</h1>
                    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-6">
                        <div class="bg-white p-6 rounded-lg shadow">
                            <div class="flex items-center">
                                <i class="fas fa-users text-blue-500 text-2xl mr-4"></i>
                                <div>
                                    <p class="text-gray-500">Total clients</p>
                                    <h3 class="text-xl font-bold"><%= totalClients %></h3>
                                </div>
                            </div>
                        </div>
                        <div class="bg-white p-6 rounded-lg shadow">
                            <div class="flex items-center">
                                <i class="fas fa-dollar-sign text-green-500 text-2xl mr-4"></i>
                                <div>
                                    <p class="text-gray-500">Recette</p>
                                    <h3 class="text-xl font-bold">Ar <%= totalRecette %></h3>
                                </div>
                            </div>
                        </div>
                        <div class="bg-white p-6 rounded-lg shadow">
                            <div class="flex items-center">
                                <i class="fas fa-chart-line text-purple-500 text-2xl mr-4"></i>
                                <div>
                                    <p class="text-gray-500">Tables</p>
                                    <h3 class="text-xl font-bold"><%= totalTables %></h3>
                                </div>
                            </div>
                        </div>
                        <div class="bg-white p-6 rounded-lg shadow">
                            <div class="flex items-center">
                                <i class="fas fa-tasks text-yellow-500 text-2xl mr-4"></i>
                                <div>
                                    <p class="text-gray-500">Menus</p>
                                    <h3 class="text-xl font-bold"><%= totalMenus %></h3>
                                </div>
                            </div>
                        </div>
                    </div>
                    <%
                        } catch (Exception e) {
                            out.println("Erreur: " + e.getMessage());
                        }
                    %>
                </div>
                <div>
                    <h1 class="text-2xl font-bold mb-6">Histogramme</h1>
                    <div class="bg-white p-4 rounded-lg shadow">
                        <%
                            Connection conn = connectionDB.getConnection();
                            PreparedStatement psGraph = conn.prepareStatement(
                                "SELECT TO_CHAR(c.datecom, 'Mon YYYY') AS mois, " +
                                "       SUM(c.unite * m.pu) AS total_recette " +
                                "FROM \"COMMANDE\" c " +
                                "JOIN \"MENU\" m ON c.idplat = m.idplat " +
                                "WHERE c.datecom >= CURRENT_DATE - INTERVAL '6 months' " +
                                "GROUP BY TO_CHAR(c.datecom, 'Mon YYYY'), date_trunc('month', c.datecom) " +
                                "ORDER BY date_trunc('month', c.datecom)"
                            );
                            ResultSet rsGraph = psGraph.executeQuery();

                            List<String> moisLabels = new ArrayList<>();
                            List<Double> recettes = new ArrayList<>();

                            while (rsGraph.next()) {
                                moisLabels.add(rsGraph.getString("mois"));
                                recettes.add(rsGraph.getDouble("total_recette"));
                            }
                        %>
                        <%
                            StringBuilder moisJSArray = new StringBuilder();
                            for (int i = 0; i < moisLabels.size(); i++) {
                                moisJSArray.append("\"").append(moisLabels.get(i)).append("\"");
                                if (i < moisLabels.size() - 1) {
                                    moisJSArray.append(", ");
                                }
                            }

                            StringBuilder recettesJSArray = new StringBuilder();
                            for (int i = 0; i < recettes.size(); i++) {
                                recettesJSArray.append(recettes.get(i));
                                if (i < recettes.size() - 1) {
                                    recettesJSArray.append(", ");
                                }
                            }
                        %>
                        <canvas id="graphiqueChart" width="600" height="400"></canvas>
                    </div>
                </div>
            </main>
        </div>
    </div>
    <script>
const ctx = document.getElementById('graphiqueChart').getContext('2d');
new Chart(ctx, {
    type: 'bar',
    data: {
        labels: [<%= moisJSArray.toString() %>],
        datasets: [{
            label: 'Recette',
            data: [<%= recettesJSArray.toString() %>],
            backgroundColor: 'rgba(255, 100, 100, 0.7)',
            borderColor: 'rgba(255, 100, 100, 1)',
            borderWidth: 1
        }]
    },
    options: {
        responsive: true,
        plugins: {
            legend: { display: true },
            title: {
                display: true,
                text: 'Recette mensuelle sur 6 mois'
            }
        },
        scales: {
            y: {
                beginAtZero: true,
                title: {
                    display: true,
                    text: 'Montant'
                }
            },
            x: {
                title: {
                    display: true,
                    text: 'Mois'
                }
            }
        }
    }
});
</script>



</body>
</html>