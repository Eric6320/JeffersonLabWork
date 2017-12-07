import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.PrintWriter;

public class transformEllipse {

	public static double M1, M2, M3, M4;

	public static double findX(double x, double xPrime) {
		return (M1 * x + M2 * xPrime);
	}

	public static double findXPrime(double x, double xPrime) {
		return (M3 * x + M4 * xPrime);
	}

	public static void main(String[] args) {
		try {
			String bpmName = args[0];
			File readFileOne = new File(args[1]);
			File readFileTwo = new File(args[2]);
			File writeFile = new File(args[3]);

			BufferedReader br = new BufferedReader(new FileReader(readFileOne));
			PrintWriter pw = new PrintWriter(new FileWriter(writeFile));

			String[] splitLine;
			String line;
			outerloop:
			while ((line = br.readLine()) != null) {
				if (line.contains(bpmName)) {
					splitLine = line.split(" ");
					M1 = Double.parseDouble(splitLine[2]);
					M2 = Double.parseDouble(splitLine[3]);
					M3 = Double.parseDouble(splitLine[4]);
					M4 = Double.parseDouble(splitLine[5]);
					break outerloop;
				}
			}
			br.close();
			br = new BufferedReader(new FileReader(readFileTwo));
			
			Double x, xPrime;
			while ((line = br.readLine()) != null) {
				splitLine = line.split(" ");
				x = Double.parseDouble(splitLine[0]);
				xPrime = Double.parseDouble(splitLine[1]);
				pw.println(findX(x, xPrime)+" "+findXPrime(x, xPrime));
			}
			br.close();
			pw.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
