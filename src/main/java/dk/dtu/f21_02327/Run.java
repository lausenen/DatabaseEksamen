package dk.dtu.f21_02327;

import java.io.IOException;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;
import java.util.Scanner;

public class Run {

    public static void main(String[] args) {

        DataToDB DataToDB = new DataToDB();

        String filePath;
        DataToDBOld DataToDBOld = new DataToDBOld();
        IndlaesVaccinationsAftaler laeser = new IndlaesVaccinationsAftaler();
        Scanner scan = new Scanner(System.in);
        System.out.print("Indtast navnet på .csv filen: ");
        String FileName = scan.next();
        scan.close();
        Path path = Paths.get("", "src", "main", "resources", FileName + ".csv");
        filePath = String.valueOf(path.toAbsolutePath());

        try {
            List<VaccinationsAftale> aftaler = laeser.indlaesAftaler(filePath);

           DataToDB.run(aftaler);

          /*  for (VaccinationsAftale aftale : aftaler) {
                DataToDB.run(aftale);
            }

           */


        } catch (IOException e) {
            System.out.println("Filen findes ikke");
            e.printStackTrace();
        }
    }
}