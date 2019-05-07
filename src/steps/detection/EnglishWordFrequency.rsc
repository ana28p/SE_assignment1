module steps::detection::EnglishWordFrequency

import analysis::text::stemming::Snowball;
import util::Math;

import IO;
import String;
import List;

import DataSet;

alias WordFreq = map[str,int];

WordFreq readWordFrequency() {
	list[str] words = split("\n",readFile(|project://SE_assignment1/data/English-Word-Frequency.txt|));
	WordFreq result = ();
	for (str line <- words, /^<word:[a-z]+>,<val:[0-9]+>$/ := trim(line)) {
		result += (word:toInt(val));
	}
	
	return stemFreqWords(removeStopWords(result));
}

int getMaxWordFreq(WordFreq orig) {
	return (0 | max(it, orig[w]) | w <- orig);
}

set[str] readStopwords() =
	{word | /<word:[a-zA-Z\"]+>/ := readFile(|project://SE_assignment1/data/stop-word-list.txt|)};
	
WordFreq removeStopWords(WordFreq args) {
  stopwords = readStopwords();
  
  for (w <- args, w in stopwords) {
    args -= (w: args[w]);
  }
  
  return args;
}

WordFreq stemFreqWords(WordFreq orig) {
	WordFreq result = ();
	for (w <- orig) {
		str stemmed = porterStemmer(w);
		if (stemmed in result) {
			curval = result[stemmed];
			if (curval < orig[w]) {
				result[stemmed] = orig[w];
			} 
		}
		else {
			result += (stemmed: orig[w]);
		}
	}
	return result;
}