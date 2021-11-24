#!c:/Program Files/Perl5.6.1/bin/perl

#####################################################################################################
# 
# This script runs testing
# Usage:  perl ASR_LabDMML_onlyTest_3mix.pl 
# Author: Munevver Kokuer
# Date: Nov. 2018
#####################################################################################################


# Global Variables

$REC_DIR    	= "U:\\Year4\\LabASR";
$BINDIR     	= "$REC_DIR\\HTK3.2bin"; 

$HMM_DIR    	= "$REC_DIR\\hmmsTrained";

$LIST_TEST	= "$REC_DIR/list/listTestFullPath_LabDMML_N1_SNR10.scp"; 
$LIST_Test_Hcopy= "$REC_DIR/list/listTestHCopy_LabDMML_N1_SNR10.scp";

$CONFIG_test   	= "$REC_DIR/config/config_test_MFCC_E";

$WORD_LISTSP	= "$REC_DIR/lib/wordList_withSP";

$LABELSTEST    	= "$REC_DIR/label/labelTest_LabDMML.mlf";

$mod_file 	= "$HMM_DIR/hmm20/models";
$mac_file 	= "$HMM_DIR/hmm20/macros"; 

$flags      	= "-p -86.5 -s 0.0";
$NET        	= "$REC_DIR\\lib\\wordNetwork";
$DICT       	= "$REC_DIR\\lib\\wordDict"; 


$RESULT 	= "$REC_DIR\\result\\recognitionFinalResult_N1SNR10.res";


open(STDOUT, ">$REC_DIR\\result\\LogASR_LabDMML_onlyTesting.log") or die "Can't write to STDOUT $!";

#-------------------------------------------------------------------------
# Testing 
#-------------------------------------------------------------------------

print "Testing...\n";

system "$BINDIR/HVite -H $mac_file -H $mod_file -S $LIST_TEST -C $CONFIG_test -w $NET -i $REC_DIR/result/result.mlf $flags $DICT $WORD_LISTSP";

system ("$BINDIR/HResults -e \"???\" sil -e \"???\" sp -I $LABELSTEST $WORD_LISTSP $REC_DIR/result/result.mlf >> $RESULT "); 

print "Testing complete\n";
print("\n------------------------------------------------------------------\n");


#--------------------------------------------------------------------------#
#                   End of Script: ASR_LabDMML_onlyTest_3mix.pl            #
#--------------------------------------------------------------------------#