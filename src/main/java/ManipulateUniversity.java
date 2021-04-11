//STEP 1. Import required packages
import java.sql.*;
import java.sql.DriverManager;

public class ManipulateUniversity {
   // JDBC driver name and database URL
   static final String JDBC_DRIVER = "com.mysql.cj.jdbc.Driver";  
   static final String DB_URL = "jdbc:mysql://localhost/universitydb";

   //  Database credentials
   static final String USER = "root";
   static final String PASS = "Giants33";
   
   public static void main(String[] args) {
   Connection conn = null;
   Statement stmt = null;
   try{
      //STEP 2: Register JDBC driver
      Class.forName("com.mysql.cj.jdbc.Driver");

      //STEP 3: Open a connection
      System.out.println("Connecting to a selected database...");
      conn = DriverManager.getConnection(DB_URL, USER, PASS);
      System.out.println("Connected database successfully...");
      
      //STEP 4: Execute a query
      System.out.println("Creating statement...");
      stmt = conn.createStatement();

      String sql = "SELECT * FROM Student";
      ResultSet rs = stmt.executeQuery(sql);
      //STEP 5: Extract data from result set
      while(rs.next()){
         //Retrieve by column name
         int StudID  = rs.getInt("StudID");
         String StudName = rs.getString("StudName");
         String Birth = rs.getString("Birth");
         String DeptName = rs.getString("DeptName");
         int TotCredits = rs.getInt("TotCredits");

         //Display values
         System.out.print("ID: " + StudID);
         System.out.print(", Name: " + StudName);
         System.out.print(", Birth: " + Birth);
         System.out.println(", Dept: " + DeptName);
         System.out.println(", TotCredits: " + TotCredits);
      }
      rs.close();
   }catch(SQLException se){
      //Handle errors for JDBC
      se.printStackTrace();
   }catch(Exception e){
      //Handle errors for Class.forName
      e.printStackTrace();
   }finally{
      //finally block used to close resources
      try{
         if(stmt!=null)
            conn.close();
      }catch(SQLException se){
      }// do nothing
      try{
         if(conn!=null)
            conn.close();
      }catch(SQLException se){
         se.printStackTrace();
      }//end finally try
   }//end try
   System.out.println("Goodbye!");
}//end main
}//end JDBCExample