import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Random;

public class modifyQuadStrength {

	public static Random r;
	public static boolean percentage;
	public static long seed;
	
	public static double withinThreeSigma(double sigma) {
		double number;

		while (Math.abs(number = r.nextGaussian() * sigma) > Math.abs(3 * sigma)) {
		}

		return number;
	}
	
	public static void setSeed(Long seedValue) {
		if (seed != 0) {
			r = new Random(seed);
		} else {
			r = new Random();
		}
	}
	
	public static void main(String[] args) {
		try {
			
			ArrayList<String> linesList = new ArrayList<String>();

			String quadName = args[0];
			double percentage = Double.parseDouble(args[1]);
			File readFile = new File(args[2]);
			File writeFile = new File(args[3]);
			seed = Long.parseLong(args[4]);
			setSeed(seed);

			BufferedReader br = new BufferedReader(new FileReader(readFile));
			PrintWriter pw = new PrintWriter(new FileWriter(writeFile));


			String[] splitLine;
			String line;
			double strength;
			double multiplier;
			boolean found = false;
			while ((line = br.readLine()) != null) {

				if (line.contains(quadName) && !found) {
					found = true;
					linesList.add(line);
					line = br.readLine();
					
					splitLine = line.split(" ");
					strength = Double.parseDouble(splitLine[2].substring(3, splitLine[2].length()-1));
					multiplier = withinThreeSigma(percentage);
					strength = strength*multiplier;
					System.out.println(strength);
					splitLine[2] = "K1="+strength+",";
					line = String.join(" ", splitLine);
				}
				
				
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
