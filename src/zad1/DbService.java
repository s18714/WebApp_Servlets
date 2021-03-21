package zad1;

import java.sql.*;
import java.util.*;
import java.util.Map.Entry;

public class DbService {
    public String driver = "org.apache.derby.jdbc.EmbeddedDriver";
    public String url = "jdbc:derby:DerbyDB";
    public Connection connection;
    public Statement statement;

    public DbService() {
        try {
            Properties p = System.getProperties();
            p.setProperty("derby.system.home", "/Users/denys_kryzhanivskyi/Desktop/2 Rok/4 Semestr/TPO/TPO6_KD_S18714/src/zad1");
            Class.forName(driver).newInstance();
            connection = DriverManager.getConnection(url);
            statement = connection.createStatement();
        } catch (InstantiationException | IllegalAccessException | ClassNotFoundException | SQLException e) {
            e.printStackTrace();
        }
    }

    public List<List<String>> getPositions(Map<String, String[]> parameters) {
        Iterator<Entry<String, String[]>> iterator = parameters.entrySet().iterator();

        StringBuilder whereStatement = new StringBuilder("WHERE");

        while (iterator.hasNext()) {
            Entry<String, String[]> entry = iterator.next();
            if (!entry.getKey().equals("submit-btn") && entry.getValue()[0].length() != 0) {
                switch (entry.getKey()) {
                    case "isbn":
                        whereStatement.append(" isbn = '").append(entry.getValue()[0]).append("'");
                        break;
                    case "autor":
                        whereStatement.append(" AUTOR.name LIKE '%").append(entry.getValue()[0]).append("%'");
                        break;
                    case "title":
                        whereStatement.append(" tytul LIKE '%").append(entry.getValue()[0]).append("%'");
                        break;
                    case "publisher":
                        whereStatement.append(" WYDAWCA.name LIKE '%").append(entry.getValue()[0]).append("%'");
                        break;
                    case "year":
                        whereStatement.append(" rok = ").append(entry.getValue()[0]);
                        break;
                    case "price_from":
                        whereStatement.append(" cena >= ").append(entry.getValue()[0]);
                        break;
                    case "price_to":
                        whereStatement.append(" cena <= ").append(entry.getValue()[0]);
                        break;
                }
                whereStatement.append(" AND");
            }
        }

        if (whereStatement.length() > 5)
            whereStatement = new StringBuilder(whereStatement.substring(0, whereStatement.length() - 4));
        else
            whereStatement = new StringBuilder();


        List<List<String>> positions = new ArrayList<>();
        try {
            ResultSet resultSet = statement.executeQuery(
                    "SELECT isbn, AUTOR.name, tytul, WYDAWCA.name, rok, cena FROM pozycje " +
                            "JOIN autor ON POZYCJE.autid = AUTOR.autid JOIN wydawca ON WYDAWCA.wydid = POZYCJE.wydid " +
                            whereStatement);

            while (resultSet.next()) {
                List<String> row = new ArrayList<>();

                for (int i = 1; i < 7; i++) {
                    row.add(resultSet.getString(i));
                }
                positions.add(row);
            }
            resultSet.close();
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return positions;
    }
}