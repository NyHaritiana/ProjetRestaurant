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
            <div class="flex items-center justify-between h-16 px-4 bg-gray-900">
                <span class="text-white text-lg font-bold">Superadmin</span>
            </div>
            <nav class="overflow-y-auto h-[calc(100vh-4rem)]">
                <a href="../admin.jsp" class="flex border-b border-gray-900/10 items-center px-4 py-2 text-gray-100 hover:bg-gray-700">
                    <i class="fas fa-tachometer-alt mr-3"></i>Tableau
                </a>
                <a href="../cli/listeClient.jsp" class="flex border-b border-gray-900/10 items-center px-4 py-2 text-gray-100 hover:bg-gray-700">
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
                
                <%
                    try{
                        Connection conn = connectionDB.getConnection();
                        if(conn != null){
                            String sql = "SELECT * FROM \"MENU\"";
                            PreparedStatement ps = conn.prepareStatement(sql);
                            ResultSet rs = ps.executeQuery();
                        
                %>
                
                <table class="min-w-full divide-y divide-gray-200">
                    <thead>
                        <tr>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Id</th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Nom</th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Prix Unitaire</th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Action</th>
                        </tr>
                    </thead>
                    <tbody class="bg-white divide-y divide-gray-200">
                        <%
                            while(rs.next()){
                        %>
                        <tr>
                            <td class="px-6 py-4 whitespace-nowrap"><%=rs.getString("idplat")%></td>
                            <td class="px-6 py-4 whitespace-nowrap"><%=rs.getString("nomplat")%></td>
                            <td class="px-6 py-4 whitespace-nowrap">Ar <%=rs.getInt("pu")%></td>
                            <td class="px-6 py-4 whitespace-nowrap">
                                <button onclick="openEditModal(
                                    '<%= rs.getString("idplat") %>',
                                    '<%= rs.getString("nomplat").replace("'", "\\'") %>',
                                    '<%= rs.getInt("pu") %>'
                                )"
                                class="px-4 py-2 font-medium text-white bg-blue-600 rounded-md hover:bg-blue-500 transition">
                                    Edit
                                </button>
                                <button onclick="supprimeMenu('<%= rs.getString("idplat")%>')" class="ml-2 px-4 py-2 font-medium text-white bg-red-600 rounded-md hover:bg-red-500 focus:outline-none focus:shadow-outline-red active:bg-red-600 transition duration-150 ease-in-out">Delete</button>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
                    <%
                            } else {
                                out.println("Connexion echouee");
                            }
                        } catch (Exception e) {
                            out.println(e.getMessage());
                        }
                    %>
            </main>
        </div>
    </div>
            
    <!-- Modal Edit Menu -->
    <div id="editModal" class="fixed inset-0 bg-black bg-opacity-50 hidden items-center justify-center z-50">
        <div class="bg-white p-6 rounded-lg shadow-md w-full max-w-md">
            <h2 class="text-xl font-semibold mb-4">Modifier le menu</h2>
            <form id="editForm">
                <input type="hidden" id="edit_idplat" name="idplat" />
                <div class="mb-4">
                    <label for="edit_nomplat" class="block text-gray-700">Nom du menu</label>
                    <input type="text" id="edit_nomplat" name="nomplat" class="w-full px-3 py-2 border rounded" required>
                </div>
                <div class="mb-4">
                    <label for="edit_pu" class="block text-gray-700">Prix unitaire</label>
                    <input type="text" id="edit_pu" name="pu" class="w-full px-3 py-2 border rounded" required>
                </div>

                <div class="flex justify-end">
                    <button type="button" onclick="closeEditModal()" class="mr-2 px-4 py-2 bg-gray-500 text-white rounded">Annuler</button>
                    <button type="submit" class="px-4 py-2 bg-blue-600 text-white rounded">Enregistrer</button>
                </div>
            </form>
        </div>
    </div>
            
            <script>
                function supprimeMenu(idplat) {
                    console.log("Suppression de " + idplat);

                    fetch("supprimeMenu.jsp?idplat=" + encodeURIComponent(idplat))
                        .then(res => res.text())
                        .then(msg => {
                            location.reload();
                        });
                    console.log("URL:", "supprimeMenu.jsp?idplat=" + encodeURIComponent(idplat));
                }
                
                function openEditModal(id, nomplat, pu) {
                    document.getElementById("edit_idplat").value = id;
                    document.getElementById("edit_nomplat").value = nomplat;
                    document.getElementById("edit_pu").value = pu;
                    document.getElementById("editModal").classList.remove("hidden");
                    document.getElementById("editModal").classList.add("flex");
                }

                    function closeEditModal() {
                    document.getElementById("editModal").classList.add("hidden");
                    document.getElementById("editModal").classList.remove("flex");
                }

                    document.getElementById("editForm").addEventListener("submit", function (e) {
                    e.preventDefault();
                    const id = document.getElementById("edit_idplat").value;
                    const nomplat = document.getElementById("edit_nomplat").value;
                    const pu = document.getElementById("edit_pu").value;

                    fetch("editMenu.jsp", {
                        method: "POST",
                        headers: {
                            "Content-Type": "application/x-www-form-urlencoded"
                        },
                        body: "idplat=" + encodeURIComponent(id) +
                              "&nomplat=" + encodeURIComponent(nomplat) +
                              "&pu=" + encodeURIComponent(pu)
                    })
                    .then(res => res.text())
                    .then(msg => {
                        alert(msg);
                        closeEditModal();
                        location.reload();
                    });
                });
            </script>
</body>
</html>