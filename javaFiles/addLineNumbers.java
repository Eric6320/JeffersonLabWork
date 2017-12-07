import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.PrintWriter;
import java.util.ArrayList;

public class addLineNumbers {
	public static void main(String[] args) {
		try {

			ArrayList<String> linesList = new ArrayList<String>();

			File readFile = new File(args[0]);
			File writeFile = new File(args[1]);
			String startingBPM = args[2];

			BufferedReader br = new BufferedReader(new FileReader(readFile));
			PrintWriter pw = new PrintWriter(new FileWriter(writeFile));

			String line;
			int counter = 0;
			boolean start = false;

			while ((line = br.readLine()) != null) {
				if (line.contains(startingBPM)) {
					start = true;
				}
				if (start) {
					if (line.contains("IPM")) {
						counter++;
						if (counter < 10) {
							line = counter + "  " + line;
						} else {
							line = counter + " " + line;
						}
					} else {
						line = "-- " + line;
					}
					System.out.println(line);
					linesList.add(line);
				}
			}

			br.close();
			pw.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
