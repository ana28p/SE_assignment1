module steps::detection::StopWordRemover

import IO;
import String;
import Set;
import List;

import steps::detection::RequirementsReader;

Requirement removeStopWords(Requirement reqs) {
	Requirement result = {};
	
	for (<id, words> <- reqs) {
		//println("<id>---------first---------");
		//for (w <- words) {
		//	println(w);
	 //   }
	    
		list[str] baseWords = remover2(words);
		result += {<id, baseWords>};
		
		//println("<id>---------after---------");
		//for (w <- baseWords) {
		//	println(w);
	 //   }
	}

  	return result;
}

// TODO: Add extra functions if wanted / needed

set[str] readStopwords() =
	{word | /<word:[a-zA-Z\"]+>/ := readFile(|project://SE_assignment1/data/stop-word-list.txt|)};

list[str] remover(list[str] args) {
  stopwords = readStopwords();
  
  for (w <- args, w notin stopwords) {
    args -= w;
  }
  
  return args;
}

list[str] remover2(list[str] args) {
  stopwords = readStopwords();
  return [w | w <- args, w notin stopwords];
}