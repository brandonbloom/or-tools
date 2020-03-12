{
  "targets": [
    {
      "target_name": "linear_solver",
      "sources": [ "ortools/gen/ortools/linear_solver/linear_solver_javascript_wrap.cc" ],
      "include_dirs": [
        "./ortools/gen",
        ".",
        "dependencies/install/include"
      ],
      'libraries': [
        "-Wl,-rpath,<(module_root_dir)/lib",
        "<(module_root_dir)/lib/libortools.dylib"
      ],
      'conditions': [
        ['OS=="linux" or OS=="freebsd" or OS=="openbsd" or OS=="solaris"', {
          'cflags_cc!': ['-fno-rtti'],
          'cflags_cc+': ['-frtti'],
        }],
        ['OS=="mac"', {
          'xcode_settings': {
            'GCC_ENABLE_CPP_RTTI': 'YES'
          }
        }]
      ]
    }
  ]
}
