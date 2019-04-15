all:
	gprbuild -p -P google-protobuf-test.gpr -XGENERATE=True
	gprbuild -p -P google-protobuf-test.gpr
	bin/pb_harness
clean:
	rm -rf .obj bin src/gen


