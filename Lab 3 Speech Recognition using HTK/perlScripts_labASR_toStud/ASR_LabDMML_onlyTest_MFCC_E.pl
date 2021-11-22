#!c:/Program Files/Perl5.6.1/bin/perl

#####################################################################################################
# 
# This script runs testing
# Usage:  perl ASR_LabDMML_onlyTest.pl 
# Author: Munevver Kokuer
# Date: Nov. 2018
#####################################################################################################


# Global Variables

$REC_DIR    	= "C:\\LabASR";
$BINDIR     	= "$REC_DIR\\HTK3.2bin"; 

$HMM_DIR    	= "$REC_DIR\\hmmsTrained";

$LIST_test	= "$REC_DIR/list/listTestFullPath_LabDMML_CLEAN1.scp"; 
$LIST_test_HCopy= "$REC_DIR/list/listTestHCopy_LabDMML_CLEAN1.scp";

$CONFIG_test   	= "$REC_DIR/config/config_test_MFCC_E";

$WORD_LISTSP	= "$REC_DIR/lib/wordList_withSP";

$LABELSTEST    	= "$REC_DIR/label/labelTest_LabDMML.mlf";

$mod_file 	= "$HMM_DIR/hmm8/models";
$mac_file 	= "$HMM_DIR/hmm8/macros"; 

$flags      	= "-p 0 -s 0.0";
$NET        	= "$REC_DIR\\lib\\wordNetwork";
$DICT       	= "$REC_DIR\\lib\\wordDict"; 


$RESULT 	= "$REC_DIR\\result\\recognitionFinalResult.res";


open(STDOUT, ">$REC_DIR\\result\\LogASR_LabDMML_onlyTesting.log") or die "Can't write to STDOUT $!";

#-------------------------------------------------------------------------
# Testing 
#-------------------------------------------------------------------------

print "Testing...\n";

system "$BINDIR/HVite -H $mac_file -H $mod_file -S $LIST_test -C $CONFIG_test -w $NET -i $REC_DIR/result/result.mlf $flags $DICT $WORD_LISTSP";

system ("$BINDIR/HResults -e \"???\" sil -e \"???\" sp -I $LABELSTEST $WORD_LISTSP $REC_DIR/result/result.mlf >> $RESULT "); 

print "Testing complete\n";
print("\n------------------------------------------------------------------\n");


#--------------------------------------------------------------------------#
#                   End of Script: ASR_LabDMML_onlyTest.pl                 #
#--------------------------------------------------------------------------#