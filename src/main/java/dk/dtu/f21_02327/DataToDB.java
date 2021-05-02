package dk.dtu.f21_02327;

import java.sql.*;

public class DataToDB {

    //private Connector connector;
    Connector connector = new Connector();


    public void run(VaccinationsAftale aftale) {
        Connection connection = connector.getConnection();
        PreparedStatement ps = getSelectCPRStatement();

        try {
            System.out.println(connection.isClosed());

            connection.setAutoCommit(false);

            String cpr;

            //Add leading zero, incase CPR starts with a 0
            if (aftale.getCprnr() < 1000000000) {
                cpr = String.format("%010d", aftale.getCprnr());
            } else {
                cpr = String.valueOf(aftale.getCprnr());
            }

            ps.setString(1, cpr);

            ResultSet rs = ps.executeQuery();

            //CallableStatement proc = connector.getConnection().prepareCall("call dbo.mysproc()");

            //Check if Borger is already registered in the database
            if (!rs.isBeforeFirst()) {
                createBorger(aftale, cpr);
                createAftale(aftale, cpr);
            } else
                //  updateAftale(aftale);*/


                rs.close();
            connection.commit();
            connection.setAutoCommit(true);
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                ps.close();
                connection.close();
            } catch (SQLException throwables) {
                throwables.printStackTrace();
            }
        }
    }

    public void createBorger(VaccinationsAftale aftale, String CPR) {

        PreparedStatement ps = getInsertBorgerStatement();


        //Split full name into individual parts
        String[] fullName = aftale.getNavn().split(" ");


        try {
            ps.setString(1, CPR);
            ps.setString(5, aftale.getVaccineType());
            ps.setString(2, fullName[0]);
            ps.setString(4, fullName[fullName.length - 1]);


            if (fullName.length == 2) {
                ps.setNull(3, Types.VARCHAR);

            } else {
                ps.setString(3, fullName[1]);
            }

            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                ps.close();
            } catch (SQLException throwables) {
                throwables.printStackTrace();
            }
        }

    }

    public void createAftale(VaccinationsAftale aftale, String CPR) {

        PreparedStatement ps = getInsertAftalerStatement();


        try {


            java.util.Date date = aftale.getAftaltTidspunkt();
            java.sql.Time SqlTime = new java.sql.Time(date.getTime());
            java.sql.Date SqlDate = new java.sql.Date(date.getTime());


            ps.setString(1, CPR);
            ps.setDate(2, SqlDate);
            ps.setTime(3, SqlTime);
            ps.setString(4, aftale.getLokation());


            ps.executeUpdate();

        } catch (SQLException throwables) {

            throwables.printStackTrace();

        } finally {
            try {
                ps.close();
            } catch (SQLException throwables) {
                throwables.printStackTrace();
            }
        }


    }

  /*  public void updateAftale(VaccinationsAftale aftale) throws SQLException {

        java.util.Date date = aftale.getAftaltTidspunkt();
        java.sql.Date SqlDate = new java.sql.Date(date.getTime());

        Connection connection = connector.getConnection();
        PreparedStatement ps = getSelectAftaleStatement();

        ps.setLong(1, aftale.getCprnr());

        ResultSet rs = ps.executeQuery();
        while (rs.next()) {

            rs.updateDate("tidspunkt2", SqlDate);
            rs.updateRow();

        }


    }
*/

    private static final String SQL_INSERT_BORGER = "INSERT INTO Borger(Borger_ID, Fornavn, Mellemnavn, Efternavn, Vaccine_Type) VALUES (?,?,?,?,?)";
    private PreparedStatement insert_borger_stmt = null;

    private PreparedStatement getInsertBorgerStatement() {
        // if (insert_borger_stmt == null) {
        Connection connection = connector.getConnection();
        try {
            insert_borger_stmt = connection.prepareStatement(SQL_INSERT_BORGER);
        } catch (SQLException throwables) {
            throwables.printStackTrace();
        }

        //}
        return insert_borger_stmt;
    }

    private static final String SQL_SELECT_CPR = "SELECT Borger_ID FROM Borger where Borger_ID = ?";
    private PreparedStatement select_cpr_stmt = null;

    private PreparedStatement getSelectCPRStatement() {
        //if (select_cpr_stmt == null) {
        Connection connection = connector.getConnection();
        try {
            select_cpr_stmt = connection.prepareStatement(SQL_SELECT_CPR, ResultSet.TYPE_FORWARD_ONLY, ResultSet.CONCUR_UPDATABLE);
        } catch (SQLException throwables) {
            throwables.printStackTrace();
        }

        // }
        return select_cpr_stmt;

    }

    private static final String SQL_INSERT_AFTALER = "INSERT INTO Aftale(Borger_ID, Dato, Tidspunkt, Bynavn) VALUES (?,?,?,?)";
    private PreparedStatement insert_aftaler_stmt = null;

    private PreparedStatement getInsertAftalerStatement() {
        /*   if (insert_aftaler_stmt == null) {*/
        Connection connection = connector.getConnection();
        try {
            insert_aftaler_stmt = connection.prepareStatement(SQL_INSERT_AFTALER);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        /* }*/
        return insert_aftaler_stmt;
    }


    private static final String SQL_UPDATE_AFTALER = "SELECT * FROM aftale WHERE Borger_ID = ?";
    private PreparedStatement select_aftaler_stmt = null;

    private PreparedStatement getSelectAftaleStatement() {
        //if (select_aftaler_stmt == null) {
        Connection connection = connector.getConnection();
        try {
            select_aftaler_stmt = connection.prepareStatement(SQL_UPDATE_AFTALER, ResultSet.TYPE_FORWARD_ONLY, ResultSet.CONCUR_UPDATABLE);
        } catch (SQLException e) {
            e.printStackTrace();
        }

        // }
        return select_aftaler_stmt;
    }


}
