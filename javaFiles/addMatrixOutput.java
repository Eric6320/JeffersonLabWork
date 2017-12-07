import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;

public class addMatrixOutput {
	public static void main(String[] args) {
		try {
			ArrayList<String> linesList = new ArrayList<String>();
			File file = new File(args[0]);
			String bpmName = args[1];
			BufferedReader br = new BufferedReader(new FileReader(file)); 

			String line;
			while ((line = br.readLine()) != null) {
				linesList.add(line);
				if (line.contains("&twiss_output")) {
					while (!(line = br.readLine()).equals("&end")) {
						linesList.add(line);
					}
					linesList.add("&end");
					linesList.add("&matrix_output");
					linesList.add("	SDDS_output=\"%s.mat\",");
					linesList.add("	 SDDS_output_match=\"IPM*\",");
					linesList.add("	start_from=\""+bpmName+"\"");
					linesList.add("&end");
				}
			}
			br.close();
			file.delete();
			
			PrintWriter pw = new PrintWriter(new FileWriter(args[0]));
			
			for (String i : linesList) {
				pw.println(i);
			}
			pw.close();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
}
