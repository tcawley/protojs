ALLSOURCES=$(wildcard protocol/*.pbj) $(wildcard protocol/*.proto)
ALLOUTPUTS=$(patsubst protocol/%,output/%.js,$(ALLSOURCES))
ANTLRVER=3.2

INPUTDIR=protocol
OUTPUTDIR=output

all: $(ALLOUTPUTS) pbj

output/%.proto.js: protocol/%.proto pbj
	./pbj $< $@

output/%.pbj.js: protocol/%.pbj pbj
	./pbj $< $@

pbj : main.cpp ProtoJSLexer.o ProtoJSParser.o ProtoJSParseUtil.o
	g++ -std=c++98 -Wall -static -g -o pbj -Iantlr-$(ANTLRVER)/include -Lantlr-$(ANTLRVER)/lib -I/usr/local/include -L/usr/local/lib main.cpp ProtoJSLexer.o ProtoJSParser.o ProtoJSParseUtil.o -lantlr3c || \
        g++ -g -o pbj -Iantlr-$(ANTLRVER)/include -Lantlr-$(ANTLRVER)/lib -I/usr/local/include -L/usr/local/lib main.cpp ProtoJSLexer.o ProtoJSParser.o ProtoJSParseUtil.o antlr-$(ANTLRVER)/lib/libantlr3c.a || \
        g++ -g -o pbj -Iantlr-$(ANTLRVER)/include -Lantlr-$(ANTLRVER)/lib main.cpp ProtoJSLexer.o ProtoJSParser.o ProtoJSParseUtil.o -lantlr3c

ProtoJSLexer.c : ProtoJS.g
	java -jar antlr-$(ANTLRVER).jar ProtoJS.g

ProtoJSParser.c : ProtoJS.g
	java -jar antlr-$(ANTLRVER).jar ProtoJS.g

ProtoJSLexer.h : ProtoJS.g
	java -jar antlr-$(ANTLRVER).jar ProtoJS.g

ProtoJSParser.h : ProtoJS.g
	java -jar antlr-$(ANTLRVER).jar ProtoJS.g

ProtoJSLexer.o : ProtoJSLexer.h ProtoJSLexer.c
	gcc -c -g -Wall -Iantlr-$(ANTLRVER)/include -I/usr/local/include -o ProtoJSLexer.o ProtoJSLexer.c

ProtoJSParser.o : ProtoJSParser.h ProtoJSParser.c
	gcc -c -g -Wall -Iantlr-$(ANTLRVER)/include -I/usr/local/include -o ProtoJSParser.o ProtoJSParser.c

ProtoJSParseUtil.o : ProtoJSParseUtil.h ProtoJSParseUtil.cpp
	g++ -c -g -Wall -Iantlr-$(ANTLRVER)/include -I/usr/local/include -o ProtoJSParseUtil.o ProtoJSParseUtil.cpp

clean:
	rm -f ProtoJSParseUtil.o ProtoJSLexer.o ProtoJSParser.o ProtoJSLexer.c ProtoJSParser.c main.o
