import java.io.BufferedReader;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.PrintWriter;
import java.util.ArrayList;

public class determineQStrengths {
	public static void main(String[] args) {
		try {
			ArrayList<Double> strengthList = new ArrayList<Double>();
			
			BufferedReader br = new BufferedReader(new FileReader(args[0]));
			PrintWriter pw = new PrintWriter(new FileWriter(args[1]));
			
			String[] splitLine;
			double maxStrength = Integer.MIN_VALUE;
			double strength;
			String line;

			while ((line = br.readLine()) != null) {
				// System.out.println(line);
				if (line.contains("KQUAD")) {
					line = br.readLine();

					splitLine = line.split(" ");
					strength = Double.parseDouble(splitLine[2].substring(3, splitLine[2].length() - 1));

					strengthList.add(strength);
					
//					System.out.println("Strength: "+strength+" MaxStrength: "+maxStrength);
					if (Math.abs(strength) > maxStrength) {
						maxStrength = strength;
					}
				}
			}
			br.close();

			maxStrength *= 0.01;
			for (int i = 0; i < strengthList.size(); i++) {
				strength = strengthList.get(i)+maxStrength;
				pw.println(strength);
			}
			pw.close();
		} catch (Exception e) {
			e.printStackTrace();
		}

	}
}
