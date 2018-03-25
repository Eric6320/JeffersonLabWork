import java.io.BufferedReader;
import java.io.InputStreamReader;

public class optimizeQuad {

	public static String quad;
	public static String bpm;
	public static String designBeamline;
	public static String modifiedBeamline;
	public static String verticle;
	public static String functionName;
	public static int counter = 0;
	public static int limit;

	public static double lowestCHI2DOF = Integer.MAX_VALUE;
	public static double bestStrength;

	public static double function(double strength) {

		double chi2dof = -5;
		try {
			counter++;
			System.out.println("Beginning Trial: " + counter + ", strength = " + strength);
			ProcessBuilder pb = new ProcessBuilder(functionName, quad,
					Double.toString(strength), bpm, designBeamline, modifiedBeamline, verticle);
			Process p = pb.start();

			BufferedReader stdInput = new BufferedReader(new InputStreamReader(p.getInputStream()));
			String line;
			while ((line = stdInput.readLine()) != null) {
				System.out.println(line);
				if (line.startsWith("CHI2DOF =")) {
					chi2dof = Double.parseDouble((line.split(" ")[2]));
				}
			}
			p.destroy();
		} catch (Exception e) {
			System.out.println("Something went wrong");
			e.printStackTrace();
			System.exit(-1);
		}
		if (chi2dof < lowestCHI2DOF) {
			lowestCHI2DOF = chi2dof;
			bestStrength = strength;
		}
		return chi2dof;
	}

	public static double minimize(double a, double b, double c, double m, double machep, double e, double t) {

		double a0, a2, a3, d0, d1, d2, h, m2, p, q, qs, r, s, sc, y, y0, y1, y2, y3, yb, z0, z1, z2;
		int k;

		a0 = b;
		a2 = a;
		y0 = function(b);
		yb = y0;
		y2 = function(a);
		y = y2;

		if (y0 < y) {
			y = y0;
		}

		if (m <= 0.0 || b <= a) {
			return y;
		}

		m2 = 0.5 * (1.0 + 16.0 * machep) * m;
		if (c <= a || b <= c) {
			sc = 0.5 * (a + b);
		} else {
			sc = c;
		}

		y1 = function(sc);
		k = 3;
		d0 = a2 - sc;
		h = 9.0 / 11.0;

		if (y1 < y) {
			y = y1;
		}

		for (;;) {

			if (counter >= limit) {
				return bestStrength;
			}

			d1 = a2 - a0;
			d2 = sc - a0;
			z2 = b - a2;
			z0 = y2 - y1;
			z1 = y2 - y0;
			r = d1 * d1 * z0 - d0 * d0 * z1;
			p = r;
			qs = 2.0 * (d0 * z1 - d1 * z0);
			q = qs;

			if (k < 1000000 || y2 <= y) {
				for (;;) {

					if (counter >= limit) {
						return bestStrength;
					}

					if (q * (r * (yb - y2) + z2 * q * ((y2 - y) + t)) < z2 * m2 * r * (z2 * q - r)) {
						a3 = a2 + r / q;
						y3 = function(a3);

						if (y3 < y) {
							y = y3;
						}
					}
					k = ((1611 * k) % 1048576);
					q = 1.0;
					r = (b - a) * 0.00001 * (double) (k);

					if (z2 <= r) {
						break;
					}
				}
			} else {
				k = ((1611 * k) % 1048576);
				q = 1.0;
				r = (b - a) * 0.00001 * (double) (k);

				while (r < z2) {

					if (counter >= limit) {
						return bestStrength;
					}

					if (q * (r * (yb - y2) + z2 * q * ((y2 - y) + t)) < z2 * m2 * r * (z2 * q - r)) {
						a3 = a2 + r / q;
						y3 = function(a3);

						if (y3 < y) {
							y = y3;
						}
					}
					k = ((1611 * k) % 1048576);
					q = 1.0;
					r = (b - a) * 0.00001 * (double) (k);
				}
			}

			r = m2 * d0 * d1 * d2;
			s = Math.sqrt(((y2 - y) + t) / m2);
			h = 0.5 * (1.0 + h);
			p = h * (p + 2.0 * r * s);
			q = q + 0.5 * qs;
			r = -0.5 * (d0 + (z0 + 2.01 * e) / (d0 * m2));

			if (r < s || d0 < 0.0) {
				r = a2 + s;
			} else {
				r = a2 + r;
			}

			if (0.0 < p * q) {
				a3 = a2 + p / q;
			} else {
				a3 = r;
			}

			for (;;) {

				if (counter >= limit) {
					return bestStrength;
				}

				a3 = Math.max(a3, r);

				if (b <= a3) {
					a3 = b;
					y3 = yb;
				} else {
					y3 = function(a3);
				}

				if (y3 < y) {
					y = y3;
				}

				d0 = a3 - a2;

				if (a3 <= r) {
					break;
				}

				p = 2.0 * (y2 - y3) / (m * d0);

				if ((1.0 + 9.0 * machep) * d0 <= Math.abs(function(p))) {
					break;
				}

				if (0.5 * m2 * (d0 * d0 + p * p) <= (y2 - y) + (y3 - y) + 2.0 * t) {
					break;
				}
				a3 = 0.5 * (a2 + a3);
				h = 0.9 * h;
			}

			if (b <= a3) {
				break;
			}

			a0 = sc;
			sc = a2;
			a2 = a3;
			y0 = y1;
			y1 = y2;
			y2 = y3;
		}

		return y;
	}

	/**
	 *
	 * <p>
	 * This method performs a 1-dimensional minimization. It implements Brent's
	 * method which combines a golden-section search and parabolic
	 * interpolation. The introductory comments from the FORTRAN version are
	 * provided below.
	 *
	 * This method is a translation from FORTRAN to Java of the Netlib function
	 * fmin. In the Netlib listing no author is given.
	 *
	 * Translated by Steve Verrill, March 24, 1998.
	 *
	 * @param a
	 *            Left endpoint of initial interval
	 * @param b
	 *            Right endpoint of initial interval
	 * @param minclass
	 *            A class that defines a method, f_to_minimize, to minimize. The
	 *            class must implement the Fmin_methods interface (see the
	 *            definition in Fmin_methods.java). See FminTest.java for an
	 *            example of such a class. f_to_minimize must have one double
	 *            valued argument.
	 * @param tol
	 *            Desired length of the interval in which the minimum will be
	 *            determined to lie (This should be greater than, roughly,
	 *            3.0e-8.)
	 *
	 */

	public static double fmin(double a, double b, double tol) {

		/*
		 * 
		 * Here is a copy of the Netlib documentation:
		 * 
		 * c c An approximation x to the point where f attains a minimum on c
		 * the interval (ax,bx) is determined. c c input.. c c ax left endpoint
		 * of initial interval c bx right endpoint of initial interval c f
		 * function subprogram which evaluates f(x) for any x c in the interval
		 * (ax,bx) c tol desired length of the interval of uncertainty of the
		 * final c result (.ge.0.) c c output.. c c fmin abcissa approximating
		 * the point where f attains a c minimum c c The method used is a
		 * combination of golden section search and c successive parabolic
		 * interpolation. Convergence is never much slower c than that for a
		 * Fibonacci search. If f has a continuous second c derivative which is
		 * positive at the minimum (which is not at ax or c bx), then
		 * convergence is superlinear, and usually of the order of c about
		 * 1.324. c The function f is never evaluated at two points closer
		 * together c than eps*abs(fmin)+(tol/3), where eps is approximately the
		 * square c root of the relative machine precision. If f is a unimodal c
		 * function and the computed values of f are always unimodal when c
		 * separated by at least eps*abs(x)+(tol/3), then fmin approximates c
		 * the abcissa of the global minimum of f on the interval (ax,bx) with c
		 * an error less than 3*eps*abs(fmin)+tol. If f is not unimodal, c then
		 * fmin may approximate a local, but perhaps non-global, minimum to c
		 * the same accuracy. c This function subprogram is a slightly modified
		 * version of the c Algol 60 procedure localmin given in Richard Brent,
		 * Algorithms For c Minimization Without Derivatives, Prentice-Hall,
		 * Inc. (1973). c
		 * 
		 */

		double c, d, e, eps, xm, p, q, r, tol1, t2, u, v, w, fu, fv, fw, fx, x, tol3;

		c = .5 * (3.0 - Math.sqrt(5.0));
		d = 0.0;

		// 1.1102e-16 is machine precision

		eps = 1.2e-16;
		tol1 = eps + 1.0;
		eps = Math.sqrt(eps);

		v = a + c * (b - a);
		w = v;
		x = v;
		e = 0.0;
		fx = function(x);
		fv = fx;
		fw = fx;
		tol3 = tol / 3.0;

		xm = .5 * (a + b);
		tol1 = eps * Math.abs(x) + tol3;
		t2 = 2.0 * tol1;

		// main loop

		while (Math.abs(x - xm) > (t2 - .5 * (b - a))) {

			p = q = r = 0.0;

			if (Math.abs(e) > tol1) {

				// fit the parabola

				r = (x - w) * (fx - fv);
				q = (x - v) * (fx - fw);
				p = (x - v) * q - (x - w) * r;
				q = 2.0 * (q - r);

				if (q > 0.0) {

					p = -p;

				} else {

					q = -q;

				}

				r = e;
				e = d;

				// brace below corresponds to statement 50
			}

			if ((Math.abs(p) < Math.abs(.5 * q * r)) && (p > q * (a - x)) && (p < q * (b - x))) {

				// a parabolic interpolation step

				d = p / q;
				u = x + d;

				// f must not be evaluated too close to a or b

				if (((u - a) < t2) || ((b - u) < t2)) {

					d = tol1;
					if (x >= xm)
						d = -d;

				}

				// brace below corresponds to statement 60
			} else {

				// a golden-section step

				if (x < xm) {

					e = b - x;

				} else {

					e = a - x;

				}

				d = c * e;

			}

			// f must not be evaluated too close to x

			if (Math.abs(d) >= tol1) {

				u = x + d;

			} else {

				if (d > 0.0) {

					u = x + tol1;

				} else {

					u = x - tol1;

				}

			}

			fu = function(u);

			// Update a, b, v, w, and x

			if (fx <= fu) {

				if (u < x) {

					a = u;

				} else {

					b = u;

				}

				// brace below corresponds to statement 140
			}

			if (fu <= fx) {

				if (u < x) {

					b = x;

				} else {

					a = x;

				}

				v = w;
				fv = fw;
				w = x;
				fw = fx;
				x = u;
				fx = fu;

				xm = .5 * (a + b);
				tol1 = eps * Math.abs(x) + tol3;
				t2 = 2.0 * tol1;

				// brace below corresponds to statement 170
			} else {

				if ((fu <= fw) || (w == x)) {

					v = w;
					fv = fw;
					w = u;
					fw = fu;

					xm = .5 * (a + b);
					tol1 = eps * Math.abs(x) + tol3;
					t2 = 2.0 * tol1;

				} else if ((fu > fv) && (v != x) && (v != w)) {

					xm = .5 * (a + b);
					tol1 = eps * Math.abs(x) + tol3;
					t2 = 2.0 * tol1;

				} else {

					v = u;
					fv = fu;

					xm = .5 * (a + b);
					tol1 = eps * Math.abs(x) + tol3;
					t2 = 2.0 * tol1;

				}

			}

			// brace below corresponds to statement 190
		}

		return x;

	}

	public static void main(String[] args) {

		quad = args[0];
		bpm = args[1];
		designBeamline = args[2];
		modifiedBeamline = args[3];
		verticle = args[4];
		functionName = args[5];
		limit = 50;

//		double machep = Math.nextUp(1.0d) - 1;
//		// 1e5
//		System.out.println(minimize(-100, 100, 1, 12, machep, 100 * machep, 100 * machep));
		fmin(-100, 100, 0.001);
		function(bestStrength);
	}

}
