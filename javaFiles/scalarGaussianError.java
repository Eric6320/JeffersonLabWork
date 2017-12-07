import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Random;

public class scalarGaussianError {

	public static Random r;
	public static long seed;

	public static ArrayList<Double> withinThreeSigma(int sizeOfList, double sigma) {
		ArrayList<Double> tempList = new ArrayList<Double>();
		double number;

		for (int i = 0; i < sizeOfList; i++) {
			while (Math.abs(number = r.nextGaussian() * sigma) > Math.abs(3 * sigma)) {
			}
			tempList.add(number);
		}

		return tempList;
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
			ArrayList<Double> scalarGaussianList = new ArrayList<Double>();
			int numberOfFiles = Integer.parseInt(args[0]);
			int numberOfValues = Integer.parseInt(args[1]);
			double standardDeviation = Double.parseDouble(args[2]);
			String fileName = args[3];
			String extension = args[4];
			seed = Long.parseLong(args[5]);
			setSeed(seed);

			PrintWriter pw;

			for (int i = 0; i < numberOfFiles; i++) {
				pw = new PrintWriter(new FileWriter(fileName + (i + 1) + extension));
				scalarGaussianList = withinThreeSigma(numberOfValues, standardDeviation);

				for (Double j : scalarGaussianList) {
					pw.println(j);
				}
				pw.close();
			}

		} catch (IOException e) {
			e.printStackTrace();
		}

	}

}
