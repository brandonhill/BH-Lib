# BH Lib

An OpenSCAD library of useful functions, modules and components.

![OpenSCAD library](https://github.com/brandonhill/BH-Lib/blob/master/sample.png)

### Notes

* All shapes and solids default to `center = true`, though component mocks are positioned to suit their typical use case (e.g. screws are aligned with head in positive and shank in negative y axis).

## Constants

* Millimeters per inch
* Pi
* Metric nuts/screw dimensions
* Component dimensions

## Helper functions/modules

* `circumference(r)` - circumference of a circle
* `clamp(value, v1, v2)` - clamps a value between two other values
* `contains(needle, haystack)` - checks if vector contains given value
* `error(msg)` - logs a vector of error message values to the console
* `for_unity3d(scale = 0.001)` - scales and orients models for use in Unity3D
* `get_fragments_from_r(r, fa = $fa, fn = $fn, fs = $fs)` - derives `$fn` from radius, as per docs
* `helix_angle(r, pitch)` - determines angle of a helix at given pitch and radius
* `index_of(needle, haystack)` - finds index of given value
* `join(values, sep = ", ")` - creates a string from vector elements
* `linear_extrude_chamfer(h, chamfer, round = false, center = false, convexity = 1, $fn = $fn)` - applies a `linear_extrude` and `minkowski` to a shape resulting in chamfered edge
* `linear_rotate_extrude(h = 1, a = 360, center = true, convexity = 1, $fn = 0)` - mimics `rotate_extrude` while applying a linear transform. **It's a hack!** - `hull`s two thin `linear_extrude`s, since we can't hull 2D shapes in 3D
* `lookup_vector(i, table)` - same as `lookup` but also works on vector values
* `offset_point(p, delta = 0)` - INVESTIGATE `delta * 2` - should be *1?
* `oscillate(min = -1, max = 1, t = $t)` - sweeps a value between given minimum and maximum, for animation
* `poly_coords(n, r = 1, mid = true)` - creates vector of points with faces at radius (rather than points)
* `print_registration_bounds(bounds = [180, 180], h = 0.2, t = 0.5)` - used to ensure position when slicing separate models on one plate (e.g. two material prints)
* `print(msg)` - logs a vector of message values to the console
* `reflect(x = true, y = true, z = false) ` - mirrors children across axes
* `rotate_point_x(p, a)` - rotates given point around x axis
* `rotate_point_y(p, a)` - rotates given point around y axis
* `rotate_point_z(p, a)` - rotates given point around z axis
* `rotate_point(p, a)` - rotates given point around all axes
* `rotate_points(p, a)` - rotates given points around all axes
* `show_half(r = [0, 0, 0], t = [0, 0, 0], d = 1000, 2d = false)` - cuts children in half for internals investigation or simple bisections
* `sum(v)` - sums numeric values of a vector
* `translate_point(p, a)` - translates given point
* `translate_points(p, a)` - translates given points
* `transpose(pos = [])` - positions children reflected without mirroring across all axes
* `warn(msg)` - logs a vector of warning message values to the console

## 2D

* `arc(a, r1, r2, $fn = $fn)` - like a rainbow
* `bezier(points, width = 0.5, connect = true, n = -1)` - draws a bezier curve from given three (cubic) or four (quadratic) points, of either given width or by hulling children, if any
* `circle_true(r, center = true, $fa = $fa, $fn = $fn, $fs = $fs)` - circle with edges at radius (rather than points)
* `grid(coords = [100, 100], x = 10, y = 10, walls = 1, edges = false, center = false)` - draws a grid of lines
* `l(dim = [10, 10], t = 1, t1, t2)` - "L" shape, for beams
* `rounded_gear(r = 10, n = 3, inset = true, s = [1, 1], $fn = $fn)` - a simple lobed gear (for knob handles)
* `rounded_square(dim, r, center = true)` - square with corners of given radius
* `segment(a, r, $fn = $fn)` - a portion of given angle of a circle
* `semicircle(r = 1, $fa = $fa, $fn = $fn, $fs = $fs)` - half a circle
* `semicircle_true(r = 1, $fa = $fa, $fn = $fn, $fs = $fs)` - half a circle, with edges at radius (instead of points)
* `smooth(r)` - applies two consective `offset`s to achieve a simple smoothing effect
* `smooth_acute(r = 0, dim = [1000, 1000])` - smoothing, but also applies to acute angles
* `sq(dim, center = true)` - convenience wrapper for centred square; handles dimension array lengths > 2
* `star(r, n = 5, inset = 0.5)` - makes star shapes with given side inset
* `t(dim = [10, 10], t = 1, t1, t2)` - "T" shape, for beams
* `u(dim = [10, 10], t = 1, t1, t2)` - "U" shape, for beams

## 3D

* `capsule(h = 10, r, r1, r2, center = false)` - a cylinder with semi-spherical ends
* `cylinder_true(h, r = 0, r1 = 0, r2 = 0, center = true, $fa = $fa, $fn = $fn, $fs = $fs)` - cylinder with faces at radius (instead of edges)
* `pie(a = 90, r = 1, h = 1, center = true)` - an extruded `segment`
* `rounded_cube(dim, r, edges = false, center = true, $fa = $fa, $fn = $fn, $fs = $fs)` - a cube with edges of given radius
* `rounded_cylinder(h, r, f, f1, f2, r1, r2, center = true, $fa = $fa, $fn = $fn, $fs = $fs)` - a cylinder with top and bottom edges of given radii
* `sphere_true(r, $fa = $fa, $fn = $fn, $fs = $fs)` - sphere with faces at radius (instead of edges)
* `torus(r1, r2, fa = $fa, fn = $fn, fs = $fs)` - a donut
* `torus_true(r1, r2, $fa = $fa, $fn = $fn, $fs = $fs)` - a donut with extruded circle having edges at radius (instead of points)

## Hardware

### Electrical

* Buzzer
* Chip
* Connectors
* Displays
* Jacks
* LEDs
* Pin headers
* Potentiometers
* Stepper motors
* Switches (DIP, slide, tact)
* Voltage regulators
* Wire

### Engineering

* Beams (L/T/U)
* Bearings
* Gears
* Nuts
* Screws
* Threads
* Truss
* Washers

### Mechanical

* Centrifugal fan (blower)
* Duct/pipe flange

### RC

* 5.8GHz antenna
* Batteries
* Cameras
* DVRs
* ESCs
* Flight controllers
* GPS
* Motors
* Propellers
* Receivers
* Servos
* Video receivers
* Video transmitters
