module steps::detection::VocabularyBuilder

import steps::detection::RequirementsReader;

import List;

list[str] extractVocabulary(Requirement reqs) {
  // TODO: Extract a list of unique words from the vocabulary.
  // Please notice that the result is a list instead of (the more logical) set. 
  // This is because we need a list of words when calculating the vectors.
  
	list[str] uniqueWords = [];
	for (<id, words> <- reqs) {
		uniqueWords += [w | w <- words, w notin uniqueWords];
	}
	  
	return uniqueWords; 
}