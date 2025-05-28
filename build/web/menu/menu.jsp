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
                /* Scrollbar Track */
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
                            <a class="flex items-center text-gray-100 hover:text-blue-400 focus:outline-none active:text-blue-400">
                                Menu
                            </a>
                        </div>

                        <!-- Réservation -->
                        <div class="relative">
                            <a href="../reservation/reservation.jsp" class="flex items-center text-gray-100 hover:text-blue-400 focus:outline-none">
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

        <main class="pt-16">
            <section class="relative bg-cover bg-center bg-no-repeat" style="background-image: url('../images/pasta.jpg');">
                <div class="flex space-x-4 justify-center bg-black bg-opacity-60 w-full h-full py-10 px-4">
                  <div class="max-w-2xl w-1/2 h-96 bg-white bg-opacity-10 backdrop-blur-md text-white rounded-xl shadow-lg p-8 overflow-y-auto">
                    <div class="space-y-4">
                        <h2 class="text-white text-2xl">Nos Plats</h2>
                        
                        <%
                            try{
                                Connection conn = connectionDB.getConnection();
                                if(conn != null){
                                    String sql = "SELECT * FROM \"MENU\"";
                                    PreparedStatement ps = conn.prepareStatement(sql);
                                    ResultSet rs = ps.executeQuery();

                        %>
                       
                      <%
                        while(rs.next()){
                      %>  
                      
                      <div class="flex justify-between border-b border-white/20 pb-2">
                        <span><%=rs.getString("nomplat")%></span>
                        <span>Ar <%=rs.getInt("pu")%><button onclick="addToOrder('<%= rs.getString("idplat")%>', '<%= rs.getString("nomplat").trim().replaceAll("\\s+", " ").replace("'", "\\'") %>', <%= rs.getInt("pu") %>)" class="bg-transparent border mx-2 px-2 rounded">commander</button></span>
                      </div>
                      <% } %>
                        
                        
                    </div>
                      <%
                            } else {
                                out.println("Connexion echouee");
                            }
                        } catch (Exception e) {
                            out.println(e.getMessage());
                        }
                        %>
                  </div>
                </div>
            </section>
            
            <section>
                <div class="mx-auto w-2/3">
                    <form id="commande-form" method="POST" action="validerCommande.jsp">
                    <h1 class="text-2xl font-bold text-gray-100 m-4 text-center">Vos commandes</h1>
                    <div class="text-white w-1/2 mx-auto mb-6">
                        <p><strong>N° Commande :</strong><input type="text" name="idcom" class="px-4 bg-transparent border-b text-gray-100 focus:outline-none focus:border-none focus:ring-0" placeholder="id du commande" required></p>
                        <p><strong>Client :</strong><input type="text" name="nomcli" class="px-4 bg-transparent border-b text-gray-100 focus:outline-none focus:border-none focus:ring-0" placeholder="votre nom" required></p>
                        <p class="mt-4"><strong>Date :</strong><input type="date" id="dateDay" name="datecom" class="px-4 bg-transparent text-gray-100"></p>
                        <p class="mt-4"><input type="checkbox" id="ptable" name="ptable" class="px-4 bg-transparent text-gray-100" readonly><span class="font-xs text-gray-400 px-2">prendre une table</span></p>
                        <p class="mt-4" id="ntable" style="display: none;"><strong>Table :</strong>
                                <%
                                    try{
                                        Connection conn = connectionDB.getConnection();
                                        if(conn != null){
                                            String sql = "SELECT * FROM \"TABLE\"";
                                            PreparedStatement ps = conn.prepareStatement(sql);
                                            ResultSet rs = ps.executeQuery();

                                %>    
                                    <select id="idtable" name="idtable" class="px-4 py-1 rounded-lg border border-gray-300 bg-transparent transition duration-150 ease-in-out">
                                        <option class="text-gray-800" value="selected disable" selected disabled>Selectionner</option>
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
                        </p>
                    </div>
                    <table class="w-1/2 mx-auto border border-gray-300 rounded text-gray-100">
                        <thead>
                          <tr>
                            <th class="text-left p-2">Plat</th>
                            <th class="text-right p-2">Prix(Ar)</th>
                            <th class="text-right py-2 px-6">Unité</th>
                            <th class="text-right p-2">Total(Ar)</th>
                            <th class="text-right p-2"></th>
                          </tr>
                        </thead>
                        <tbody id="commande-body">
                          
                        </tbody>
                        <tfoot>
                            <tr class="font-semibold border-t border-gray-300">
                              <td class="p-2 text-right">Total(Ar)</td>
                              <td class="p-2 text-right" colspan="3" id="grand-total">0</td>
                            </tr>
                        </tfoot>
                    </table>
                    <div class="w-1/2 mx-auto">
                        <button type="submit" class="mt-4 bg-blue-100 hover:bg-blue-300 rounded px-4 py-2">Valider la commande</button>
                        <!--<p class="text-sm text-gray-500 my-4">Merci pour votre commande !</p>-->
                    </div>
                   </form>
                </div>
            </section>

        </main>
    </div>

    <script>
        // Additional initialization if needed
        document.addEventListener('alpine:init', () => {
            // Any additional Alpine.js initialization can go here
        });
        
        const day = new Date().toISOString().split('T')[0];
        document.getElementById('dateDay').value = day;
        
          document.getElementById('ptable').addEventListener('change', function () {
            const select = document.getElementById('ntable');
            select.style.display = this.checked ? 'inline-block' : 'none';
          });
        
        function escapeHTML(str) {
            return str.replace(/[&<>"']/g, function (m) {
                return {
                    '&': '&amp;',
                    '<': '&lt;',
                    '>': '&gt;',
                    '"': '&quot;',
                    "'": '&#039;'
                }[m];
            });
        }

        
        function addToOrder(idplat, nom, pu) {
            const tbody = document.getElementById("commande-body");

            const tr = document.createElement("tr");

            const tdNom = document.createElement("td");
            tdNom.className = "p-2 text-white";
            tdNom.textContent = nom;
            const inputNom = document.createElement("input");
            inputNom.type = "hidden";
            inputNom.name = "plats[]";
            inputNom.value = idplat;
            tdNom.appendChild(inputNom);

            const tdPU = document.createElement("td");
            tdPU.className = "p-2 text-right text-white";
            tdPU.textContent = pu;
            const inputPU = document.createElement("input");
            inputPU.type = "hidden";
            inputPU.name = "prixs[]";
            inputPU.value = pu;
            tdPU.appendChild(inputPU);

            const tdUnite = document.createElement("td");
            tdUnite.className = "text-right";
            const input = document.createElement("input");
            input.type = "number";
            input.name = "unites[]";
            input.value = "1";
            input.min = "1";
            input.className = "bg-transparent text-white w-1/3";
            input.onchange = function () {
                updateTotal(this);
            };
            tdUnite.appendChild(input);

            const tdTotal = document.createElement("td");
            tdTotal.className = "p-2 text-right total-col text-white";
            tdTotal.textContent = pu;

            const tdDelete = document.createElement("td");
            tdDelete.className = "p-2 text-right text-red-500 font-bold cursor-pointer";
            tdDelete.textContent = "x";
            tdDelete.onclick = function () {
                tr.remove();
                updateGrandTotal();
            };

            tr.appendChild(tdNom);
            tr.appendChild(tdPU);
            tr.appendChild(tdUnite);
            tr.appendChild(tdTotal);
            tr.appendChild(tdDelete);

            tbody.appendChild(tr);
            updateGrandTotal();
        }


        function updateTotal(input) {
            const tr = input.closest("tr");
            const pu = parseInt(tr.children[1].innerText);
            const quantity = parseInt(input.value) || 0;
            const total = pu * quantity;
            tr.querySelector(".total-col").innerText = total;
            updateGrandTotal();
            console.log(total);
        }

        function updateGrandTotal() {
            const totalCells = document.querySelectorAll(".total-col");
            let total = 0;
            totalCells.forEach(cell => {
                total += parseInt(cell.innerText) || 0;
            });
            
            document.getElementById("grand-total").innerText = total;
        }
        
        window.addEventListener('DOMContentLoaded', () => {
            const params = new URLSearchParams(window.location.search);
            if (params.get('reset') === 'true') {
                document.getElementById('tableForm').reset();
                window.history.replaceState({}, document.title, window.location.pathname);
            }
        });
    </script>
</body>
</html>
