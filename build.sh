docker image build --platform linux/amd64 -t nanograv .

docker run \
-v /var/run/docker.sock:/var/run/docker.sock \
-v /Users/aaron/Documents/GitHub/tinygrav:/output \
--privileged -t --rm \
singularityware/docker2singularity \
nanograv