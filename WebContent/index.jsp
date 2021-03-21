<%@ page contentType="text/html;charset=UTF-8" %>
<html lang="en">
<head>
    <meta charset="utf-8">
    <title>Book Store</title>
</head>
<body>
<h1 style="text-align: center; color: blue;">Book Store</h1>

<hr>
<br>

<form class="search-form" action="http://localhost:8080/BookStore" method="get">
    <input type="text" name="isbn" placeholder="ISBN">
    <input type="text" name="autor" placeholder="Autor">
    <input type="text" name="title" placeholder="Tytuł">
    <input type="text" name="publisher" placeholder="Wydawca">
    <input type="date" name="year" placeholder="Rok wydawnictwa">
    <input type="number" name="price_from" placeholder="Cena Od">
    <input type="number" name="price_to" placeholder="Cena Do">
    <input type="submit" name="submit-btn">
</form>
<br>

<%@page import="zad1.DbService" %>
<%@ page import="java.util.List" %>
<%
    DbService service = new DbService();
    List<List<String>> positions = service.getPositions(request.getParameterMap());
%>

<table style="width:100%;" id="myTable">
    <tr>
        <th><a onclick="sortTable(0)">ISBN</a></th>
        <th><a onclick="sortTable(1)">Autor</a></th>
        <th><a onclick="sortTable(2)">Tytuł</a></th>
        <th><a onclick="sortTable(3)">Wydawca</a></th>
        <th><a onclick="sortTable(4)">Rok wydawnictwa</a></th>
        <th><a onclick="sortTable(5)">Cena</a></th>
    </tr>

    <%for (List<String> position : positions) {%>
    <tr>
        <%for (int j = 0; j < position.size(); j++) {%>
        <td>
            <%=position.get(j)%>
        </td>
        <%}%>
    </tr>
    <%}%>
</table>

<style>
    table, th, td {
        border: 1px solid black;
        border-collapse: collapse;
        padding: 10px;
    }

    a {
        text-decoration: underline;
        cursor: pointer;
    }
</style>

<script>
    function sortTable(n) {
        var table, rows, switching, i, x, y, shouldSwitch, dir, switchcount = 0;
        table = document.getElementById("myTable");
        switching = true;
        dir = "asc";

        while (switching) {
            switching = false;
            rows = table.rows;
            for (i = 1; i < (rows.length - 1); i++) {
                shouldSwitch = false;
                x = rows[i].getElementsByTagName("TD")[n];
                y = rows[i + 1].getElementsByTagName("TD")[n];

                if (!isNaN(x.innerHTML)) {
                    if (dir === "asc") {
                        if (parseFloat(x.innerHTML.toLowerCase()) > parseFloat(y.innerHTML.toLowerCase())) {
                            shouldSwitch = true;
                            break;
                        }
                    } else if (dir === "desc") {
                        if (parseFloat(x.innerHTML.toLowerCase()) < parseFloat(y.innerHTML.toLowerCase())) {
                            shouldSwitch = true;
                            break;
                        }
                    }
                } else {
                    if (dir === "asc") {
                        if (x.innerHTML.toLowerCase() > y.innerHTML.toLowerCase()) {
                            shouldSwitch = true;
                            break;
                        }
                    } else if (dir === "desc") {
                        if (x.innerHTML.toLowerCase() < y.innerHTML.toLowerCase()) {
                            shouldSwitch = true;
                            break;
                        }
                    }
                }
            }
            if (shouldSwitch) {
                rows[i].parentNode.insertBefore(rows[i + 1], rows[i]);
                switching = true;
                switchcount++;
            } else {
                if (switchcount === 0 && dir === "asc") {
                    dir = "desc";
                    switching = true;
                }
            }
        }
    }
</script>

</body>
</html>