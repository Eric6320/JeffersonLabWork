import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Random;

public class strengthError {
	
	public static double withinThreeSigma(double sigma) {
		Random r = new Random();
		double number;
		
		while (Math.abs(number = r.nextGaussian()*sigma) > Math.abs(3*sigma)) {
		}
		
		return number;
	}

	public static void main(String[] args) {

		try {
			BufferedReader br;
			PrintWriter pw;
			pw = new PrintWriter(new FileWriter(args[1]));
			br = new BufferedReader(new FileReader(args[0]));
			String line = br.readLine();
			double strengthPercentage = 0.05;
			double strengthOne;
			double strengthOneError;
			double strengthTwo;
			double strengthTwoError;

			while (line != null) {
				String[] lineArray = line.split(" ");
				strengthOne = Double.parseDouble(lineArray[0]);
				strengthTwo = Double.parseDouble(lineArray[1]);
				
				strengthOneError = withinThreeSigma(strengthOne * strengthPercentage);
				strengthTwoError = withinThreeSigma(strengthTwo * strengthPercentage);

				pw.printf("%f %f\n", strengthOneError, strengthTwoError);
				line = br.readLine();
			}
			br.close();
			pw.close();
			
		} catch (IOException e) {
			e.printStackTrace();
		}

	}
}
