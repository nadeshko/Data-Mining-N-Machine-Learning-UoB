#!c:/Program Files/Perl5.6.1/bin/perl

#####################################################################################################
# 
# This script extract features from Aurora2 'Train clean' data and performs training and testing.
# Usage:  perl ASR_LabDMML_3mix.pl
# Author: Munevver Kokuer
# Date: Nov. 2021
#####################################################################################################


# Global Variables

$REC_DIR    	= "U:\\Year4\\LabASR";
$BINDIR     	= "$REC_DIR\\HTK3.2bin"; 

$HMM_DIR    	= "$REC_DIR\\hmmsTrained";

$LIST_train	= "$REC_DIR/list/listTrainFullPath_LabDMML_ALL.scp"; 
$LIST_train_HCopy  = "$REC_DIR/list/listTrainHCopy_LabDMML_ALL.scp"; 

$LIST_test	= "$REC_DIR/list/listTestFullPath_LabDMML_N1_SNR10.scp"; 
$LIST_test_HCopy= "$REC_DIR/list/listTestHCopy_LabDMML_N1_SNR10.scp";

$CONFIG_HCopy   = "$REC_DIR/config/config_HCopy_MFCC_E";
$CONFIG_train   = "$REC_DIR/config/config_train_MFCC_E";
$CONFIG_test   	= "$REC_DIR/config/config_test_MFCC_E";

$WORD_LISTSP	= "$REC_DIR/lib/wordList_withSP";
$WORD_LIST  	= "$REC_DIR/lib/wordList_noSP";
$LABELSP    	= "$REC_DIR/label/label_LabDMML_withSP.mlf";
$LABELS    	= "$REC_DIR/label/label_LabDMML_noSP.mlf"; 
$LABELSTEST    	= "$REC_DIR/label/labelTest_LabDMML.mlf"; 

$ED_CMDFILE1	= "$REC_DIR/lib/tieSILandSP_LabDMML.hed";
$ED_CMDFILE2	= "$REC_DIR/lib/mix2_st8_LabDMML.hed";
$ED_CMDFILE3	= "$REC_DIR/lib/mix3_st8_LabDMML.hed";

$Proto      	= "$REC_DIR/lib/proto_s1d39_st8m1_LabDMML_MFCC_E_D_A";
$mod_file 	= "$HMM_DIR/hmm20/models";
$mac_file 	= "$HMM_DIR/hmm20/macros"; 

$flags      	= "-p -20 -s 0.0";
$NET        	= "$REC_DIR\\lib\\wordNetwork";
$DICT       	= "$REC_DIR\\lib\\wordDict"; 

$NUM_COEF   	= 39; 
$PAR_TYPE   	= "MFCC_E_D_A";

$RESULT 	= "$REC_DIR\\result\\RecognitionAllTraining_Result_SNR10.res";


open(STDOUT, ">$REC_DIR\\result\\LogASR_LabDMML.log") or die "Can't write to STDOUT $!";


#-------------------------------------------------------------------------
# Feature Extraction for mfcc_e_d_a
# HCopy: Calls HCopy to convert AURORA TESTA data files to HTK parameterised 'mfcc_e_d_a'
#-------------------------------------------------------------------------

print "Coding data\n";

system("$BINDIR/HCopy -C $CONFIG_HCopy -S $LIST_train_HCopy");
system("$BINDIR/HCopy -C $CONFIG_HCopy -S $LIST_test_HCopy");

print "Coding complete\n";

#-------------------------------------------------------------------------
# Training 
#-------------------------------------------------------------------------

print "Training...\n";

foreach $i (0..20) {
    mkdir("$HMM_DIR\\hmm$i");
}

system "$BINDIR\\HCompV -C $CONFIG_train -o hmmdef -f 0.01 -m -S $LIST_train -M $HMM_DIR/hmm0 $Proto";

print("Seed Hmm succesfully produced\n"); 

system "$BINDIR/macro $NUM_COEF $PAR_TYPE $HMM_DIR/hmm0/vFloors $HMM_DIR/hmm0/macros";
### creates the file "models" containing the HMM definition of all 11 digits and the silence model
system "$BINDIR/models_1mixsil $HMM_DIR/hmm0/hmmdef $HMM_DIR/hmm0/models";

###Training 
foreach $i (1..3) {
	print "Iteration Number $i\n";
	$j=$i-1;
	system "$BINDIR/HERest -D -C $CONFIG_train -I $LABELS -t 250.0 150.0 1000.0 -S $LIST_train -H $HMM_DIR/hmm$j/macros -H $HMM_DIR/hmm$j/models -M $HMM_DIR/hmm$i $WORD_LIST";
}
print "3 Iterations completed\n";

system("copy $HMM_DIR\\hmm3 $HMM_DIR\\hmm4");
system "$BINDIR/spmodel_gen $HMM_DIR/hmm3/models $HMM_DIR/hmm4/models";
system "$BINDIR/HHEd -T 2 -H $HMM_DIR/hmm4/macros -H $HMM_DIR/hmm4/models -M $HMM_DIR/hmm5 $ED_CMDFILE1 $WORD_LISTSP";
print "SP model fixed\n";

foreach $i (6..8) {
	$j=$i-1;
	system "$BINDIR/HERest -C $CONFIG_train -I $LABELSP -S $LIST_train -H $HMM_DIR/hmm$j/macros -H $HMM_DIR/hmm$j/models -M $HMM_DIR/hmm$i $WORD_LISTSP";
}
print "6 Iterations completed\n";

system "$BINDIR/HHEd -T 2 -H $HMM_DIR/hmm8/macros -H $HMM_DIR/hmm8/models -M $HMM_DIR/hmm9 $ED_CMDFILE2 $WORD_LISTSP";
print "2 Gaussians per mixture created\n";

foreach $i (10..12) {
	$j=$i-1;
	system "$BINDIR/HERest -C $CONFIG_train -I $LABELSP -S $LIST_train -H $HMM_DIR/hmm$j/macros -H $HMM_DIR/hmm$j/models -M $HMM_DIR/hmm$i $WORD_LISTSP";
}
print "9 Iterations completed\n";

system "$BINDIR/HHEd -T 2 -H $HMM_DIR/hmm12/macros -H $HMM_DIR/hmm12/models -M $HMM_DIR/hmm13 $ED_CMDFILE3 $WORD_LISTSP";
print "3 Gaussians per mixture created\n";

foreach $i (14..20) {
	$j=$i-1;
	system "$BINDIR/HERest -C $CONFIG_train -I $LABELSP -S $LIST_train -H $HMM_DIR/hmm$j/macros -H $HMM_DIR/hmm$j/models -M $HMM_DIR/hmm$i $WORD_LISTSP";
}
print "16 Iterations completed\n";

print "Training complete\n";


#-------------------------------------------------------------------------
# Testing 
#-------------------------------------------------------------------------

print "Testing...\n";

system "$BINDIR/HVite -H $mac_file -H $mod_file -S $LIST_test -C $CONFIG_test -w $NET -i $REC_DIR/result/result.mlf $flags $DICT $WORD_LISTSP";

system ("$BINDIR/HResults -e \"???\" sil -e \"???\" sp -I $LABELSTEST $WORD_LISTSP $REC_DIR/result/result.mlf >> $RESULT "); 

print "Testing complete\n";
print("\n------------------------------------------------------------------\n");


#--------------------------------------------------------------------------#
#                   End of Script: ASR_LabDMML_3mix.pl                     #
#--------------------------------------------------------------------------#