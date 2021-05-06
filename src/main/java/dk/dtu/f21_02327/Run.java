package dk.dtu.f21_02327;

import java.io.IOException;
import java.util.List;

public class Run {

    public static void main(String[] args) {

        DataToDB DataToDB = new DataToDB();

        IndlaesVaccinationsAftaler laeser = new IndlaesVaccinationsAftaler();

        String filePath ="C:/Users/mikke/IdeaProjects/ManipulateUniversity/src/main/resources/vaccinationsaftaler.csv";

        try {
            //Indlæs filen
            List<VaccinationsAftale> aftaler = laeser.indlaesAftaler(filePath);

            //Indlæs data til databasen
            DataToDB.loadData(aftaler);


        } catch (IOException e) {
            System.out.println("Filen findes ikke");
            e.printStackTrace();
        }
    }
}