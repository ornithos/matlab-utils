function squarize()
% squarize plot: make x and y axes same length (snap to maximum)

x = xlim;
y = ylim;

minBox = min([x(:); y(:)]);
maxBox = max([x(:); y(:)]);

xlim([minBox, maxBox]);
ylim([minBox, maxBox]);

end