import java.io.BufferedReader;
import java.io.InputStreamReader;

public class miscTests {

	public static int counter = 1;
	public static String bpm = "IPM1R10";
	public static String quad = "MQB1A29";
	public static String designBeamline = "unkicked";
	public static String modifiedBeamline = "modified";
	public static String verticle = "1";

	public static double function(double strength) {

		double chi2dof = -5;
		try {
			System.out.println("Beginning Trial: " + counter + ", strength = " + strength);
			ProcessBuilder pb = new ProcessBuilder("/a/devuser/erict/toddElegant/thesisWork/function.sh", quad,
					Double.toString(strength), bpm, designBeamline, modifiedBeamline, verticle);
			Process p = pb.start();
			System.out.println("The process has started");

			BufferedReader stdInput = new BufferedReader(new InputStreamReader(p.getInputStream()));
			String line;
			while ((line = stdInput.readLine()) != null) {
				System.out.println(line);
			}
			p.destroy();
		} catch (Exception e) {
			System.out.println("Something went wrong");
			e.printStackTrace();
			System.exit(-1);
		}
		return chi2dof;
	}

	public static void main(String[] args) {
		function(5);
	}
}
