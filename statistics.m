function stat = statistics(x)
    arr=table2array(x);
    means=(mean(arr));
    stdevs=(std(arr));
    medians=(median(arr));
    minimums=(min(arr));
    maximums=(max(arr));
    stat=table(means, stdevs, medians, minimums, maximums);
end

