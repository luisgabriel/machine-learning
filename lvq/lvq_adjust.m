function newPrototype = lvq_adjust(sample, prototype, columns, alpha, epsilon)
    if nargin == 4
        epsilon = 1;
    end

    class = prototype(1);
    A = sample(2:columns);
    B = prototype(2:columns);
    diff = (A - B) * alpha * epsilon;

    if sample(1) == class
        newPrototype = [class (A + diff)];
    else
        newPrototype = [class (A - diff)];
    end
end
