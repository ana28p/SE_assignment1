module steps::detection::EnglishWordFrequency

import analysis::text::stemming::Snowball;
import util::Math;

import IO;
import String;
import List;

import DataSet;

alias WordFreq = map[str,int];
alias WordWeight = map[str,real];
real minWeight = 1.;
real maxWeight = 10.;

WordFreq readWordFrequency() {
	list[str] words = split("\n",readFile(|project://SE_assignment1/data/English-Word-Frequency.txt|));
	WordFreq result = ();
	for (str line <- words, /^<word:[a-z]+>,<val:[0-9]+>$/ := trim(line)) {
		result += (word:toInt(val));
	}
	
	return stemFreqWords(removeStopWords(result));
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

WordWeight calculateWordWeight(WordFreq orig) {
	WordWeight result = ();
	int minFreq = min(orig);
	int maxFreq = max(orig);
	// e^(ax+b)
	//real a = (ln(minWeight) - ln(maxWeight)) / (maxFreq - minFreq);
	//real b = ln(minWeight) - (a * maxFreq);
	// 1/(ax+b)
	real a = (1/maxWeight - 1/minWeight) / (minFreq - maxFreq);
	real b = 1/minWeight - (a * maxFreq); 
	for (w <- orig) {
		//result += (w: exp(a * orig[w] + b));
		result += (w: 1.0 / (a * orig[w] + b));
	}
	println(result);
	return result;
}

int min(WordFreq orig) {
	return (1000000000 | min(it, orig[w]) | w <- orig);
}

int max(WordFreq orig) {
	return (0 | max(it, orig[w]) | w <- orig);
}