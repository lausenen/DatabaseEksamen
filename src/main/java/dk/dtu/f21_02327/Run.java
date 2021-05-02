package dk.dtu.f21_02327;

import java.io.IOException;
import java.util.List;

public class Run {

    public static void main(String[] args) throws IOException {
        DataToDB DataToDB = new DataToDB();
        IndlaesVaccinationsAftaler laeser = new IndlaesVaccinationsAftaler();
        List<VaccinationsAftale> aftaler = laeser.indlaesAftaler("C:/Users/mikke/IdeaProjects/ManipulateUniversity/src/main/resources/vaccinationsaftaler.csv");



       for (VaccinationsAftale aftale : aftaler) {

            DataToDB.run(aftale);

        }


    }

}
