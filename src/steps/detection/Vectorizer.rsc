module steps::detection::Vectorizer

import steps::detection::RequirementsReader;

import List;
import util::Math;
import IO;
import Set;

alias Vector = rel[str name, list[real] freq];

Vector calculateVector(Requirement reqs, list[str] vocabulary) {
	Vector result = {};
	number_req = size(reqs);
	
	for (<id, words> <- reqs) {
		dis = distribution(words);
		freq_list = [];
		for (str w <- vocabulary) {
			int tf = w in dis ? dis[w] : 0;
			real idf = log2(number_req / word_in_req(reqs, w));
			freq_list += tf * idf;
		}
		result += <id, freq_list>;
	}
	return result;
}


int word_in_req(Requirement reqs, str contain_word) {
	count = 0;
	for (<id, words> <- reqs, contain_word in words) {
		count += 1; 
	}
	return count;
}

@doc {
  Calculates the Inverse Document Frequency (IDF) of the different words in the vocabulary
  The 'occurences' map should map the number of requirements that contain a certain word from the vocabulary.
  The 'occurences' map should have entries for all the words in the vocabulary, otherwise an exception will be thrown.
}
private map[str,real] calculateInverseDocumentFrequency(map[str,int] occurences, list[str] vocabulary, Requirement reqs) {
  num nrOfReqs = size(reqs);
  map[str,real] idfs = (w : log2(nrOfReqs / occurences[w]) | str w <- vocabulary); 

  return idfs;
}
