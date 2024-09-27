# Package

version       = "0.4.0"
author        = "metagn"
description   = "generalized routine and symbol pointers"
license       = "MIT"
srcDir        = "src"

# Dependencies

requires "nim >= 0.20.0"

when (NimMajor, NimMinor) >= (1, 4):
  when (compiles do: import nimbleutils):
    import nimbleutils
    # https://github.com/metagn/nimbleutils

task docs, "build docs for all modules":
  when declared(buildDocs):
    buildDocs(gitUrl = "https://github.com/metagn/applicates")
  else:
    echo "docs task not implemented, need nimbleutils"

import os

task tests, "run tests for multiple backends and defines":
  when declared(runTests):
    var tests: seq[string] = @[]
    for fn in walkDirRec("tests", followFilter = {}):
      if (let (_, name, ext) = splitFile(fn);
        name[0] == 't' and ext == ".nim"):
        if name == "test_iterator_typed" and (NimMajor, NimMinor) == (2, 0):
          # broken on 2.0
          continue
        tests.add(fn)
    runTests(tests,
      backends = {c, nims}, 
      optionCombos = @[
        "",
        "-d:applicatesCacheUseTable"]
    )
  else:
    echo "tests task not implemented, need nimbleutils"
