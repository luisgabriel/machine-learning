function output = normalize_values(data)
    output = [];

    output(:, 1) = data(:, 1);

    for i = 2 : size(data, 2)
        column = data(:, i);
        minValue = min(column);
        range = max(column) - minValue;
        if range > 0
            output(:, i) = (column - minValue) / range;
        end
    end
end
