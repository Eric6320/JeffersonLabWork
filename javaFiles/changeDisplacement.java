import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Random;

public class changeDisplacement {

	public static double withinThreeSigma(double sigma) {
		Random r = new Random();
		double number;
		
		while (Math.abs(number = r.nextGaussian()*sigma) > Math.abs(3*sigma)) {
		}
		
		return number;
	}

	public static void main(String[] args) {
		try {
			ArrayList<String> linesList = new ArrayList<String>();

			BufferedReader br;
			PrintWriter pw;

			File readFile = new File(args[0]);
			File writeFile = new File(args[1]);
			
			pw = new PrintWriter(new FileWriter(writeFile));
			br = new BufferedReader(new FileReader(readFile));
			double variance = Double.parseDouble(args[2]);
			String line = br.readLine();
			String dxLine;
			String dyLine;
			String firstHalfOfLine;
			String secondHalfOfLine;
			String gaussianNumber;

			while (line != null) {

				if (line.contains("KQUAD")) {
					dyLine = br.readLine();
					dxLine = br.readLine();

					firstHalfOfLine = dyLine.substring(0, dyLine.indexOf("DY=") + "DY=".length());
					gaussianNumber = Double.toString(withinThreeSigma(variance));
					secondHalfOfLine = dyLine.substring(dyLine.indexOf("DY=") + "DY=".length());

					dyLine = firstHalfOfLine + gaussianNumber + secondHalfOfLine;

					firstHalfOfLine = dxLine.substring(0, dxLine.indexOf("DX=") + "DX=".length());
					gaussianNumber = Double.toString(withinThreeSigma(variance));
					secondHalfOfLine = dxLine.substring(dxLine.indexOf("DX=") + "DX=".length());

					dxLine = firstHalfOfLine + gaussianNumber + secondHalfOfLine;
					
//					System.out.println(line);
//					System.out.println(dyLine);
//					System.out.println(dxLine);

					linesList.add(line);
					linesList.add(dyLine);
					linesList.add(dxLine);
				} else {
					linesList.add(line);
				}
				line = br.readLine();
			}
			
			for (String i : linesList) {
				pw.println(i);
			}

			br.close();
			pw.close();
		} catch (IOException e) {
			e.printStackTrace();
		}

	}
}
