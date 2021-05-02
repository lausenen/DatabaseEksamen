package dk.dtu.f21_02327;

import java.sql.*;

public class DataToDB {

    private Connector connector;


    public void run(VaccinationsAftale aftale) {

        //Lav nyt Connector objekt
        Connector connector = new Connector();
        this.connector = connector;


        try {

            //Opret ny connection
            Connection connection = connector.getConnection();
            PreparedStatement ps = getSelectCPRStatement();


            connection.setAutoCommit(false);

            String cpr;

            //Tilføj 0 til starten af CPR nummeret, hvis CPR nummeret starter med 0
            if (aftale.getCprnr() < 1000000000) {
                cpr = String.format("%010d", aftale.getCprnr());
            } else {
                cpr = String.valueOf(aftale.getCprnr());
            }

            ps.setString(1, cpr);

            ResultSet rs = ps.executeQuery();

            //Tjek om borgeren findes i databasen allerede
            if (!rs.isBeforeFirst()) {
                createBorger(aftale, cpr);
                createAftale(aftale, cpr);
            }

            rs.close();

            connection.commit();
            connection.setAutoCommit(true);

            ps.close();
            connection.close();

        } catch (SQLException e) {

            System.out.println("Fejl i ResultSet, connection, commit eller borger statement");
            e.printStackTrace();

        }

    }

    public void createBorger(VaccinationsAftale aftale, String CPR) {

        PreparedStatement ps = getInsertBorgerStatement();


        //Del fornavn, mellemnavn og efternavn op i hver sin del
        String[] fullName = aftale.getNavn().split(" ");


        try {
            ps.setString(1, CPR);
            ps.setString(2, fullName[0]);
            ps.setString(4, fullName[fullName.length - 1]);
            ps.setString(5, aftale.getVaccineType());

            //Tjek om borgeren har et mellemnavn
            if (fullName.length == 2) {
                ps.setNull(3, Types.VARCHAR);
            } else {
                ps.setString(3, fullName[1]);
            }

            ps.executeUpdate();
        } catch (SQLException e) {
            System.out.println("Fejl i borger");
            e.printStackTrace();
        } finally {
            try {
                ps.close();
            } catch (SQLException e) {
                System.out.println("Fejl ved lukning af Borger statement");
                e.printStackTrace();
            }
        }

    }

    public void createAftale(VaccinationsAftale aftale, String CPR) {

        PreparedStatement ps = getInsertAftalerStatement();
        try {

            //Konverter java dato til SqlTimeStamp
            Timestamp SqlTimeStamp = new java.sql.Timestamp(aftale.getAftaltTidspunkt().getTime());


            ps.setString(1, CPR);
            ps.setTimestamp(2, SqlTimeStamp);
            ps.setString(3, aftale.getLokation());

            ps.executeUpdate();

        } catch (SQLException e) {

            System.out.println("Fejl i aftale");
            e.printStackTrace();

        } finally {
            try {
                ps.close();
            } catch (SQLException e) {
                System.out.println("Fejl ved lukning af aftale statement");
                e.printStackTrace();
            }
        }


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

    private static final String SQL_SELECT_CPR = "SELECT Borger_ID FROM Borger where Borger_ID = ?";
    private PreparedStatement select_cpr_stmt = null;

    private PreparedStatement getSelectCPRStatement() {
        Connection connection = connector.getConnection();
        try {
            select_cpr_stmt = connection.prepareStatement(SQL_SELECT_CPR, ResultSet.TYPE_FORWARD_ONLY, ResultSet.CONCUR_UPDATABLE);
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

}
