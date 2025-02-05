
pragma circom 2.0.0;

include ".node_modules/circomlib/circuits/sha256/sha256.circom";

template ProofOfInnocence () {

   // Declaration of public signals.  
   signal input root;  
   signal input txid_hash;
   signal input element_absent_constant;
   
   // Declaration of private signals
   signal input txid;
   signal input pathElements[bitsTxidCardano];
   signal input pathIndices[bitsTxidCardano];

   // Component that verifies that txid_hash is hash of txid
   // Averiguar cuántos bits tiene un txid en Cardano
   component hashVerifier = Sha256(bitsTxidCardano);
   
   for (var i = 0; i < bitsTxidCardano; i++) {
      blacklistTree.in[i] <== txid[i];
   }
   for (var i = 0; i < 256; i++) {
      blacklistTree.out[i] <== txid_hash[i];
   }
   
   signal input in[bitsTxidCardano];
   signal output out[256];
   
   // Component that verifies the Merkle Path
   component blacklistTree = MerkleTreeChecker(254);
   blacklistTree.leaf <== element_absent_constant;
   blacklistTree.root <== root;
   for (var i = 0; i < 254; i++) {
      blacklistTree.pathElements[i] <== pathElements[i];
      blacklistTree.pathIndices[i] <== pathIndices[i];
   }
   
}

component main {public [root, txid_hash, element_absent_constant]} = ProofOfInnocence();
