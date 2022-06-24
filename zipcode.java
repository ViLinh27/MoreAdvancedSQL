import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.io.File;
import java.io.FileNotFoundException;
import java.sql.*;//gets driver into program
import java.util.Scanner;

public class zipcode {
    Connection conn;//helps make the connection
    String URL = "jdbc:oracle:thin:@acadoradbprd01.dpu.depaul.edu:1521:ACADPRD0";
    String csvFile = "ChIzipcode.csv";
    int batchSize = 20;
   
    public static void main(String[] args) throws java.sql.SQLException, FileNotFoundException,IOException
    {
       BufferedReader lineReader = new BufferedReader(new FileReader("ChIzipcode.csv"));//get the file in
        String lineText;
        String[] values;
       
         while((lineText = lineReader.readLine()) != null){
            //System.out.print(scanner.next()+" | ");//debug--is java reading the csv correctly?
           values = lineText.split(",");
           //System.out.println(lineText);
            // for(int i=0;i<values.length;i++){
            //     System.out.println(values[i]);
            // }//debug

           zipcode zip = new zipcode();//call the constructor to connect to db
            zip.doInsertTest(values, "INSERT INTO ZipCode (zip,city,state,latitude,longitude,timezone,dst) VALUES(");//the sql we want to stick into db
        }

        
        //zip.runTest();
    }

    public zipcode(){//constructor
        try{
            Class.forName("oracle.jdbc.driver.OracleDriver");
            String url = "jdbc:oracle:thin:@acadoradbprd01.dpu.depaul.edu:1521:ACADPRD0";//db we want to connect to
            this.URL = url;
            this.conn = DriverManager.getConnection(url, "vnguye54", "cdm1973940");
        
        }
        catch(ClassNotFoundException ex){
            System.err.println("Class not found " + ex.getMessage());
        }catch(SQLException ex){
            System.err.println(ex.getMessage());
        }
    }

    private void doInsertTest(String[] values, String sqlString){
        System.out.print("doInserTest testing \n");
        try{
            Statement st = conn.createStatement();
             //print out out sql string here
             System.out.println("sqlstring: "+sqlString+"\n");//debug

             //ResultSet rs=st.executeQuery(sqlString);//sends string to oracle
             //while (rs.next()) {
                 //String s=rs.getString(0);
                 //String n=rs.getString(1);
                 //System.out.println(s+" "+n);
                 //loop here to insert values--try a for loop
                 String upd = sqlString;
                 for(int i=0;i<values.length;i++){
                    //upd = sqlString+values[i];
                    upd+=values[i];
                    //System.out.println("upd debug: "+sqlString+values[i]+"\n");//debug
                    if(i<values.length-1)
                        upd+=",";
                    else
                        upd+=")";
                 }
                 //print the sql string here to debug and make sure things are working
                System.out.println(upd);
                st.executeUpdate(upd);//send to db--jdbc    
            //}
        }
        catch (SQLException ex)
        {
            System.err.println("Insert failure " + ex.getMessage());
        }
    }

    // public void runTest() throws java.sql.SQLException{ 
    //     System.out.println("-----runTest()-----");
    //     //conn = DriverManager.getConnection(URL, "vnguye54", "cdm1973940");
    //     doTests();
    //     //conn.close();
    // }

    // private void doTests(){
    //     System.out.println("-----doTests()-----");
    //     try{
    //         Statement st = conn.createStatement();
    //         String sql = "INSERT INTO ZipCode VALUES(?,?,?,?,?,?,?)";
    //         PreparedStatement prepst = conn.prepareStatement(sql);

    //         BufferedReader lineReader = new BufferedReader(new FileReader(csvFile));
    //         String lineText = null;

    //         int count=0;

    //         lineReader.readLine();//skip header line

    //         while((lineText = lineReader.readLine()) != null){
    //             String[] data = lineText.split(",");
    //             String zip = data[0];
    //             String city = data[1];
    //             String state = data[2];
    //             String lat  = data[3];
    //             String lon = data[4];
    //             String timezone = data[5];
    //             String dst = data[6];

    //             prepst.setInt(1, Integer.parseInt(zip));
    //             prepst.setString(2,city);
    //             prepst.setString(3, state);
    //             prepst.setFloat(4, Float.parseFloat(lat));
    //             prepst.setFloat(5, Float.parseFloat(lon));
    //             prepst.setInt(6, Integer.parseInt(timezone));
    //             prepst.setInt(7, Integer.parseInt(dst));

    //             if (count % batchSize == 0) {
    //                 prepst.executeBatch();
    //             }
    //         }
    //         lineReader.close();

    //         prepst.executeBatch();
    //         conn.commit();
    //         conn.close();

    //     }
    //     catch(SQLException ex){
    //         System.err.println("Insert failure " + ex.getMessage());
    //     } catch (IOException e) {
    //         e.printStackTrace();
    //     }
    // }
}
