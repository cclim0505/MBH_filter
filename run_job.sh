# Script to run filter programme.
# Update 22 Dec 2020

# Input variables.
material="Au"
natoms="13"
file_name="sample.xyz"   # xyz file for input
ene_cut="-1005.0"       # Cut off energy for filter.


# File manipulation parameters 
# Do not change unless you know what you are doing.
sorted_list="sorted_list.dat"   # sorted numbers
output_xyz="00_output.xyz"
sorted_ene="sorted_ene.dat"
relative_ene="01_relative_ene.dat"
output_folder="output_results"

if [ -e $output_folder ] 
then
    rm -r $output_folder
    mkdir $output_folder
else
    mkdir $output_folder
fi



# Run FORTRAN filter programme.
./filter.out $file_name $ene_cut

fil_out="filtered_"$file_name




# Script to sort list of filtered xyz coordinates according to energy.
grep -iv $material $fil_out | grep -vE "$natoms$" | grep -n '' | sed 's/\:/\ /g' | sort -rk 2n | awk '{print $1}' > $sorted_list




# Run FORTRAN xyz sorting programme.
./sort.out $sorted_list $fil_out 

mv "sorted_"$fil_out $output_xyz    # rename output




# Script to calculate relative energies wrt to the lowest
grep -iv $material $output_xyz | grep -vE "$natoms$" > $sorted_ene

lowest=$(sed -n 1p $sorted_ene)

awk -v a="$lowest" 'BEGIN {count=0} {printf "%7d \t %.10f \t %.10f \n", count, $1-a, $1; count++}' $sorted_ene > $relative_ene




echo "Lowest energy is $lowest"
echo ""
echo "Moving following files into $output_folder."
for x in $sorted_list $output_xyz $sorted_ene $relative_ene $fil_out
do
    echo $x
    mv $x $output_folder
done
echo ""
