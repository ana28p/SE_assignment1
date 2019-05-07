module TraceLinkDetector

import DataSet;
import steps::detection::RequirementsReader;
import steps::detection::StopWordRemover;
import steps::detection::Stemmer;
import steps::detection::VocabularyBuilder;
import steps::detection::Vectorizer;
import steps::detection::SimilarityCalculator;
import steps::detection::TraceLinkConstructor;
import steps::detection::ImportantWordsVeto;

import IO;
import ValueIO;
import List;

void gatherLinksGroup1() = gatherLinks(group1());
void gatherLinksGroup9() = gatherLinks(group9());

void gatherLinks(DataSet grp) {
	bool enableImportantWordsVeto = true;
	int maxFrequencyImportantWord = 25000;
	real maxRelativeDifferenceInImportantWords = 0.85;

	println("(1/9) Getting the least important words");
	list[str] importantVocabulary = stemAll(getImportantWords(maxFrequencyImportantWord));

	println("(2/9) Reading highlevel requirements");
	Requirement highlevel = readHighlevelRequirements(grp);
	println("(3/9) Reading lowlevel requirements");
	Requirement lowlevel = readLowlevelRequirements(grp);
	
	println("(4/9) Removing stop words and apply stemming");
	highlevel = stemWords(removeStopWords(highlevel));
	lowlevel = stemWords(removeStopWords(lowlevel));
	
	println("(5/9) Determine the excluded links");
	excludedLinks = {};
	if (enableImportantWordsVeto) {
		excludedLinks = getExcludedLinks(importantVocabulary, highlevel, lowlevel, maxRelativeDifferenceInImportantWords);
	}
	
	println("(6/9) Building master vocabulary");
	list[str] vocabulary = extractVocabulary(highlevel + lowlevel);
	
	println("(7/9) Calculating vectors");
	Vector vectors = calculateVector(highlevel + lowlevel, vocabulary);

	println("(8/9) Calculating similarity matrix");
	SimilarityMatrix sm = calculateSimilarityMatrix(highlevel, lowlevel, vectors);
	
	println("(9/9) Gathering trace links for different methods");
	AllTraceLinks allLinks = constructLinks(sm, excludedLinks);

  	writeTextValueFile(grp.dir + "tracelinks.result", allLinks);  
	
	println("Done");
	
	//for (int i <- [0..size(allLinks)]) {
	//	printLinks(allLinks[i], i);
	//}
}

void printLinks(TraceLink links, int i) {
	println();
	println("Results for method <i>:");
	println("=======================");
	
	for (str high <- links<0>) {
		println("<high> : <links[high]>");
	}
}
