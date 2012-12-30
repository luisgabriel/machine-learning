function result = euclidian_distance(a, b)
    dimensions = min(length(a), length(b));
    diff = power(a(2:dimensions) - b(2:dimensions), 2);
    result = sqrt(sum(diff));
end
