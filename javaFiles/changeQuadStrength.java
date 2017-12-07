import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Random;

public class changeQuadStrength {

	public static void main(String[] args) {
		try {
			
			ArrayList<String> linesList = new ArrayList<String>();

			String quadName = args[0];
			double newStrength = Double.parseDouble(args[1]);
			File readFile = new File(args[2]);
			File writeFile = new File(args[3]);

			BufferedReader br = new BufferedReader(new FileReader(readFile));
			PrintWriter pw = new PrintWriter(new FileWriter(writeFile));


			String[] splitLine;
			String line;
			boolean found = false;
			while ((line = br.readLine()) != null) {

				if (line.contains(quadName) && !found) {
					found = true;
//					System.out.println(line);
					linesList.add(line);
					line = br.readLine();
					
					splitLine = line.split(" ");
					splitLine[2] = "K1="+newStrength+",";
					line = String.join(" ", splitLine);
				}
//				System.out.println(line);
				linesList.add(line);
			}

			for (String i : linesList) {
				pw.println(i);
			}

			br.close();
			pw.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
