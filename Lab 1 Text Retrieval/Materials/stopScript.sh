yourfilenames=`ls ./docOrig/*.txt`
mkdir docStop
prefix="./docOrig/"
suffix=".txt"

for eachfile in $yourfilenames
do
    name=${eachfile/$prefix/}
    name=${name/$suffix/}
   ./stop stopList50 $eachfile > ./docStop/$name.stp
done