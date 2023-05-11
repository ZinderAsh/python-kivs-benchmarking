CXX=g++
CFLAGS=-Wall -Wextra -lm
CBUILDDIR=build/src
CPROGRAMDIR=build
CTESTDIR=tests
CSRCDIR=biocy/cpp
COBJECTS=$(CBUILDDIR)/Graph.o $(CBUILDDIR)/hashing.o $(CBUILDDIR)/KmerFinder.o $(CBUILDDIR)/GFA.o $(CBUILDDIR)/VCF.o
CHEADERS=$(CSRCDIR)/node.hpp $(CSRCDIR)/doctest.h

test: test-vg test-odgi test-biocy

test-vg: vg data/yeast.vg
	@echo "Testing runtime for vg"
	@printf "Run\tCPU\tSYS\tMEM (kb)\n"
	@/usr/bin/time -f "1\t%U\t%S\t%M" ./vg kmers -k 31 -t 1 data/yeast.vg > /dev/null
	@/usr/bin/time -f "2\t%U\t%S\t%M" ./vg kmers -k 31 -t 1 data/yeast.vg > /dev/null
	@/usr/bin/time -f "3\t%U\t%S\t%M" ./vg kmers -k 31 -t 1 data/yeast.vg > /dev/null
	@/usr/bin/time -f "4\t%U\t%S\t%M" ./vg kmers -k 31 -t 1 data/yeast.vg > /dev/null
	@/usr/bin/time -f "5\t%U\t%S\t%M" ./vg kmers -k 31 -t 1 data/yeast.vg > /dev/null
	@/usr/bin/time -f "6\t%U\t%S\t%M" ./vg kmers -k 31 -t 1 data/yeast.vg > /dev/null
	@/usr/bin/time -f "7\t%U\t%S\t%M" ./vg kmers -k 31 -t 1 data/yeast.vg > /dev/null

test-odgi: odgi data/yeast.og
	@echo "Testing runtime for odgi"
	@printf "Run\tCPU\tSYS\tMEM (kb)\n"
	@/usr/bin/time -f "1\t%U\t%S\t%M" ./odgi kmers -i data/yeast.og -k 31 -t 1 > /dev/null
	@/usr/bin/time -f "2\t%U\t%S\t%M" ./odgi kmers -i data/yeast.og -k 31 -t 1 > /dev/null
	@/usr/bin/time -f "3\t%U\t%S\t%M" ./odgi kmers -i data/yeast.og -k 31 -t 1 > /dev/null
	@/usr/bin/time -f "4\t%U\t%S\t%M" ./odgi kmers -i data/yeast.og -k 31 -t 1 > /dev/null
	@/usr/bin/time -f "5\t%U\t%S\t%M" ./odgi kmers -i data/yeast.og -k 31 -t 1 > /dev/null
	@/usr/bin/time -f "6\t%U\t%S\t%M" ./odgi kmers -i data/yeast.og -k 31 -t 1 > /dev/null
	@/usr/bin/time -f "7\t%U\t%S\t%M" ./odgi kmers -i data/yeast.og -k 31 -t 1 > /dev/null

test-biocy: data/yeast.bcg
	@echo "Testing runtime for biocy"
	@printf "Run\tCPU\tSYS\tMEM (kb)\n"
	@/usr/bin/time -f "1\t%U\t%S\t%M" python test_kmer_index_speed.py data/yeast.bcg > /dev/null
	@/usr/bin/time -f "2\t%U\t%S\t%M" python test_kmer_index_speed.py data/yeast.bcg > /dev/null
	@/usr/bin/time -f "3\t%U\t%S\t%M" python test_kmer_index_speed.py data/yeast.bcg > /dev/null
	@/usr/bin/time -f "4\t%U\t%S\t%M" python test_kmer_index_speed.py data/yeast.bcg > /dev/null
	@/usr/bin/time -f "5\t%U\t%S\t%M" python test_kmer_index_speed.py data/yeast.bcg > /dev/null
	@/usr/bin/time -f "6\t%U\t%S\t%M" python test_kmer_index_speed.py data/yeast.bcg > /dev/null
	@/usr/bin/time -f "7\t%U\t%S\t%M" python test_kmer_index_speed.py data/yeast.bcg > /dev/null

data/yeast.vg:
	./vg construct -r data/yeast.fa -v data/yeast_no_genotypes.vcf > data/yeast.vg

data/yeast.gfa: data/yeast.vg
	./vg view data/yeast.vg > data/yeast.gfa

data/yeast.og: data/yeast.gfa
	./odgi build -g data/yeast.gfa -o data/yeast.og --optimize

data/yeast.bcg: data/yeast.gfa
	python gfa_to_bcg.py data/yeast.gfa data/yeast.bcg