#script to generate posres ref file, from 7jgh cryo-EM structure
cryo_pdb=$1
box_pdb=$2
output=$3
itpprot=$4
itpsug=$5




# first align cryo-pdb to box.pdb
cat>tmp-align-cryo.pml<<EOF
load $cryo_pdb , cryo
load $box_pdb ,  box
align cryo & poly, box & poly
save tmp-cryo-aligned.pdb , cryo
EOF
pymol -c tmp-align-cryo.pml


# select ref-cryo-atoms and change sugar names 
egrep 'ATOM|HETATM' tmp-cryo-aligned.pdb | grep -v REMARK | sed 's/BDP/BGL/g' | sed 's/ASG/BGA/g' |     awk ' {print $0, "CRYO"} ' > tmp-cryo


grep ATOM  $box_pdb > tmp-box

grep CRYST $box_pdb > $output

cat tmp-cryo tmp-box |awk '
BEGIN{atid=0}
{
#read position restraints 
if($NF=="CRYO") {


resindexold=resindex
resindex=substr($0,23,4)+0

#if(resindex!=resindexold && NR>2) {N[resindexold]=atid ; atid=0  } 

if(resindex!=resindexold && NR>2) { atid=0  } 

type[resindex,atid]=substr($0,1,5); #ATOM or HETAT
atomtype[resindex,atid]=substr($0,13,4);
resname[resindex,atid]=substr($0,18,3) ;
X[resindex,atid]=substr($0,31,8);
Y[resindex,atid]=substr($0,39,8);
Z[resindex,atid]=substr($0,47,8);
atid++
N[resindex]=atid
}


#--- print found positions
else {
r=substr($0,23,4)+0
atomindex=substr($0,7,5);
atom=substr($0,13,4);
res=substr($0,18,3) ;

if(res=="BGL" || res=="BGA") { r-=82} #restart index of sugars to 1 

#check if that atom is in the cryo-EM structure
#r=1...11: sugar
#r=32...1953 protein

#init coordintes 
x=0.0
y=0.0
z=0.0
Tfactor=0  

#update coordinates from cryo-structures for  found residues
for(at=0;at<N[r];at++) 
if(  res == resname[r,at]  && atomtype[r,at]==atom ) { 
x=X[r,at] ; y=Y[r,at] ; z=Z[r,at]  ; 
Tfactor=1 # this atom was found in cryo struct
break;
}

printf("%-6s%5d %4s %3s %1s%4d%4s%8.3f%8.3f%8.3f%6.2f%6.2f\n", "ATOM", atomindex , atom , res , " " , r," ", x , y , z , 0 , Tfactor) ;



}
}
'  >> $output

# protein itp
grep ATOM $output | grep -v BGL | grep -v BGA | awk ' 
BEGIN { print "[ position_restraints ]"}
{
atid=NR
Temperaturefactor=substr($0,61,6)+0
if( Temperaturefactor==1 ) {  print NR, " 1 5000 5000  5000" }
}
' > $itpprot



# sugar itp
grep ATOM $output | egrep  'BGL|BGA' | awk ' 
BEGIN { print "[ position_restraints ]"}
{
atid=NR
Temperaturefactor=substr($0,61,6)+0
if( Temperaturefactor==1 ) {  print NR, " 1 5000 5000  5000" }
}
' > $itpsug

rm -v tmp-align-cryo.pml   tmp-cryo-aligned.pdb tmp-cryo tmp-box
