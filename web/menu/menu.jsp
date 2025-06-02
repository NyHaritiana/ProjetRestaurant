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
        
        #ntable {
            display: inline-block;
        }
        </style>
    </head>
    <body class="bg-gray-900 font-sans">
    <div class="relative min-h-screen">
        <header class="fixed top-0 left-0 right-0 bg-gray-800 transition-all duration-300 z-40 blur-bg shadow-lg">
            <div class="container mx-auto px-4 py-3">
                <div class="flex justify-between items-center">
                    <!-- Logo -->
                    <div class="flex">
                        <a href="#" class="text-2xl font-bold text-blue-600">
                            <img src="../images/gresto.png" alt="Logo" class="h-10">
                        </a>
                        <h1 class="text-3xl font-bold px-4 text-white">G_RESTO</h1>
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
                            <a class="flex items-center text-gray-100 hover:text-blue-400 focus:outline-none active:text-blue-400 cursor-pointer">
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
                <div class="flex space-x-4 justify-between bg-black bg-opacity-60 w-full h-screen py-10 px-4">
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
                  <div class="mx-auto w-2/3 max-h-96 overflow-y-auto">
                    <form id="commande-form" method="POST" action="validerCommande.jsp">
                    <h1 class="text-2xl font-bold text-gray-100 pb-2 text-center">Vos commandes</h1>
                    <div class="text-white w-1/2 mx-auto mb-6">
                        <p><strong>N° Commande :</strong><input type="text" name="idcom" class="px-4 bg-transparent border-b text-gray-100 focus:outline-none focus:border-none focus:ring-0" placeholder="id du commande" required></p>
                        <p><strong>Client :</strong><input value="<%= request.getParameter("nom") != null ? request.getParameter("nom") : "" %>" type="text" name="nomcli" class="px-4 bg-transparent border-b text-gray-100 focus:outline-none focus:border-none focus:ring-0" placeholder="votre nom" required></p>
                        <p class="mt-4"><strong>Date :</strong><input type="date" id="dateDay" name="datecom" class="px-4 bg-transparent text-gray-100"></p>
                        <p class="mt-4"><input type="checkbox" id="ptable" name="ptable" class="px-4 bg-transparent text-white" readonly><span class="font-xs text-gray-400 px-2">à emporter</span></p>
                        <p class="mt-4" id="ntable"><strong>Table :</strong>
                                <%
                                    try{
                                        Connection conn = connectionDB.getConnection();
                                        if(conn != null){
                                            String sql = "SELECT * FROM \"TABLE\" ORDER BY idtable ASC";
                                            PreparedStatement ps = conn.prepareStatement(sql);
                                            ResultSet rs = ps.executeQuery();

                                %>    
                                    <%
                                        String idFromUrl = request.getParameter("id"); // Récupère l’id passé dans le lien
                                    %>
                                    <select id="idtable" name="idtable" class="px-4 py-1 rounded-lg border border-gray-300 bg-transparent transition duration-150 ease-in-out">
                                        <option class="text-gray-800" value="" selected disabled>Selectionner</option>
                                        <%
                                            while(rs.next()){
                                                String tableId = rs.getString("idtable");
                                                boolean isSelected = tableId.equals(idFromUrl);
                                        %>
                                        <option class="text-gray-800" value="<%= tableId %>" <%= isSelected ? "selected" : "" %>><%= tableId %></option>
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
                        <% String idreserv = request.getParameter("idreserv"); %>
                        <input type="hidden" name="idreserv" class="text-gray-600" value="<%= idreserv != null ? idreserv : "" %>">
                    </div>
                    <table class="w-1/2 max-h-16 mx-auto border border-gray-300 rounded text-gray-100 overflow-y-auto">
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
                        <button type="submit" class="mt-4 bg-blue-100 hover:bg-blue-300 rounded px-4 py-2">Payer l'addition</button>
                        <!--<p class="text-sm text-gray-500 my-4">Merci pour votre commande !</p>-->
                    </div>
                   </form>
                </div>
                </div>
            </section>
        </main>
        <footer class="bg-gray-800 text-white py-12">
            <div class="container mx-auto px-4">
                <div class="grid grid-cols-1 md:grid-cols-4 gap-8">
                    <!-- Company Info -->
                    <div>
                        <img src="../images/gresto.png" alt="Logo" class="h-8 mb-4">
                        <p class="text-gray-400 mb-4">Creating beautiful spaces since 2010. Our award-winning design team is dedicated to bringing your vision to life.</p>
                        <div class="flex space-x-4">
                            <a href="#" class="text-gray-400 hover:text-white transition-colors">
                                <svg class="w-5 h-5" fill="currentColor" viewBox="0 0 24 24" aria-hidden="true">
                                    <path fill-rule="evenodd" d="M22 12c0-5.523-4.477-10-10-10S2 6.477 2 12c0 4.991 3.657 9.128 8.438 9.878v-6.987h-2.54V12h2.54V9.797c0-2.506 1.492-3.89 3.777-3.89 1.094 0 2.238.195 2.238.195v2.46h-1.26c-1.243 0-1.63.771-1.63 1.562V12h2.773l-.443 2.89h-2.33v6.988C18.343 21.128 22 16.991 22 12z" clip-rule="evenodd"></path>
                                </svg>
                            </a>
                            <a href="#" class="text-gray-400 hover:text-white transition-colors">
                                <svg class="w-5 h-5" fill="currentColor" viewBox="0 0 24 24" aria-hidden="true">
                                    <path d="M8.29 20.251c7.547 0 11.675-6.253 11.675-11.675 0-.178 0-.355-.012-.53A8.348 8.348 0 0022 5.92a8.19 8.19 0 01-2.357.646 4.118 4.118 0 001.804-2.27 8.224 8.224 0 01-2.605.996 4.107 4.107 0 00-6.993 3.743 11.65 11.65 0 01-8.457-4.287 4.106 4.106 0 001.27 5.477A4.072 4.072 0 012.8 9.713v.052a4.105 4.105 0 003.292 4.022 4.095 4.095 0 01-1.853.07 4.108 4.108 0 003.834 2.85A8.233 8.233 0 012 18.407a11.616 11.616 0 006.29 1.84"></path>
                                </svg>
                            </a>
                            <a href="#" class="text-gray-400 hover:text-white transition-colors">
                                <svg class="w-5 h-5" fill="currentColor" viewBox="0 0 24 24" aria-hidden="true">
                                    <path fill-rule="evenodd" d="M12.315 2c2.43 0 2.784.013 3.808.06 1.064.049 1.791.218 2.427.465a4.902 4.902 0 011.772 1.153 4.902 4.902 0 011.153 1.772c.247.636.416 1.363.465 2.427.048 1.067.06 1.407.06 4.123v.08c0 2.643-.012 2.987-.06 4.043-.049 1.064-.218 1.791-.465 2.427a4.902 4.902 0 01-1.153 1.772 4.902 4.902 0 01-1.772 1.153c-.636.247-1.363.416-2.427.465-1.067.048-1.407.06-4.123.06h-.08c-2.643 0-2.987-.012-4.043-.06-1.064-.049-1.791-.218-2.427-.465a4.902 4.902 0 01-1.772-1.153 4.902 4.902 0 01-1.153-1.772c-.247-.636-.416-1.363-.465-2.427-.047-1.024-.06-1.379-.06-3.808v-.63c0-2.43.013-2.784.06-3.808.049-1.064.218-1.791.465-2.427a4.902 4.902 0 011.153-1.772A4.902 4.902 0 015.45 2.525c.636-.247 1.363-.416 2.427-.465C8.901 2.013 9.256 2 11.685 2h.63zm-.081 1.802h-.468c-2.456 0-2.784.011-3.807.058-.975.045-1.504.207-1.857.344-.467.182-.8.398-1.15.748-.35.35-.566.683-.748 1.15-.137.353-.3.882-.344 1.857-.047 1.023-.058 1.351-.058 3.807v.468c0 2.456.011 2.784.058 3.807.045.975.207 1.504.344 1.857.182.466.399.8.748 1.15.35.35.683.566 1.15.748.353.137.882.3 1.857.344 1.054.048 1.37.058 4.041.058h.08c2.597 0 2.917-.01 3.96-.058.976-.045 1.505-.207 1.858-.344.466-.182.8-.398 1.15-.748.35-.35.566-.683.748-1.15.137-.353.3-.882.344-1.857.048-1.055.058-1.37.058-4.041v-.08c0-2.597-.01-2.917-.058-3.96-.045-.976-.207-1.505-.344-1.858a3.097 3.097 0 00-.748-1.15 3.098 3.098 0 00-1.15-.748c-.353-.137-.882-.3-1.857-.344-1.023-.047-1.351-.058-3.807-.058zM12 6.865a5.135 5.135 0 110 10.27 5.135 5.135 0 010-10.27zm0 1.802a3.333 3.333 0 100 6.666 3.333 3.333 0 000-6.666zm5.338-3.205a1.2 1.2 0 110 2.4 1.2 1.2 0 010-2.4z" clip-rule="evenodd"></path>
                                </svg>
                            </a>
                            <a href="#" class="text-gray-400 hover:text-white transition-colors">
                                <svg class="w-5 h-5" fill="currentColor" viewBox="0 0 24 24" aria-hidden="true">
                                    <path fill-rule="evenodd" d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10c5.51 0 10-4.48 10-10S17.51 2 12 2zm6.605 4.61a8.502 8.502 0 011.93 5.314c-.281-.054-3.101-.629-5.943-.271-.065-.141-.12-.293-.184-.445a25.416 25.416 0 00-.564-1.236c3.145-1.28 4.577-3.124 4.761-3.362zM12 3.475c2.17 0 4.154.813 5.662 2.148-.152.216-1.443 1.941-4.48 3.08-1.399-2.57-2.95-4.675-3.189-5A8.687 8.687 0 0112 3.475zm-3.633.803a53.896 53.896 0 013.167 4.935c-3.992 1.063-7.517 1.04-7.896 1.04a8.581 8.581 0 014.729-5.975zM3.453 12.01v-.26c.37.01 4.512.065 8.775-1.215.25.477.477.965.694 1.453-.109.033-.228.065-.336.098-4.404 1.42-6.747 5.303-6.942 5.629a8.522 8.522 0 01-2.19-5.705zM12 20.547a8.482 8.482 0 01-5.239-1.8c.152-.315 1.888-3.656 6.703-5.337.022-.01.033-.01.054-.022a35.318 35.318 0 011.823 6.475 8.4 8.4 0 01-3.341.684zm4.761-1.465c-.086-.52-.542-3.015-1.659-6.084 2.679-.423 5.022.271 5.314.369a8.468 8.468 0 01-3.655 5.715z" clip-rule="evenodd"></path>
                                </svg>
                            </a>
                        </div>
                    </div>
                    
                    <!-- Quick Links -->
                    <div>
                        <h3 class="text-lg font-semibold mb-4">Liens</h3>
                        <ul class="space-y-2">
                            <li><a href="#" class="text-gray-400 hover:text-white transition-colors">Acceuil</a></li>
                            <li><a href="#" class="text-gray-400 hover:text-white transition-colors">Menu</a></li>
                            <li><a href="#" class="text-gray-400 hover:text-white transition-colors">Services</a></li>
                            <li><a href="#" class="text-gray-400 hover:text-white transition-colors">Réservation</a></li>
                            <li><a href="#" class="text-gray-400 hover:text-white transition-colors">Contact</a></li>
                        </ul>
                    </div>
                    
                    <!-- Services -->
                    <div>
                        <h3 class="text-lg font-semibold mb-4">Services</h3>
                        <ul class="space-y-2">
                            <li><a href="#" class="text-gray-400 hover:text-white transition-colors">Livraison</a></li>
                            <li><a href="#" class="text-gray-400 hover:text-white transition-colors">Créations</a></li>
                            <li><a href="#" class="text-gray-400 hover:text-white transition-colors">Qualités</a></li>
                            <li><a href="#" class="text-gray-400 hover:text-white transition-colors">Evenementiels</a></li>
                        </ul>
                    </div>
                    
                    <!-- Contact Info -->
                    <div>
                        <h3 class="text-lg font-semibold mb-4">Contact</h3>
                        <ul class="space-y-2">
                            <li class="flex items-start">
                                <svg class="w-5 h-5 text-blue-500 mr-2 mt-0.5" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z"></path>
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 11a3 3 0 11-6 0 3 3 0 016 0z"></path>
                                </svg>
                                <span class="text-gray-400">Tanambao, FIANARANTSOA MADAGASCAR</span>
                            </li>
                            <li class="flex items-start">
                                <svg class="w-5 h-5 text-blue-500 mr-2 mt-0.5" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 5a2 2 0 012-2h3.28a1 1 0 01.948.684l1.498 4.493a1 1 0 01-.502 1.21l-2.257 1.13a11.042 11.042 0 005.516 5.516l1.13-2.257a1 1 0 011.21-.502l4.493 1.498a1 1 0 01.684.949V19a2 2 0 01-2 2h-1C9.716 21 3 14.284 3 6V5z"></path>
                                </svg>
                                <span class="text-gray-400">+261 (0) 34 61 716 42</span>
                            </li>
                            <li class="flex items-start">
                                <svg class="w-5 h-5 text-blue-500 mr-2 mt-0.5" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 8l7.89 5.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z"></path>
                                </svg>
                                <span class="text-gray-400">ainaramandimby@gmail.com</span>
                            </li>
                        </ul>
                    </div>
                </div>
                
                <div class="border-t border-gray-700 mt-10 pt-6 text-center text-gray-400">
                    <p>&copy; 2025 G-Restaurant. All rights reserved.</p>
                </div>
            </div>
        </footer>
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
            select.style.display = this.checked ? 'none' : 'inline-block';
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
