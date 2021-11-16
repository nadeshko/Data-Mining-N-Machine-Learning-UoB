yourfilenames=`ls ./docStop/*.stp`
mkdir docStem
prefix="./docStop/"
suffix=".stp"

for eachfile in $yourfilenames
do
    name=${eachfile/$prefix/}
    name=${name/$suffix/}
   ./porter-stemmer $eachfile > ./docStem/$name.stm
done