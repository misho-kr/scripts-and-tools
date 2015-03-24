#/bin/bash
# -----------------------------------------------------------
#  Install PyPy and set up the environment
# -----------------------------------------------------------

set -e
set -x

PYTHON_BIN=${HOME}/bin/python

LIB_NCURSES=/lib64/libncurses.so.5.9
LIB_TINFO=libtinfo.so.5

PYPY_TARFILE=${HOME}/pypy.tar.bz2

# -----------------------------------------------------------

EXTRACT_DIR=${HOME}/extract.dir

test -d ${EXTRACT_DIR} && rm -rf ${EXTRACT_DIR}
mkdir ${EXTRACT_DIR}

pushd ${EXTRACT_DIR}
tar -jxf ${PYPY_TARFILE}
mv pypy* pypy
mv pypy ${HOME} 
popd
rmdir ${EXTRACT_DIR}

rm -f ${PYPY_TARFILE}

# -----------------------------------------------------------

for d in ${HOME}/bin ${HOME}/pypy/lib; do
  test -d ${d} || mkdir -p ${d}
done

cat > ${PYTHON_BIN} <<EOF
#!/bin/bash
LD_LIBRARY_PATH=${HOME}/pypy/lib:${LD_LIBRARY_PATH} exec ${HOME}/pypy/bin/pypy "\$@"
EOF

chmod +x ${HOME}/bin/python

ln -snf ${LIB_NCURSES} ${HOME}/pypy/lib/${LIB_TINFO}

# -----------------------------------------------------------
# eof