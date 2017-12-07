import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Random;

public class modifyLTE {

	
	public static double withinThreeSigma(double sigma) {
		double number;
		if (seed != 0) {
			r = new Random(seed);
		}
		else {
			r = new Random();
		}

		while (Math.abs(number = r.nextGaussian() * sigma) > Math.abs(3 * sigma)) {
		}

		return number;
	}
	
	public static int nextBreak(int startingIndex, String str) {		
		for (int i = startingIndex; i < str.length(); i++) {
			if (str.charAt(i) == ' ' || str.charAt(i) == ',') {
				return i;
			}
		}
		return str.length();
	}

	public static Random r;
	public static boolean percentage;
	public static long seed;
	public static void main(String[] args) {
		try {
			
//			for (String i : args) {
//				System.out.print(i+" ");
//			}
//			System.out.println();
			
			ArrayList<String> linesList = new ArrayList<String>();

			BufferedReader br;
			PrintWriter pw;

			File readFile = new File(args[0]);
			File writeFile = new File(args[1]);
			String stringIdentifier = args[2];
			String stringToChange = args[3];
			

			pw = new PrintWriter(new FileWriter(writeFile));
			br = new BufferedReader(new FileReader(readFile));
			double variance = Double.parseDouble(args[4]);
			String line = br.readLine();
			
			if (args.length >= 6 && args[5].equals("1")) {
				percentage = true;
			}
			else {
				percentage = false;
			}
			if (args.length == 7) {
				seed = Long.parseLong(args[6]);
			}
			else {
				seed = 0;
			}

			String firstHalfOfLine;
			String secondHalfOfLine;
			Double gaussianNumber;

			while (line != null) {

				if (line.contains(stringIdentifier)) {
					int stringIndex = line.indexOf(stringToChange);
					firstHalfOfLine = line.substring(0, stringIndex+stringToChange.length());
					int firstIndex = firstHalfOfLine.length();
					int secondIndex = nextBreak(stringIndex, line);
					double previousNumber = Double.parseDouble(line.substring(firstIndex,secondIndex));
					
					if (percentage) {
						gaussianNumber = previousNumber+withinThreeSigma(previousNumber * variance);
					}
					else {
						gaussianNumber = previousNumber+withinThreeSigma(variance);						
					}
					
					if (stringToChange.contains("KICK")) {
						gaussianNumber = Math.abs(gaussianNumber);
					}
					secondHalfOfLine = line.substring(nextBreak(stringIndex, line));

					line = firstHalfOfLine + gaussianNumber + secondHalfOfLine;
				}
				linesList.add(line);
				line = br.readLine();
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
