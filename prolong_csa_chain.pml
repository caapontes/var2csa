load MD-11mer/sd-loop-relax.gro 
cmd.select('sele','none')
cmd.select('sele',"byresi((((sele) or byresi((sd-loop-relax`31193))) and not ((byresi((sd-loop-relax`31193))) and byresi(sele))))",enable=1)
cmd.select('sele',"byresi((((sele) or byresi((sd-loop-relax`31228))) and not ((byresi((sd-loop-relax`31228))) and byresi(sele))))",enable=1)
select 11mer, resn  BGLCA+BGALN 
cmd.select(None,"11mer")
cmd.wizard("renaming","sel01")
refresh_wizard
cmd.get_wizard().do_key(8,0,0,0)
cmd.get_wizard().do_key(8,0,0,0)
cmd.get_wizard().do_key(8,0,0,0)
cmd.get_wizard().do_key(8,0,0,0)
cmd.get_wizard().do_key(8,0,0,0)
cmd.get_wizard().do_key(49,0,0,0)
cmd.get_wizard().do_key(49,0,0,0)
cmd.get_wizard().do_key(109,0,0,0)
cmd.get_wizard().do_key(101,0,0,0)
cmd.get_wizard().do_key(114,0,0,0)
cmd.get_wizard().do_key(98,0,0,0)
cmd.get_wizard().do_key(8,0,0,0)
cmd.get_wizard().do_key(66,0,0,1)
cmd.get_wizard().do_key(13,0,0,0)
cmd.disable('11merB')
cmd.enable('11mer')
cmd.disable('11mer')
cmd.enable('11merB')
cmd.disable('11merB')
cmd.enable('11merB')
cmd.create(None,"11merB",zoom=0)
cmd.wizard("renaming","obj01")
refresh_wizard
cmd.get_wizard().do_key(8,0,0,0)
cmd.get_wizard().do_key(8,0,0,0)
cmd.get_wizard().do_key(8,0,0,0)
cmd.get_wizard().do_key(8,0,0,0)
cmd.get_wizard().do_key(8,0,0,0)
cmd.get_wizard().do_key(49,0,0,0)
cmd.get_wizard().do_key(49,0,0,0)
cmd.get_wizard().do_key(109,0,0,0)
cmd.get_wizard().do_key(101,0,0,0)
cmd.get_wizard().do_key(114,0,0,0)
cmd.get_wizard().do_key(66,0,0,1)
cmd.get_wizard().do_key(13,0,0,0)
cmd.disable('11merB')
cmd.select('sele','none')
cmd.select('sele',"byresi((((sele) or byresi((sd-loop-relax`31197))) and not ((byresi((sd-loop-relax`31197))) and byresi(sele))))",enable=1)
select 1st-sugar-ref, 11mer and resi 1
cmd.disable('1st-sugar-ref')
cmd.enable('1st-sugar-ref')
select last-sugar-mobible , 11merB and resi 11
cmd.disable('last-sugar-mobible')
cmd.enable('11merB',1)
cmd.enable('last-sugar-mobible')
cmd.disable('last-sugar-mobible')
align last-sugar-mobible, 1st-sugar-ref 
select 11mer-minus-first, 11mer and ! resi 1
cmd.disable('11merB')
cmd.enable('11merB',1)
cmd.disable('11merB')
cmd.enable('11merB',1)
cmd.disable('11merB')
cmd.enable('11merB',1)
cmd.disable('11merB')
cmd.enable('11merB',1)
cmd.disable('11merB')
cmd.enable('11merB',1)
cmd.disable('11merB')
cmd.enable('11merB',1)
cmd.disable('11merB')
cmd.enable('11merB',1)
cmd.disable('11merB')
cmd.enable('11merB',1)
cmd.disable('11merB')
cmd.enable('11merB',1)
cmd.disable('11merB')
cmd.enable('11merB',1)
cmd.disable('11merB')
cmd.enable('11merB',1)
cmd.disable('11merB')
cmd.enable('11merB',1)
cmd.disable('11merB')
cmd.enable('11merB',1)
cmd.disable('11merB')
cmd.enable('11merB',1)
cmd.disable('11merB')
cmd.enable('11merB',1)
cmd.disable('11mer-minus-first')
cmd.enable('11mer-minus-first')
cmd.disable('sd-loop-relax')
cmd.enable('sd-loop-relax',1)
cmd.disable('sd-loop-relax')
cmd.enable('sd-loop-relax',1)
cmd.disable('11merB')
cmd.enable('11merB',1)
cmd.disable('11merB')
cmd.enable('11merB',1)
cmd.disable('11merB')
cmd.enable('11merB',1)
select 11merB-minus-last, 11merB and ! resi 11
cmd.disable('11merB')
cmd.enable('11merB',1)
cmd.disable('11merB')
cmd.enable('11merB',1)
cmd.disable('11merB')
cmd.enable('11merB',1)
cmd.disable('11merB')
cmd.enable('11merB',1)
help merge
cmd.enable('11mer')
cmd.create(None,"11mer",zoom=0)
cmd.wizard("renaming","obj01")
refresh_wizard
cmd.get_wizard().do_key(8,0,0,0)
cmd.get_wizard().do_key(8,0,0,0)
cmd.get_wizard().do_key(8,0,0,0)
cmd.get_wizard().do_key(8,0,0,0)
cmd.get_wizard().do_key(8,0,0,0)
cmd.get_wizard().do_key(49,0,0,0)
cmd.get_wizard().do_key(49,0,0,0)
cmd.get_wizard().do_key(109,0,0,0)
cmd.get_wizard().do_key(101,0,0,0)
cmd.get_wizard().do_key(114,0,0,0)
cmd.get_wizard().do_key(13,0,0,0)
cmd.create(None,"11merB-minus-last",zoom=0)
cmd.wizard("renaming","obj01")
refresh_wizard
cmd.get_wizard().do_key(8,0,0,0)
cmd.get_wizard().do_key(8,0,0,0)
cmd.get_wizard().do_key(8,0,0,0)
cmd.get_wizard().do_key(8,0,0,0)
cmd.get_wizard().do_key(8,0,0,0)
cmd.get_wizard().do_key(49,0,0,0)
cmd.get_wizard().do_key(49,0,0,0)
cmd.get_wizard().do_key(8,0,0,0)
cmd.get_wizard().do_key(8,0,0,0)
cmd.get_wizard().do_key(49,0,0,0)
cmd.get_wizard().do_key(49,0,0,0)
cmd.get_wizard().do_key(109,0,0,0)
cmd.get_wizard().do_key(101,0,0,0)
cmd.get_wizard().do_key(114,0,0,0)
cmd.get_wizard().do_key(66,0,0,1)
cmd.get_wizard().do_key(45,0,0,0)
cmd.get_wizard().do_key(109,0,0,0)
cmd.get_wizard().do_key(105,0,0,0)
cmd.get_wizard().do_key(110,0,0,0)
cmd.get_wizard().do_key(115,0,0,0)
cmd.get_wizard().do_key(8,0,0,0)
cmd.get_wizard().do_key(117,0,0,0)
cmd.get_wizard().do_key(115,0,0,0)
cmd.get_wizard().do_key(45,0,0,0)
cmd.get_wizard().do_key(108,0,0,0)
cmd.get_wizard().do_key(97,0,0,0)
cmd.get_wizard().do_key(115,0,0,0)
cmd.get_wizard().do_key(116,0,0,0)
cmd.get_wizard().do_key(13,0,0,0)



alter 11mer and resi 1, resi=11
alter 11mer and resi 2, resi=12
alter 11mer and resi 3, resi=13
alter 11mer and resi 4, resi=14
alter 11mer and resi 5, resi=15
alter 11mer and resi 6, resi=16
alter 11mer and resi 7, resi=17
alter 11mer and resi 8, resi=18
alter 11mer and resi 9, resi=19
alter 11mer and resi 10, resi=20
alter 11mer and resi 11, resi=21

select 21mer, 11merB-minus-last | 11mer

alter 21mer, chain='B'





hide cartoon, 




select 21mer-minus-oh, 21mer and !  ( resi 1 and name O1+HO1 )
cmd.disable('21mer')
cmd.enable('21mer',1)
cmd.create(None,"21mer-minus-oh",zoom=0)
cmd.wizard("renaming","obj01")
refresh_wizard
cmd.get_wizard().do_key(8,0,0,0)
cmd.get_wizard().do_key(8,0,0,0)
cmd.get_wizard().do_key(8,0,0,0)
cmd.get_wizard().do_key(8,0,0,0)
cmd.get_wizard().do_key(8,0,0,0)
cmd.get_wizard().do_key(50,0,0,0)
cmd.get_wizard().do_key(49,0,0,0)
cmd.get_wizard().do_key(109,0,0,0)
cmd.get_wizard().do_key(101,0,0,0)
cmd.get_wizard().do_key(114,0,0,0)
cmd.get_wizard().do_key(223,0,0,0)
cmd.wizard("renaming","obj01")
refresh_wizard
cmd.get_wizard().do_key(8,0,0,0)
cmd.get_wizard().do_key(8,0,0,0)
cmd.get_wizard().do_key(8,0,0,0)
cmd.get_wizard().do_key(8,0,0,0)
cmd.get_wizard().do_key(8,0,0,0)
cmd.get_wizard().do_key(50,0,0,0)
cmd.get_wizard().do_key(49,0,0,0)
cmd.get_wizard().do_key(109,0,0,0)
cmd.get_wizard().do_key(101,0,0,0)
cmd.get_wizard().do_key(114,0,0,0)
cmd.get_wizard().do_key(45,0,0,0)
cmd.get_wizard().do_key(108,0,0,0)
cmd.get_wizard().do_key(8,0,0,0)
cmd.get_wizard().do_key(8,0,0,0)
cmd.get_wizard().do_key(63,0,0,1)
cmd.get_wizard().do_key(8,0,0,0)
cmd.get_wizard().do_key(63,0,0,1)
cmd.get_wizard().do_key(8,0,0,0)
cmd.get_wizard().do_key(95,0,0,1)
cmd.get_wizard().do_key(115,0,0,0)
cmd.get_wizard().do_key(117,0,0,0)
cmd.get_wizard().do_key(103,0,0,0)
cmd.get_wizard().do_key(97,0,0,0)
cmd.get_wizard().do_key(114,0,0,0)
cmd.get_wizard().do_key(95,0,0,1)
cmd.get_wizard().do_key(108,0,0,0)
cmd.get_wizard().do_key(111,0,0,0)
cmd.get_wizard().do_key(110,0,0,0)
cmd.get_wizard().do_key(103,0,0,0)
cmd.get_wizard().do_key(95,0,0,1)
cmd.get_wizard().do_key(99,0,0,0)
cmd.get_wizard().do_key(111,0,0,0)
cmd.get_wizard().do_key(110,0,0,0)
cmd.get_wizard().do_key(110,0,0,0)
cmd.get_wizard().do_key(101,0,0,0)
cmd.get_wizard().do_key(99,0,0,0)
cmd.get_wizard().do_key(116,0,0,0)
cmd.get_wizard().do_key(13,0,0,0)
cmd.disable('21mer')
cmd.enable('21mer',1)
cmd.disable('21mer')
cmd.enable('21mer',1)
cmd.disable('21mer')
cmd.disable('sd-loop-relax')
cmd.disable('21mer_sugar_long_connect')
cmd.enable('21mer_sugar_long_connect',1)
help create
create protein, sd-loop-relax and poly 
cmd.disable('protein')
cmd.enable('protein',1)
cmd.show("cartoon"   ,"protein")
create var2csa_sugar_long_connect ,  protein | 21mer_sugar_long_connect 
cmd.enable('21mer-minus-oh')
cmd.disable('21mer-minus-oh')
cmd.disable('21mer_sugar_long_connect')
cmd.disable('protein')
cmd.disable('var2csa_sugar_long_connect')
cmd.enable('var2csa_sugar_long_connect',1)

save var2csa_sugar_long_connnect.pdb , var2csa_sugar_long_connect, 

