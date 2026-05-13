.PHONY: build clean

build: bin/fluxycore_transformer

bin/fluxycore_transformer: crystal/src/fluxycore_transformer.cr
	crystal build crystal/src/fluxycore_transformer.cr -o bin/fluxycore_transformer --release

clean:
	rm -f bin/fluxycore_transformer