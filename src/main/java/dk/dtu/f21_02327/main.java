/*
package dk.dtu.f21_02327;

import javax.swing.plaf.synth.SynthEditorPaneUI;
import java.sql.*;
import java.util.Scanner;

public class main {

   // private Connector connector;

  */
/*  void main(Connector connector) {
        this.connector = connector;
    }*//*


    public void run(VaccinationsAftale aftale, Connection connection) {

       // Connection connection = connector.getConnection();
        try {
            System.out.println(connection.isClosed());


            connection.setAutoCommit(false);

            PreparedStatement ps = getSelectCPRStatement(connection);
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
                createBorger(aftale, cpr, connection);
                createAftale(aftale, cpr, connection);
            }*/
/*else
          //  updateAftale(aftale);*//*


            rs.close();
            connection.commit();
            connection.setAutoCommit(true);
            ps.close();
        } catch (SQLException e) {
            e.printStackTrace();
            try {
                connection.rollback();
                connection.setAutoCommit(true);
            } catch (SQLException e1) {
                e1.printStackTrace();
            }
        }


    }

    public void createBorger(VaccinationsAftale aftale, String CPR, Connection connection) throws SQLException {


        PreparedStatement ps = getInsertBorgerStatement(connection);


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
        }
        ps.close();
    }

    public void createAftale(VaccinationsAftale aftale, String CPR, Connection connection) {

        try {

            PreparedStatement ps = getInsertAftalerStatement(connection);


            java.util.Date date = aftale.getAftaltTidspunkt();
            java.sql.Time SqlTime = new java.sql.Time(date.getTime());
            java.sql.Date SqlDate = new java.sql.Date(date.getTime());


            ps.setString(1, CPR);
            ps.setDate(2, SqlDate);
            ps.setTime(3, SqlTime);
            ps.setString(4, aftale.getLokation());


            ps.executeUpdate();
            ps.close();
        } catch (SQLException throwables) {
            throwables.printStackTrace();
        }


    }

  */
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
*//*


    private static final String SQL_INSERT_BORGER = "INSERT INTO Borger(Borger_ID, Fornavn, Mellemnavn, Efternavn, Vaccine_Type) VALUES (?,?,?,?,?)";
    private PreparedStatement insert_borger_stmt = null;

    private PreparedStatement getInsertBorgerStatement(Connection connection) {
       // if (insert_borger_stmt == null) {
           // Connection connection = connector.getConnection();
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

    private PreparedStatement getSelectCPRStatement(Connection connection) {
       // if (select_cpr_stmt == null) {
            //Connection connection = connector.getConnection();
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

    private PreparedStatement getInsertAftalerStatement(Connection connection) {
      //  if (insert_aftaler_stmt == null) {
           // Connection connection = connector.getConnection();
            try {
                insert_aftaler_stmt = connection.prepareStatement(SQL_INSERT_AFTALER);
            } catch (SQLException e) {
                e.printStackTrace();
            }
       // }
        return insert_aftaler_stmt;
    }


    private static final String SQL_UPDATE_AFTALER = "SELECT * FROM aftale WHERE Borger_ID = ?";
    private PreparedStatement select_aftaler_stmt = null;

    private PreparedStatement getSelectAftaleStatement(Connection connection) {
        if (select_aftaler_stmt == null) {
            //Connection connection = connector.getConnection();
            try {
                select_aftaler_stmt = connection.prepareStatement(SQL_UPDATE_AFTALER, ResultSet.TYPE_FORWARD_ONLY, ResultSet.CONCUR_UPDATABLE);
            } catch (SQLException e) {
                e.printStackTrace();
            }

        }
        return select_aftaler_stmt;
    }

}
*/
