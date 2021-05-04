package dk.dtu.f21_02327;


import java.sql.*;
import java.util.List;

public class DataToDB {


    private Connector connector;


    public void loadData(List<VaccinationsAftale> aftaler) {

        //Lav nyt Connector objekt
        Connector connector = new Connector();
        this.connector = connector;


        try {

            //Opret ny connection
            Connection connection = connector.getConnection();


            createAftaleBorger(aftaler);

            //Luk connection
            connection.close();

        } catch (SQLException e) {
            System.out.println("Fejl i connection");
            e.printStackTrace();
        }

    }

    public void createAftaleBorger(List<VaccinationsAftale> aftaler) throws SQLException {
        String cpr;

        PreparedStatement ps3 = getSelectAftalerStatement();
        PreparedStatement ps2 = getSelectCPRStatement();

        PreparedStatement ps = getInsertAftalerStatement();
        PreparedStatement ps1 = getInsertBorgerStatement();


        try {
            for (VaccinationsAftale aftale : aftaler
            ) {

                //Split navnet op i dets individuelle dele
                String[] fullName = aftale.getNavn().split(" ");


                //Tilføj 0 til starten af CPR nummeret, hvis CPR nummeret starter med 0
                if (aftale.getCprnr() < 1000000000) {
                    cpr = String.format("%010d", aftale.getCprnr());
                } else {
                    cpr = String.valueOf(aftale.getCprnr());
                }


                ps2.setString(1, cpr);
                ResultSet rs = ps2.executeQuery();
                //Tjek om borgeren allerede findes i databasen
                if (!rs.next()) {

                    ps1.setString(1, cpr);

                    ps1.setString(2, fullName[0]);
                    if (fullName.length == 2) {
                        ps1.setNull(3, Types.VARCHAR);
                    } else {
                        ps1.setString(3, fullName[1]);
                    }
                    ps1.setString(4, fullName[fullName.length - 1]);
                    ps1.setString(5, aftale.getVaccineType());
                    ps1.executeUpdate();
                }
                rs.close();


                ps3.setString(1, cpr);
                ResultSet rs1 = ps3.executeQuery();
                //Tjek om borgerens aftale allerede findes i databasen
                if (!rs1.next()) {

                    //Konverter datoen til SQL dato
                    Timestamp SqlTimeStamp = new java.sql.Timestamp(aftale.getAftaltTidspunkt().getTime());

                    ps.setString(1, cpr);
                    ps.setTimestamp(2, SqlTimeStamp);
                    ps.setString(3, aftale.getLokation());
                    ps.executeUpdate();

                }
                rs1.close();

            }
        } catch (SQLException e) {
            System.out.println("Fejl i statements");
            e.printStackTrace();
        }
        ps.close();
        ps1.close();
    }


    private static final String SQL_INSERT_BORGER = "INSERT INTO Borger(Borger_ID, Fornavn, Mellemnavn, Efternavn, Vaccine_Type) VALUES (?,?,?,?,?)";
    private PreparedStatement insert_borger_stmt = null;

    private PreparedStatement getInsertBorgerStatement() {
        Connection connection = connector.getConnection();
        try {
            insert_borger_stmt = connection.prepareStatement(SQL_INSERT_BORGER);
        } catch (SQLException throwables) {
            throwables.printStackTrace();
        }
        return insert_borger_stmt;
    }

    private static final String SQL_SELECT_CPR = "SELECT Borger_ID FROM Borger WHERE Borger_ID = ?";
    private PreparedStatement select_cpr_stmt = null;

    private PreparedStatement getSelectCPRStatement() {
        Connection connection = connector.getConnection();
        try {
            select_cpr_stmt = connection.prepareStatement(SQL_SELECT_CPR);
        } catch (SQLException throwables) {
            throwables.printStackTrace();
        }
        return select_cpr_stmt;
    }


    private static final String SQL_INSERT_AFTALER = "INSERT INTO Aftale(Borger_ID, Tidspunkt, Bynavn) VALUES (?,?,?)";
    private PreparedStatement insert_aftaler_stmt = null;

    private PreparedStatement getInsertAftalerStatement() {
        Connection connection = connector.getConnection();
        try {
            insert_aftaler_stmt = connection.prepareStatement(SQL_INSERT_AFTALER);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return insert_aftaler_stmt;
    }

    private static final String SQL_SELECT_AFTALER = "SELECT Borger_ID FROM Aftale WHERE Borger_ID = ?";
    private PreparedStatement select_aftaler_stmt = null;

    private PreparedStatement getSelectAftalerStatement() {
        Connection connection = connector.getConnection();
        try {
            select_aftaler_stmt = connection.prepareStatement(SQL_SELECT_AFTALER);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return select_aftaler_stmt;
    }
}
