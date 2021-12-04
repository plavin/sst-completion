elements=$(sst-info 2>/dev/null | grep ELEMENT | tail -n +2 | cut -d' ' -f 4)

for ele in $elements
do
    comp="$comp"$(sst-info $ele | grep "SubComponent " | tr -d [:blank:] | sed 's/SubComponent.*://' | sed "s/^/$ele./")
done

echo $elements > elements.txt
echo $comp > components.txt
