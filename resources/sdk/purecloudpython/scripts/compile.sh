SDK_REPO=$1
BUILD_DIR=$2
TESTS_DIR=$3

echo "SDK_REPO=$SDK_REPO"
echo "BUILD_DIR=$BUILD_DIR"
echo "TESTS_DIR=$TESTS_DIR"

# Copy license
cp $SDK_REPO/LICENSE $BUILD_DIR/License.txt

# Rename python setup file
if [ ! -f $BUILD_DIR/pyproject.toml ]; then
    mv $BUILD_DIR/setup.py $BUILD_DIR/pyproject.toml
    cp $TESTS_DIR/setup.py $BUILD_DIR/setup.py
fi

# Compile module
cd $BUILD_DIR
python3.9 -m pip install build
python3.9 -m build --sdist --wheel --outdir build

# Run tests
echo "Running tests"
cd "$TESTS_DIR"
echo "Install requests..."
python3.9 -m pip install --user -U requests
echo "Install retry..."
python3.9 -m pip install --user -U retry
echo "Run unit tests"
python3.9 -m unittest SdkTests
