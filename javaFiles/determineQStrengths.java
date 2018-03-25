import java.io.BufferedReader;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.PrintWriter;
import java.util.ArrayList;

/**
 * Reads an input lattice file, determines the largest absolute quadrupole strength, adds one percent of that value to all other quadrupole strengths,
 * and prints those values alongside the quadrupole name to file 
 * @author erict
 */
public class determineQStrengths {
	public static void main(String[] args) {
		try {
			// Define a list containing every quadrupole strength, to be populated later
			ArrayList<Double> strengthList = new ArrayList<Double>();
			ArrayList<String> quadList = new ArrayList<String>();
			
			// Set the design lattice file (First command line argument) as the file to be read
			BufferedReader br = new BufferedReader(new FileReader(args[0]));
			// Set quadStrengths.dat (Second command line argument) as the output file to be written to
			PrintWriter pw = new PrintWriter(new FileWriter(args[1]));
			
			// Define miscellanious variables
			String[] nameSplitLine;
			String[] quadSplitLine;
			double maxStrength = Integer.MIN_VALUE;
			double strength;
			String name;
			String line;

			// Search through the entire file
			while ((line = br.readLine()) != null) {
				// Any lines that contain quadrupole strength information
				if (line.contains("KQUAD")) {

					// Parse the quadrupole name from the given line, and add it to quadList
					nameSplitLine = line.split(" ");
					name = nameSplitLine[0].substring(0, nameSplitLine[0].length()-1);
					quadList.add(name);

					// Proceed to the next line
					line = br.readLine();
					
					// Parse the strength from the following line
					quadSplitLine = line.split(" ");
					strength = Double.parseDouble(quadSplitLine[2].substring(3, quadSplitLine[2].length() - 1));

					// Add the strength to the global list of quadrupole strengths
					strengthList.add(strength);
					
					// If the found strength is larger than the current global largest, update maxStrength with the new found largest strength
					if (Math.abs(strength) > maxStrength) {
						maxStrength = strength;
					}
				}
			}
			// Close the Buffered Reader
			br.close();

			// Determine one percent of the largest absolute strength, 
			// add it to every found quadrupole strength,
			// then write the new strengths to the given output file
			maxStrength *= 0.01;
			System.out.println(maxStrength);
			for (int i = 0; i < strengthList.size(); i++) {
				name = quadList.get(i);
				strength = strengthList.get(i)+maxStrength;
				pw.println(name+" "+strength);
			}
			// Close the Print Writer
			pw.close();
		} catch (Exception e) {
			e.printStackTrace();
		}

	}
}
