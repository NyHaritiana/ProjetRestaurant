<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*" %>
<%@page import="util.connectionDB" %>

<!DOCTYPE html>
<html>
    <head>
        <title>G_Resto</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="stylesheet" href="../css/tailwind.min.css"/>
        <link rel="stylesheet" href="../css/style.css"/>
        <style>
        /* Custom styles */
        .blur-bg {
            backdrop-filter: blur(8px);
            -webkit-backdrop-filter: blur(8px);
        }
        .dropdown-content {
            display: none;
            position: absolute;
            min-width: 200px;
            z-index: 50;
        }
        .portfolio-dropdown {
            min-width: 90vw;
            max-width: 1200px;
            left: 50%;
            transform: translateX(-50%);
        }
        @media (max-width: 1024px) {
            .portfolio-dropdown {
                width: 95vw;
            }
        }
        input[type="datetime-local"]::-webkit-calendar-picker-indicator {
            filter: invert(1);
        }
        input[type="time"]::-webkit-calendar-picker-indicator {
            filter: invert(1);
        }
        ::-webkit-scrollbar {
          width: 4px; /* largeur scrollbar */
        }

        ::-webkit-scrollbar-track {
          background: transparent; /* couleur fond */
        }

        /* Scrollbar Thumb (la "poignée") */
        ::-webkit-scrollbar-thumb {
          background-color: #888; /* couleur poignée */
          border-radius: 6px;       /* arrondi */
          border: 3px solid transparent; /* espace autour */
        }

        /* Au survol */
        ::-webkit-scrollbar-thumb:hover {
          background-color: #555;
        }
        </style>
    </head>
    <body class="bg-gray-900 font-sans">
    <div class="relative min-h-screen">
        <header class="fixed top-0 left-0 right-0 bg-gray-800 transition-all duration-300 z-40 blur-bg shadow-lg">
            <div class="container mx-auto px-4 py-3">
                <div class="flex justify-between items-center">
                    <!-- Logo -->
                    <div class="flex-shrink-0">
                        <a href="#" class="text-2xl font-bold text-blue-600">
                            <img src="/api/placeholder/150/50" alt="Logo" class="h-10">
                        </a>
                    </div>

                    <!-- Mobile Menu Button -->
                    <button @click="mobileMenuOpen = !mobileMenuOpen" class="lg:hidden block text-gray-600 focus:outline-none">
                        <svg class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path x-show="!mobileMenuOpen" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16m-7 6h7"></path>
                            <path x-show="mobileMenuOpen" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path>
                        </svg>
                    </button>

                    <!-- Menu -->
                    <nav class="hidden lg:flex space-x-8 items-center">
                        <!-- Accueil -->
                        <div class="relative">
                            <a href="../index.jsp" class="flex items-center text-gray-100 hover:text-blue-400 focus:outline-none">
                                Accueil
                            </a>
                        </div>

                        <!-- Menu -->
                        <div class="relative">
                            <a href="../menu/menu.jsp" class="flex items-center text-gray-100 hover:text-blue-400 focus:outline-none">
                                Menu
                            </a>
                        </div>

                        <!-- Réservation -->
                        <div class="relative">
                            <a class="flex items-center text-gray-100 hover:text-blue-400 focus:outline-none">
                                Réservation
                            </a>
                        </div>

                        <!-- Connexion -->
                        <div class="relative">
                            <a href="../admin/admin.jsp" class="flex items-center text-gray-100 font-bold bg-blue-500 px-4 py-2 rounded-3xl hover:text-blue-500 hover:bg-gray-200 focus:outline-none">
                                Connexion
                            </a>
                        </div>
                    </nav>
                </div>
            </div>
        </header>
        <main class='pt-16'>
            <section>
                <h1 class='text-white text-2xl text-center font-bold pt-6'>Réservation</h1>
                <div class="mt-12 flex justify-center">
                    <form method="POST" action="validerReservation.jsp">
                    <table>
                        <tr>
                            <td class="border py-2"><input type="datetime-local" id="dateday" name="datedereserv" class="bg-transparent text-gray-100 px-2 focus:outline-none focus:border-none focus:ring-0" readonly></td>
                            <td class="border py-2">
                                <%
                                    try{
                                        String currentTableId = request.getParameter("idtable"); // récupère l'id de la table en cours de modification
                                        Connection conn = connectionDB.getConnection();
                                        if(conn != null){
                                            String sql = "SELECT * FROM \"TABLE\" WHERE idtable NOT IN (SELECT idtable FROM \"RESERVER\")";
                                            if (currentTableId != null && !currentTableId.isEmpty()) {
                                                sql += " OR idtable = ?";
                                            }
                                            PreparedStatement ps = conn.prepareStatement(sql);
                                            if (currentTableId != null && !currentTableId.isEmpty()) {
                                                ps.setString(1, currentTableId);
                                            }
                                            ResultSet rs = ps.executeQuery();

                                %>    
                                <select id="idtable" name="idtable" class="px-4 py-1 mx-2 bg-transparent transition duration-150 ease-in-out text-gray-100 focus:outline-none focus:border-none focus:ring-0" required>
                                        <option class="text-gray-800" value="selected disable" selected disabled>Selectionner une table</option>
                                        <%
                                            while(rs.next()){
                                        %>
                                        <option class="text-gray-800"><%=rs.getString("idtable")%></option>
                                        <% } %>
                                    </select> 
                                 <%
                                    } else {
                                            out.println("Connexion echouee");
                                        }
                                    } catch (Exception e) {
                                        out.println(e.getMessage());
                                    }
                                %>
                            </td>
                            <td class="border py-2">
                                <input type="datetime-local" id="datereserve" name="datereserv" class="bg-transparent text-gray-100 px-2 focus:outline-none focus:border-none focus:ring-0" required>
                            </td>
                            <td class="border py-2"><input type="text" placeholder="votre nom" id="nomcli" name="nomcli" class="bg-transparent text-gray-100 px-2 focus:outline-none focus:border-none focus:ring-0" required></td>
                            <td>
                                <input type="hidden" id="idreserv" name="idreserv">
                                <input type="hidden" id="currentTableId" name="idtable">
                            </td>
                            <td><button type="submit" class="bg-blue-500 text-gray-100 mx-4 py-3 px-6 rounded hover:bg-blue-600">valider</button></td>
                        </tr>
                    </table>
                   </form>
                </div>
                <div class="mx-24 my-12">
                    <h1 class="text-white text-2xl font-bold">Les tables réservés</h1>
                    <%
                        try{
                            Connection conn = connectionDB.getConnection();
                            if(conn != null){
                                String sql = "SELECT * FROM \"RESERVER\"";
                                PreparedStatement ps = conn.prepareStatement(sql);
                                ResultSet rs = ps.executeQuery();
                        
                    %>
                    <table class="w-full my-4">
                        <thead class="border-b border-gray-500">
                            <tr class="text-gray-100 text-xl text-left">
                                <th class="font-semibold pb-4">Client</th>
                                <th class="font-semibold pb-4">Tables</th>
                                <th class="font-semibold pb-4">Date de réservation</th>
                                <th class="font-semibold pb-4">Réservé le</th>
                                <th class="font-semibold pb-4">Action</th>
                            </tr>
                        </thead>
                        <tbody class="text-gray-100">
                            <%
                                while(rs.next()){
                            %>
                            <tr>
                                <td class="py-4"><%=rs.getString("nomcli")%></td>
                                <td class="py-4"><%=rs.getString("idtable")%></td>
                                <td class="py-4"><%=rs.getTimestamp("datedereserv").toLocalDateTime().toString().replace(" ", "T").substring(0, 16)%></td>
                                <td class="py-4"><%=rs.getTimestamp("datereserv").toLocalDateTime().toString().replace(" ", "T").substring(0, 16)%></td>
                                <td class="py-4"><button onclick="annulerReservation('<%= rs.getInt("idreserv")%>')" class="px-4 py-2 text-white bg-red-600 rounded-md hover:bg-red-500 focus:outline-none active:bg-red-600 transition duration-150 ease-in-out">Annuler</button></td>
                                <td class="py-4">
                                  <button 
                                    onclick="remplirFormulaire(
                                      '<%= rs.getInt("idreserv") %>',
                                      '<%= rs.getTimestamp("datereserv").toLocalDateTime().toString().replace(" ", "T").substring(0, 16) %>',
                                      '<%= rs.getString("idtable") %>',
                                      '<%= rs.getString("nomcli").replace("'", "\\'") %>'
                                    )"
                                    class="px-4 py-2 text-white bg-blue-600 rounded-md hover:bg-blue-500 focus:outline-none active:bg-red-600 transition duration-150 ease-in-out">
                                    Modifier
                                  </button>
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
                </div>
            </section>
        </main>
    </div>

    <script>
        // Additional initialization if needed
        document.addEventListener('alpine:init', () => {
            // Any additional Alpine.js initialization can go here
        });
        
        const now = new Date();
        now.setMinutes(now.getMinutes() - now.getTimezoneOffset());
        document.getElementById('dateday').value = now.toISOString().slice(0,16);
        
        function annulerReservation(idreserv) {
            console.log("Suppression de " + idreserv);

            fetch("annulerReservation.jsp?idreserv=" + encodeURIComponent(idreserv))
                .then(res => res.text())
                .then(msg => {
                    location.reload();
                });
            console.log("URL:", "annulerReservation.jsp?idreserv=" + encodeURIComponent(idreserv));
        }
        function remplirFormulaire(idreserv, datereserv, idtable, nomcli) {
            document.getElementById('idreserv').value = idreserv;
            document.getElementById('datereserve').value = datereserv;
            document.getElementById("currentTableId").value = idtable;
            document.getElementById('nomcli').value = nomcli;
            
            let select = document.getElementById("idtable");
            for (let i = 0; i < select.options.length; i++) {
                if (select.options[i].value === idtable) {
                    select.selectedIndex = i;
                    break;
                }
            }

            document.querySelector('form').action = 'editReservation.jsp';

            window.scrollTo({ top: 0, behavior: 'smooth' });
        }
        
        window.addEventListener('DOMContentLoaded', () => {
            const params = new URLSearchParams(window.location.search);
            if (params.get('reset') === 'true') {
                document.getElementById('tableForm').reset();
                window.history.replaceState({}, document.title, window.location.pathname);
            }
        });
        
          function getCurrentDateTimeLocal() {
            const now = new Date();
            now.setSeconds(0, 0);
            const offset = now.getTimezoneOffset();
            now.setMinutes(now.getMinutes() - offset);

            return now.toISOString().slice(0, 16);
          }

          const datetimeInput = document.getElementById("datereserve");
          datetimeInput.min = getCurrentDateTimeLocal();
    </script>
</body>
</html>