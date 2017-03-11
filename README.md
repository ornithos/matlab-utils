## matlab-utils

### This is a package containing various utility functions I've made for MATLAB.

Don't let the fact that it's presented as a 'package' fool you into thinking it's well organised, or addresses any specific concern. It is essentially a dumping ground for any function that isn't specifically tailored toward an application. The better features of this include:

### Progress bars
Lightweight console progress bars using `fprintf`, maintaining internal state of current length when performing a refresh. Eg.
```matlab
pb      = utils.base.objProgressBar;
pb.newProgressBar('progressbar: ', 20, 'showPct', true, 'showElapsed', true);
pb.print(0.5);

ib      = utils.base.objIterationBar;
ib.newIterationBar('iterationbar: ', 20)
ib.print(10);
```
Example output:
```
(00:00:07) progressbar: ||||||||||.......... (50.0%)
(00:00:01) iterationbar: 10 of 20
```
Obviously these could have a better common interface, but it's not high on my priority list.

### Processing optional arguments
I find MATLAB's non-support of default values in function declarations a little tiresome. This is my current workaround, using the function `processVarargin`:
```matlab
function out = foo(varargin)
    defaults.x       = 0;
    defaults.verbose = false;
    defaults.bar     = 'cherryblossom';
    
    opts             = utils.base.processVarargin(varargin, defaults);
    ...
    
end
```
The function `utils.base.processVarargin` will return a struct with the defaults overwritten where applicable with fields from varargin. Types are checked, and warnings given if extraneous arguments given that are not contained in the default struct. I appreciate there are various ways to do this, this is merely my preferred method at present. It is also overloaded to deal with struct inputs, so instead of needing to specify name-value pairs, options can be passed between functions in structs.

### Subordinate plots (underplot)
Sometimes you want to include additional plots to convey the state of other variables below a main plot. The result in the below figure can be achieved using the following code:
```matlab
plt          = utils.plot.underplot(4, 0.5);
plt.plot('main', 1:10, rand(1, 10));
plt.plot('under', 1, 1:10, [0 0 0 0 0 1 0 0 0 1])
plt.plot('under', 2, 1:10, [0 0 .5 .5 0 0 0 0 0 1]);
plt.plot('under', 3, 1:10, [0 0 0 0 0 .1 .2 .4 .7 1]);
plt.plot('under', 4, 1:10, [1 .5 0 0 0 0 0 0 0 0]);
```
![Matlab Underplot figure][matlabUnderplot]

The `underplot` class has two required arguments: the number of subordinate plots (in this case 4), and the percentage of the figure area to dedicate to the main plot (in this case 50%). Various additional arguments can be specified regarding labels and border widths. Once the object is created, plotting in each axis can be achieved by calling the method as in the above example. Each axis has a `hold` method. Alternatively if one wishes to work directly with an axis, it can be obtained via a `.getAxis` method.

If one has a series of `underplot` like figures to plot in the same window (like in MATLAB's subplot), there is a `subUnderplot` class in which the user can specify the number of `underplot`s they would like in a window `subUnderplot(m, n, k, mainPct)` as in `subplot`. The relevant subplot can then be indexed using a `(row, column)` reference.

[matlabUnderplot]: https://github.com/ornithos/matlab-utils/blob/master/.aux/matlabUnderplot.png "Matlab Underplot figure"

