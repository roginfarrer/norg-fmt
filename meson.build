# Set project
project('norg-fmt', 'cpp',
  license : 'GPLv3',
  version : '0.1.0a',
  meson_version : '>=0.53',
  default_options : ['warning_level=2',
                     'cpp_std=c++17'])

# Import meson modules
fs = import('fs')

# Add C to the project languages
# Required by:
# - bundled tree-sitter
# - tree-sitter norg parsers
add_languages('c')

# {{{ Third-party dependencies
# Path to third-party dependencies
third_party_path = 'third-party'

# Git
git_exe = find_program('git')

# {{{ Tree-Sitter
tree_sitter = dependency('tree-sitter')
if get_option('USE_BUNDLED_TREESITTER') or not tree_sitter.found()
  message('Use bundled tree-sitter')
  tree_sitter_path =join_paths(third_party_path, 'tree-sitter') 
  if not git_exe.found()
    error('Cannot use tree-sitter library. Install git, so it can be downloaded')
  endif

  TS_SHA = 'ccd6bf554d922596ce905730d98a77af368bba5c'
  TS_BRA = 'master'

  if not fs.is_dir(tree_sitter_path)
    message('Cloning tree-sitter "' + TS_BRA + '" branch, commit "' + TS_SHA + '", into ' + tree_sitter_path)
    git_cmd = 'clone -b @0@ https://github.com/tree-sitter/tree-sitter.git @1@'.format(TS_BRA, tree_sitter_path)
    clone_cmd = run_command(git_exe, git_cmd.split(), capture: true, check: true)
    if clone_cmd.returncode() != 0
      error('Cannot execute git clone command')
    endif
  else
    message('Found "tree-sitter" dependency in ' + tree_sitter_path + ' directory, skipping cloning step ...')
  endif

  tree_sitter_files = [
    join_paths(tree_sitter_path, 'lib/src/lib.c'),
  ]
  tree_sitter_inc = [
    include_directories(join_paths(tree_sitter_path, 'lib/src')),
    include_directories(join_paths(tree_sitter_path, 'lib/include'))
  ]
  libtree_sitter = static_library('tree_sitter', tree_sitter_files,
    include_directories: tree_sitter_inc,
    implicit_include_directories: false,
  )
  tree_sitter = declare_dependency(
    link_with: libtree_sitter,
    include_directories: tree_sitter_inc
  )
else
  message('Use system-provided tree-sitter library')
endif
# }}}

# {{{ Neorg Tree-Sitter parsers
tree_sitter_norg_path = join_paths(third_party_path, 'tree-sitter-norg')
if not fs.is_dir(tree_sitter_norg_path)
  if not git_exe.found()
    error('Cannot sync tree-sitter-norg parser. Install git, so it can be downloaded')
  endif

  TS_NORG_SHA = '17d61df817c1e0a9cdef8d915d4e4c556b7cf68c'
  TS_NORG_BRA = 'main'

  message('Cloning tree-sitter-norg "' + TS_NORG_BRA + '" branch, commit "' + TS_NORG_SHA +
    '", into ' + tree_sitter_norg_path)
  git_cmd = 'clone -b @0@ https://github.com/nvim-neorg/tree-sitter-norg.git @1@'.format(
    TS_NORG_BRA, tree_sitter_norg_path)
  clone_cmd = run_command(git_exe, git_cmd.split(), capture: true, check: true)
  if clone_cmd.returncode() != 0
    error('Cannot execute git clone command')
  endif
else
  message('Found "tree-sitter-norg" dependency in ' +
    tree_sitter_norg_path + ' directory, skipping cloning step ...')
endif

tree_sitter_norg_files = [
  join_paths(tree_sitter_norg_path, 'src/parser.c'),
  join_paths(tree_sitter_norg_path, 'src/scanner.cc')
]
libtree_sitter_norg = static_library('tree_sitter_norg', tree_sitter_norg_files)
tree_sitter_norg = declare_dependency(
  link_with: libtree_sitter_norg
)
# }}}

# {{{ Rang
rang_path = join_paths(third_party_path, 'rang')
rang_inc_path = join_paths(rang_path, 'include')
if not fs.is_dir(rang_path)
  if not git_exe.found()
    error('Cannot sync rang library. Install git, so it can be downloaded')
  endif

  RANG_SHA = 'a083cae9d64edd66d0ecdd4ddebac20d090c8693'
  RANG_BRA = 'master'

  message('Cloning rang "' + RANG_BRA + '" branch, commit "' + RANG_SHA + '", into ' + rang_path)
  git_cmd = 'clone -b @0@ https://github.com/agauniyal/rang.git @1@'.format(RANG_BRA, rang_path)
  clone_cmd = run_command(git_exe, git_cmd.split(), capture: true, check: true)
  if clone_cmd.returncode() != 0
    error('Cannot execute git clone command')
  endif
else
  message('Found "rang" dependency in ' + rang_path + ' directory, skipping cloning step ...')
endif

rang_inc = [include_directories(rang_inc_path)]
rang = declare_dependency(
  include_directories: rang_inc
)
# }}}

# {{{ Argparse
argparse_path = join_paths(third_party_path, 'argparse') 
if not fs.is_dir(argparse_path)
  if not git_exe.found()
    error('Cannot sync argparse library. Install git, so it can be downloaded')
  endif

  AP_SHA = 'c20621489d425145a6327715d7e3411a04f920a3'
  AP_BRA = 'master'

  message('Cloning argparse "' + AP_BRA + '" branch, commit "' + AP_SHA + '", into ' + argparse_path)
  git_cmd = 'clone -b @0@ https://github.com/p-ranav/argparse.git @1@'.format(AP_BRA, argparse_path)
  clone_cmd = run_command(git_exe, git_cmd.split(), capture: true, check: true)
  if clone_cmd.returncode() != 0
    error('Cannot execute git clone command')
  endif
else
  message('Found "argparse" dependency in ' + argparse_path + ' directory, skipping cloning step ...')
endif

argparse_inc = [include_directories(join_paths(argparse_path, 'include'))]
argparse = declare_dependency(
  include_directories: argparse_inc
)
# }}}
# }}}

# Set executable
subdir('src')
exe = executable('norg-fmt', sources,
  dependencies : [rang, argparse, tree_sitter, tree_sitter_norg],
  install : true)

# Test executable
test('basic', exe)

# vim: fdm=marker
