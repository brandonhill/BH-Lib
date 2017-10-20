// bezier formulas from https://pomax.github.io/bezierinfo/





// if(degree < 1) throw new Error('degree must be at least 1 (linear)');
// if(degree > (n-1)) throw new Error('degree must be less than or equal to point count - 1');
// module b_spline(points, t, degree = 2) {
// 
// 	order = degree + 1;
// 	echo(str("Points = ", points, ", Degree = ", degree, ", Order = ", order));
// 
// 
// 	knots = [ for (i = [0 : len(points) + degree + 1]) i ];
// 	echo(str("Knots = ", knots));
// 
// 	domain = [degree, len(knots) - degree - 1];
// 	echo(str("Domain = ", domain));
// 
// 	t_clamped = t * (domain[1] - domain[0]) + domain[0];
// 	echo(str("t = ", t, ", clamped = ", t_clamped));
// 
// 	for (s = [domain[0] : domain[1] - 1]) {
// // 		if (knots[s] <= t_clamped && t_clamped <= knots[s + 1])
// 		if (knots[s] <= t_clamped && t_clamped <= knots[s + 1]) {
// 			echo(str("Found segment = ", s));
// 			// need to only operate first time in here...
// 			for (L = [1 : order])
// 				for(i = [s : -1 : s + L - order + 1])
// 					let (
// 						numerator = t - knots[i],
// 						denominator = knots[i - L + order] - knots[i],
// 						alpha = numerator / denominator
// 					)
// 					points[i]     *      alpha +
// 					points[i - 1] * (1 - alpha);
// 			echo(str("wtf = ", wtf));
// 		}
// 	}
// }
// 
// 
// function xb_spline(points, t, degree = 2) =
// 	let (
// 		knots = [
// 			for (i = [0 : len(points) + degree + 1]) i // ???
// 		],
// 		domain = [
// 			degree,
// 			len(knots) - degree - 1
// 		],
// 		t_clamped = t * (domain[1] - domain[0]) + domain[0]
// 	) [
// 	for (s = [domain[0] : domain[1] - 1])
// 		if (knots[s] <= t_clamped && t_clamped <= knots[s + 1])
// 			for (L = [1 : degree])
// 				for(i = [s : -1 : s + L - degree])
// 					let (
// 						numerator = t - knots[i],
// 						denominator = knots[i - L + degree] - knots[i],
// 						alpha = numerator / denominator
// 					)
// 					points[i]     *      alpha +
// 					points[i - 1] * (1 - alpha)
// 	];
// 
// spline = [
// 	[0, 0],
// 	[1, 1],
// 	[2, 0],
// 	[3, -1],
// 	[4, 0],
// ] * 2;
// 
// color("blue")
// for (i = [0 : len(spline) - 1])
// 	translate(spline[i])
// 	square(0.25);
// 
// // bspline = b_spline(spline, 0.5);
// // echo(str("BSpline", len(bspline), bspline));
// 
// b_spline(spline, 0.5);
// 
// // $fn = 16;
// // for (t = [0 : 1 / $fn : 1]) {
// // 	translate(bspline[i])
// // 	circle(0.25);
// // }
// 





function bezier2_point(weights, t) =
		weights[0] *     pow(1 - t, 2)            +
		weights[1] * 2 *    (1 - t)    *     t    +
		weights[2] *                     pow(t, 2);

// function bezier3(weights, t) =
// 		weights[0] *     pow(1 - t, 3)             +
// 		weights[1] * 3 * pow(1 - t, 2) *     t     +
// 		weights[2] * 3 *    (1 - t)    * pow(t, 2) +
// 		weights[3] *                     pow(t, 3);

// optimized:
function bezier3_point(weights, t) = let (
	mt = 1 - t,
	mt2 = mt * mt,
	mt3 = mt2 * mt,
	t2 = t * t,
	t3 = t2 * t)
		weights[0] *     mt3      +
		weights[1] * 3 * mt2 * t  +
		weights[2] * 3 * mt  * t2 +
		weights[3] *           t3;

function bezier2_points(points, steps = $fn) =
	[ for (i = [0 : steps - 1]) bezier2_point(points, 1 / steps * i) ];

function bezier3_points(points, steps = $fn) =
	[ for (i = [0 : steps]) bezier3_point(points, 1 / steps * i) ];


function valuesForIndex(a, i) = [for (j = [0 : len(a) - 1]) a[j][i]];

// expects three (cubic) or four (quadratic) points
module bezier(points, width = 0.5, connect = true, n = -1) {
	
	order = len(points) - 1;
	cubic = order == 2;
	r = width / 2;
	steps = max(n, order + 2);
	wx = valuesForIndex(points, 0);
	wy = valuesForIndex(points, 1);
	
	module pos(p) {
		translate(p)
		children();
	}
	
	module point() {
		circle(r);
	}

	for (i = [1 : steps]) {

		t0 = 1 / steps * (i - 1);
		p0 = [cubic ? bezier2_point(wx, t0) : bezier3_point(wx, t0),
			cubic ? bezier2_point(wy, t0) : bezier3_point(wy, t0)];

		t = 1 / steps * i;
		p = [cubic ? bezier2_point(wx, t) : bezier3_point(wx, t),
			cubic ? bezier2_point(wy, t) : bezier3_point(wy, t)];

		if (connect) {
			hull() {
				pos(p0)
				if ($children > 0) children();
				else point();

				pos(p)
				if ($children > 0) children();
				else point();
			}
		} else {
			pos(p0)
			if ($children > 0) children();
			else point();
			
			pos(p)
			if ($children > 0) children();
			else point();
		}
	}
}
