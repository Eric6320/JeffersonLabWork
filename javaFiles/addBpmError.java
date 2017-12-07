
public class addBpmError {
	public static void main(String[] args) {
		int numberOfFiles = Integer.parseInt(args[0]);
		String fileName = args[1];
		String extension = args[2];
		String fullFileName;
		
		for (int i = 0; i < numberOfFiles; i++) {
			fullFileName = fileName+i+extension;
		}
	}
}
