#!/usr/bin/env python3

import argparse
import os
import subprocess


CLANG = 'clang++-4.0'
LLC = '../llvm-build/bin/llc'
VERSION = '0.1.0'


def main():
    parser = argparse.ArgumentParser(
        prog='CFC',
        description='CFC - a C FRISC Compiler\n'
                    ' is a Clang & LLVM-based C/C++ compiler for the FRISC processor\n\n'
                    'Version: %s\n' % VERSION,
        epilog='')

    parser.add_argument('--version', action='version', version=('%%(prog)s %s') % VERSION)
    # parser.add_argument('-o', '--output-file', default='a.out', description='Write output to file')
    # parser.add_argument('-S', '--assemble-only', action='store_true', description='Produce assembly results instead of executable object code')
    parser.add_argument('-O', '--optimization-level', type=int, default=0, help='Optimization level (0-3), higher levels mean more optimized code, 0 means no optimization at all')
    parser.add_argument('-D', '--define-macro', action='append', )
    parser.add_argument('files', nargs='+')

    args = parser.parse_args()

    defines = ['-D%s' % macro for macro in args.define_macro] if args.define_macro else []
    ll_files = ['%s.ll' % file.rsplit('.', maxsplit=1)[0] for file in args.files]

    clang_cmd = [CLANG, '-nostdlib', '-emit-llvm', '-m32', '-S', '-O%d' % args.optimization_level] + defines + args.files

    try:
        subprocess.run(clang_cmd, check=True)

        for ll_file in ll_files:
            llc_cmd = [LLC, '-march=frisc', ll_file]
            subprocess.run(llc_cmd, check=True)
            os.remove(ll_file)

        print('All files successfuly compiled')
    except subprocess.CalledProcessError:
        print('Could not compile the given inputs, errors occurred.')


if __name__ == '__main__':
    main()
