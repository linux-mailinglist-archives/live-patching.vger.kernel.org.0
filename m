Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B97824B351E
	for <lists+live-patching@lfdr.de>; Sat, 12 Feb 2022 14:05:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235215AbiBLNFH (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Sat, 12 Feb 2022 08:05:07 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235157AbiBLNFF (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Sat, 12 Feb 2022 08:05:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BCF826543;
        Sat, 12 Feb 2022 05:05:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8498860E86;
        Sat, 12 Feb 2022 13:04:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7F25C340E7;
        Sat, 12 Feb 2022 13:04:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644671098;
        bh=v+g01wwGWAex++1H14Q1oSi8BHd4lI/w8GhNcGEtS6A=;
        h=From:To:Cc:Subject:Date:From;
        b=qC0NXLNKqYgXKlDzZDGNowkHQtBQO8wyF8dTxEdBUW61ZG9Ch7DdxlItr3qtWAUWc
         AkYr25CRoM8CGPTqNf6HqhUwxly6g949wZFvfILdaZ0xDGEVHc/g/q8MPhcaqjCBLu
         FdWV5Qy/iOSmfYFPhlKDcPHGbnZGIptjScdycsEnSIrXfxIhXx/fuF6oGD/66fjYVa
         nrRU2gpSRIjOU6YCNOiJR/Onu2saw3MjZw5DxPUvOHd+AFE7vyG/fy+NYK1UNhF82M
         OTJcSrZ9zXFZDHsTAv4EZTw93UxAlfx1L2ZrnwVaC36+4//nN5S1/dd7j4/ThaheTl
         2/VQpGuVKCtIw==
From:   Miguel Ojeda <ojeda@kernel.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
        Miguel Ojeda <ojeda@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
        linux-gpio@vger.kernel.org, linux-kbuild@vger.kernel.org,
        linux-perf-users@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-riscv@lists.infradead.org, live-patching@vger.kernel.org
Subject: [PATCH v4 00/20] Rust support
Date:   Sat, 12 Feb 2022 14:03:26 +0100
Message-Id: <20220212130410.6901-1-ojeda@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Rust support

This is the patch series (v4) to add support for Rust as a second
language to the Linux kernel.

If you are interested in following this effort, please join us in
the mailing list at:

    rust-for-linux@vger.kernel.org

and take a look at the project itself at:

    https://github.com/Rust-for-Linux

As usual, special thanks go to ISRG (Internet Security Research
Group) and Google for their financial support on this endeavor.

Cheers,
Miguel

--

# Rust support

This cover letter explains the major changes and updates done since
the previous ones. For those, please see:

    RFC: https://lore.kernel.org/lkml/20210414184604.23473-1-ojeda@kernel.org/
    v1:  https://lore.kernel.org/lkml/20210704202756.29107-1-ojeda@kernel.org/
    v2:  https://lore.kernel.org/lkml/20211206140313.5653-1-ojeda@kernel.org/
    v3:  https://lore.kernel.org/lkml/20220117053349.6804-1-ojeda@kernel.org/


## Infrastructure updates

There have been several improvements to the overall Rust support:

  - The Intel 0DAY/LKP kernel test robot is setting up Rust in their
    CI -- we already got the first reports from the bot which we
    could act upon, very useful!

  - KernelCI is also looking forward to enabling Rust in their runs.

  - The GitHub CI we use for quick pre-merge testing has been moved
    to use containers.

  - Kernel modules do not need to write the crate attributes
    `#![no_std]` and `#![feature(...)]` anymore, removing boilerplate.

  - Added single target support, including `.o`, `.s`, `.ll` and `.i`
    (i.e. macro expanded, similar to C preprocessed sources).

  - Explanation of the `helpers.c` file and licensing for helpers
    and exports.

  - The documentation logo is now vector based (SVG). In addition,
    a vector version of Tux has been proposed for upstream, and an
    RFC for improved custom logo support has been submitted to
    upstream Rust.

  - Added coding guidelines on comments (`//`) and code documentation
    (`///`).

  - `is_rust_module.sh` rework.

  - Generation of `.rmeta` for leaf modules is skipped now.

  - Other cleanups, fixes and improvements.


## Abstractions and driver updates

Some of the improvements to the abstractions and example drivers are:

  - Added support for static (global shared variables) synchronization
    primitives. `CONFIG_CONSTRUCTORS` are used for the implementation.

  - Simplification of the lock guards by using marker types, i.e.
    `Guard` and `GuardMut` are unified into a single parametrized
    type. If the marker is `WriteLock`, then `Guard` implements
    `DerefMut` (only implemented by `GuardMut` previously).

  - Optional parameters added to the registration of misc devices,
    following the builder pattern., e.g.

        miscdev::Options::new()
            .mode(0o600)
            .minor(10)
            .parent(parent)
            .register(reg, c_str!("sample"), ())

  - Added `RwSemaphore` abstraction that wraps the C side
    `struct rw_semaphore`.

  - New `mm` module and VMA abstraction (wrapping the C side
    `struct vm_area_struct`) for use with `mmap`.

  - GPIO PL061 now uses the recently added `dev_*!` Rust macros.

  - Support the `!CONFIG_PRINTK` case.

  - Other cleanups, fixes and improvements.


## Patch series status

The Rust support is still to be considered experimental. However,
support is good enough that kernel developers can start working on the
Rust abstractions for subsystems and write drivers and other modules.

The current series has just arrived in `linux-next`, as usual.
Similarly, the preview docs for this series can be seen at:

    https://rust-for-linux.github.io/docs/kernel/

As usual, please see the following link for the
live list of unstable Rust features we are using:

    https://github.com/Rust-for-Linux/linux/issues/2


## Acknowledgements

The signatures in the main commits correspond to the people that
wrote code that has ended up in them at the present time. For details
on contributions to code and discussions, please see our repository:

    https://github.com/Rust-for-Linux/linux

However, we would like to give credit to everyone that has contributed
in one way or another to the Rust for Linux project. Since the
previous cover letter:

  - Philip Li, Yujie Liu et. al. for setting the Intel 0DAY/LKP kernel
    test robot with Rust support.

  - Maciej Falkowski for continuing his work on the Hardware Random
    Number Generator subsystem, Samsung Exynos true random number
    generator, clock subsystem, etc.

  - bjorn3 for an extensive re-review of the previous round.

  - Jonathan Corbet for his feedback on the previous round.

  - Garrett LeSage and IFo Hancroft for agreeing to the usage of
    their vector version of Tux within the kernel tree with the same
    license as the existing one from Larry Ewing.

  - Nathan Chancellor for noticing a case where a C module was being
    identified as a Rust one for purposes of skipping BTF generation
    and suggesting a few improvements around `is_rust_module.sh`.

  - Wei Liu for exporting the remaining helpers and triggering a
    useful discussion around it.

  - Miguel Cano for fixing an issue with compilers containing a full,
    3-part version in the suffix part (e.g. Ubuntu Clang).

  - Abhik Jain for working on adding missing `// SAFETY` comments and
    `# Safety` sections to the code generated by the `module!` macro.

  - Jiapeng Chong and the Abaci Robot for reporting and fixing
    an unneeded header `#include`.

  - Finn Behrens for resuming his work on building Rust for Linux
    on Nix and spotting and fixing usability issues.

  - As usual, Gary Guo and bjorn3 for all the input on Rust compiler
    details and all the reviews and suggestions.

  - John Ericson, TennyZhuang and Xuanwo for their ongoing work on
    adding more fallible allocation methods (`try_*`) to the Rust
    standard library.

  - Stephan Sokolow and Mark Rousskov for their feedback on the
    custom documentation logo RFC.

  - Philip Herrons (and his supporters Open Source Security and
    Embecosm) et. al. for their ongoing work on GCC Rust.

  - Antoni Boucher (and his supporters) et. al. for their ongoing
    work on `rustc_codegen_gcc`.

  - Mats Larsen, Marc Poulhiès et. al. for their ongoing work on
    improving Rust support in Compiler Explorer.

  - Many folks that have reported issues, tested the project,
    helped spread the word, joined discussions and contributed in
    other ways!

Please see also the acknowledgements on the previous cover letters.

Boqun Feng (1):
  kallsyms: use the correct buffer size for symbols

Gary Guo (2):
  rust: add `build_error` crate
  vsprintf: add new `%pA` format specifier

Miguel Ojeda (13):
  kallsyms: support "big" kernel symbols
  kallsyms: increase maximum kernel symbol length to 512
  rust: add C helpers
  rust: add `compiler_builtins` crate
  rust: add `alloc` crate
  rust: add `macros` crate
  rust: export generated symbols
  scripts: add `generate_rust_analyzer.py`
  scripts: decode_stacktrace: demangle Rust symbols
  docs: add Rust documentation
  Kbuild: add Rust support
  samples: add Rust examples
  MAINTAINERS: Rust

Wedson Almeida Filho (4):
  rust: add `kernel` crate's `sync` module
  rust: add `kernel` crate
  [RFC] drivers: gpio: PrimeCell PL061 in Rust
  [RFC] drivers: android: Binder IPC in Rust

 .gitignore                                   |    5 +
 .rustfmt.toml                                |   12 +
 Documentation/doc-guide/kernel-doc.rst       |    3 +
 Documentation/index.rst                      |    1 +
 Documentation/kbuild/kbuild.rst              |    4 +
 Documentation/process/changes.rst            |   42 +
 Documentation/rust/arch-support.rst          |   35 +
 Documentation/rust/coding-guidelines.rst     |  153 +
 Documentation/rust/general-information.rst   |   80 +
 Documentation/rust/index.rst                 |   21 +
 Documentation/rust/logo.svg                  |  357 ++
 Documentation/rust/quick-start.rst           |  231 ++
 MAINTAINERS                                  |   16 +
 Makefile                                     |  154 +-
 arch/arm/rust/target.json                    |   27 +
 arch/arm64/rust/target.json                  |   34 +
 arch/powerpc/rust/target.json                |   29 +
 arch/riscv/Makefile                          |    1 +
 arch/riscv/rust/rv32ima.json                 |   36 +
 arch/riscv/rust/rv32imac.json                |   36 +
 arch/riscv/rust/rv64ima.json                 |   36 +
 arch/riscv/rust/rv64imac.json                |   36 +
 arch/x86/rust/target.json                    |   36 +
 drivers/android/Kconfig                      |    7 +
 drivers/android/Makefile                     |    2 +
 drivers/android/allocation.rs                |  266 ++
 drivers/android/context.rs                   |   80 +
 drivers/android/defs.rs                      |   99 +
 drivers/android/node.rs                      |  476 +++
 drivers/android/process.rs                   |  961 +++++
 drivers/android/range_alloc.rs               |  189 +
 drivers/android/rust_binder.rs               |  111 +
 drivers/android/thread.rs                    |  871 +++++
 drivers/android/transaction.rs               |  326 ++
 drivers/gpio/Kconfig                         |    8 +
 drivers/gpio/Makefile                        |    1 +
 drivers/gpio/gpio_pl061_rust.rs              |  370 ++
 include/linux/kallsyms.h                     |    2 +-
 include/linux/spinlock.h                     |   17 +-
 include/uapi/linux/android/binder.h          |   28 +-
 init/Kconfig                                 |   45 +-
 kernel/kallsyms.c                            |   26 +-
 kernel/livepatch/core.c                      |    4 +-
 kernel/printk/printk.c                       |    5 +-
 lib/Kconfig.debug                            |  144 +
 lib/rust.h                                   |   14 +
 lib/vsprintf.c                               |    7 +
 rust/.gitignore                              |    7 +
 rust/Makefile                                |  374 ++
 rust/alloc/README.md                         |   32 +
 rust/alloc/alloc.rs                          |  427 +++
 rust/alloc/borrow.rs                         |  498 +++
 rust/alloc/boxed.rs                          | 1847 ++++++++++
 rust/alloc/collections/mod.rs                |  156 +
 rust/alloc/fmt.rs                            |  601 ++++
 rust/alloc/lib.rs                            |  217 ++
 rust/alloc/macros.rs                         |  126 +
 rust/alloc/raw_vec.rs                        |  549 +++
 rust/alloc/slice.rs                          | 1279 +++++++
 rust/alloc/str.rs                            |  624 ++++
 rust/alloc/string.rs                         | 2864 +++++++++++++++
 rust/alloc/vec/drain.rs                      |  159 +
 rust/alloc/vec/drain_filter.rs               |  145 +
 rust/alloc/vec/into_iter.rs                  |  356 ++
 rust/alloc/vec/is_zero.rs                    |  106 +
 rust/alloc/vec/mod.rs                        | 3359 ++++++++++++++++++
 rust/alloc/vec/partial_eq.rs                 |   49 +
 rust/alloc/vec/set_len_on_drop.rs            |   30 +
 rust/alloc/vec/spec_extend.rs                |  172 +
 rust/bindgen_parameters                      |   13 +
 rust/build_error.rs                          |   29 +
 rust/compiler_builtins.rs                    |   57 +
 rust/exports.c                               |   19 +
 rust/helpers.c                               |  529 +++
 rust/kernel/allocator.rs                     |   65 +
 rust/kernel/amba.rs                          |  259 ++
 rust/kernel/bindings.rs                      |   47 +
 rust/kernel/bindings_helper.h                |   30 +
 rust/kernel/buffer.rs                        |   52 +
 rust/kernel/build_assert.rs                  |   80 +
 rust/kernel/c_types.rs                       |  119 +
 rust/kernel/chrdev.rs                        |  209 ++
 rust/kernel/clk.rs                           |   75 +
 rust/kernel/cred.rs                          |   73 +
 rust/kernel/device.rs                        |  554 +++
 rust/kernel/driver.rs                        |  440 +++
 rust/kernel/error.rs                         |  542 +++
 rust/kernel/file.rs                          |  147 +
 rust/kernel/file_operations.rs               |  734 ++++
 rust/kernel/gpio.rs                          |  477 +++
 rust/kernel/io_buffer.rs                     |  153 +
 rust/kernel/io_mem.rs                        |  227 ++
 rust/kernel/iov_iter.rs                      |   81 +
 rust/kernel/irq.rs                           |  409 +++
 rust/kernel/lib.rs                           |  261 ++
 rust/kernel/linked_list.rs                   |  247 ++
 rust/kernel/miscdev.rs                       |  281 ++
 rust/kernel/mm.rs                            |  149 +
 rust/kernel/module_param.rs                  |  497 +++
 rust/kernel/of.rs                            |   63 +
 rust/kernel/pages.rs                         |  144 +
 rust/kernel/platform.rs                      |  224 ++
 rust/kernel/power.rs                         |  118 +
 rust/kernel/prelude.rs                       |   36 +
 rust/kernel/print.rs                         |  417 +++
 rust/kernel/random.rs                        |   50 +
 rust/kernel/raw_list.rs                      |  361 ++
 rust/kernel/rbtree.rs                        |  562 +++
 rust/kernel/revocable.rs                     |  163 +
 rust/kernel/security.rs                      |   36 +
 rust/kernel/static_assert.rs                 |   39 +
 rust/kernel/std_vendor.rs                    |  150 +
 rust/kernel/str.rs                           |  401 +++
 rust/kernel/sync/arc.rs                      |  500 +++
 rust/kernel/sync/condvar.rs                  |  138 +
 rust/kernel/sync/guard.rs                    |  150 +
 rust/kernel/sync/locked_by.rs                |  112 +
 rust/kernel/sync/mod.rs                      |  157 +
 rust/kernel/sync/mutex.rs                    |  112 +
 rust/kernel/sync/revocable_mutex.rs          |  184 +
 rust/kernel/sync/rwsem.rs                    |  147 +
 rust/kernel/sync/seqlock.rs                  |  202 ++
 rust/kernel/sync/spinlock.rs                 |  180 +
 rust/kernel/sysctl.rs                        |  197 +
 rust/kernel/task.rs                          |  182 +
 rust/kernel/types.rs                         |  486 +++
 rust/kernel/user_ptr.rs                      |  175 +
 rust/macros/helpers.rs                       |   79 +
 rust/macros/lib.rs                           |   94 +
 rust/macros/module.rs                        |  631 ++++
 samples/Kconfig                              |    2 +
 samples/Makefile                             |    1 +
 samples/rust/Kconfig                         |  123 +
 samples/rust/Makefile                        |   13 +
 samples/rust/rust_chrdev.rs                  |   50 +
 samples/rust/rust_minimal.rs                 |   35 +
 samples/rust/rust_miscdev.rs                 |  144 +
 samples/rust/rust_module_parameters.rs       |   69 +
 samples/rust/rust_platform.rs                |   22 +
 samples/rust/rust_print.rs                   |   54 +
 samples/rust/rust_random.rs                  |   61 +
 samples/rust/rust_semaphore.rs               |  172 +
 samples/rust/rust_semaphore_c.c              |  212 ++
 samples/rust/rust_stack_probing.rs           |   36 +
 samples/rust/rust_sync.rs                    |   78 +
 scripts/Kconfig.include                      |    6 +-
 scripts/Makefile.build                       |   65 +
 scripts/Makefile.debug                       |   10 +
 scripts/Makefile.lib                         |   12 +
 scripts/Makefile.modfinal                    |    8 +-
 scripts/cc-version.sh                        |   12 +-
 scripts/decode_stacktrace.sh                 |   14 +
 scripts/generate_rust_analyzer.py            |  133 +
 scripts/is_rust_module.sh                    |   13 +
 scripts/kallsyms.c                           |   40 +-
 scripts/kconfig/confdata.c                   |   75 +
 scripts/min-tool-version.sh                  |    6 +
 scripts/rust-is-available-bindgen-libclang.h |    2 +
 scripts/rust-is-available.sh                 |  158 +
 tools/include/linux/kallsyms.h               |    2 +-
 tools/lib/perf/include/perf/event.h          |    2 +-
 tools/lib/symbol/kallsyms.h                  |    2 +-
 162 files changed, 34341 insertions(+), 57 deletions(-)
 create mode 100644 .rustfmt.toml
 create mode 100644 Documentation/rust/arch-support.rst
 create mode 100644 Documentation/rust/coding-guidelines.rst
 create mode 100644 Documentation/rust/general-information.rst
 create mode 100644 Documentation/rust/index.rst
 create mode 100644 Documentation/rust/logo.svg
 create mode 100644 Documentation/rust/quick-start.rst
 create mode 100644 arch/arm/rust/target.json
 create mode 100644 arch/arm64/rust/target.json
 create mode 100644 arch/powerpc/rust/target.json
 create mode 100644 arch/riscv/rust/rv32ima.json
 create mode 100644 arch/riscv/rust/rv32imac.json
 create mode 100644 arch/riscv/rust/rv64ima.json
 create mode 100644 arch/riscv/rust/rv64imac.json
 create mode 100644 arch/x86/rust/target.json
 create mode 100644 drivers/android/allocation.rs
 create mode 100644 drivers/android/context.rs
 create mode 100644 drivers/android/defs.rs
 create mode 100644 drivers/android/node.rs
 create mode 100644 drivers/android/process.rs
 create mode 100644 drivers/android/range_alloc.rs
 create mode 100644 drivers/android/rust_binder.rs
 create mode 100644 drivers/android/thread.rs
 create mode 100644 drivers/android/transaction.rs
 create mode 100644 drivers/gpio/gpio_pl061_rust.rs
 create mode 100644 lib/rust.h
 create mode 100644 rust/.gitignore
 create mode 100644 rust/Makefile
 create mode 100644 rust/alloc/README.md
 create mode 100644 rust/alloc/alloc.rs
 create mode 100644 rust/alloc/borrow.rs
 create mode 100644 rust/alloc/boxed.rs
 create mode 100644 rust/alloc/collections/mod.rs
 create mode 100644 rust/alloc/fmt.rs
 create mode 100644 rust/alloc/lib.rs
 create mode 100644 rust/alloc/macros.rs
 create mode 100644 rust/alloc/raw_vec.rs
 create mode 100644 rust/alloc/slice.rs
 create mode 100644 rust/alloc/str.rs
 create mode 100644 rust/alloc/string.rs
 create mode 100644 rust/alloc/vec/drain.rs
 create mode 100644 rust/alloc/vec/drain_filter.rs
 create mode 100644 rust/alloc/vec/into_iter.rs
 create mode 100644 rust/alloc/vec/is_zero.rs
 create mode 100644 rust/alloc/vec/mod.rs
 create mode 100644 rust/alloc/vec/partial_eq.rs
 create mode 100644 rust/alloc/vec/set_len_on_drop.rs
 create mode 100644 rust/alloc/vec/spec_extend.rs
 create mode 100644 rust/bindgen_parameters
 create mode 100644 rust/build_error.rs
 create mode 100644 rust/compiler_builtins.rs
 create mode 100644 rust/exports.c
 create mode 100644 rust/helpers.c
 create mode 100644 rust/kernel/allocator.rs
 create mode 100644 rust/kernel/amba.rs
 create mode 100644 rust/kernel/bindings.rs
 create mode 100644 rust/kernel/bindings_helper.h
 create mode 100644 rust/kernel/buffer.rs
 create mode 100644 rust/kernel/build_assert.rs
 create mode 100644 rust/kernel/c_types.rs
 create mode 100644 rust/kernel/chrdev.rs
 create mode 100644 rust/kernel/clk.rs
 create mode 100644 rust/kernel/cred.rs
 create mode 100644 rust/kernel/device.rs
 create mode 100644 rust/kernel/driver.rs
 create mode 100644 rust/kernel/error.rs
 create mode 100644 rust/kernel/file.rs
 create mode 100644 rust/kernel/file_operations.rs
 create mode 100644 rust/kernel/gpio.rs
 create mode 100644 rust/kernel/io_buffer.rs
 create mode 100644 rust/kernel/io_mem.rs
 create mode 100644 rust/kernel/iov_iter.rs
 create mode 100644 rust/kernel/irq.rs
 create mode 100644 rust/kernel/lib.rs
 create mode 100644 rust/kernel/linked_list.rs
 create mode 100644 rust/kernel/miscdev.rs
 create mode 100644 rust/kernel/mm.rs
 create mode 100644 rust/kernel/module_param.rs
 create mode 100644 rust/kernel/of.rs
 create mode 100644 rust/kernel/pages.rs
 create mode 100644 rust/kernel/platform.rs
 create mode 100644 rust/kernel/power.rs
 create mode 100644 rust/kernel/prelude.rs
 create mode 100644 rust/kernel/print.rs
 create mode 100644 rust/kernel/random.rs
 create mode 100644 rust/kernel/raw_list.rs
 create mode 100644 rust/kernel/rbtree.rs
 create mode 100644 rust/kernel/revocable.rs
 create mode 100644 rust/kernel/security.rs
 create mode 100644 rust/kernel/static_assert.rs
 create mode 100644 rust/kernel/std_vendor.rs
 create mode 100644 rust/kernel/str.rs
 create mode 100644 rust/kernel/sync/arc.rs
 create mode 100644 rust/kernel/sync/condvar.rs
 create mode 100644 rust/kernel/sync/guard.rs
 create mode 100644 rust/kernel/sync/locked_by.rs
 create mode 100644 rust/kernel/sync/mod.rs
 create mode 100644 rust/kernel/sync/mutex.rs
 create mode 100644 rust/kernel/sync/revocable_mutex.rs
 create mode 100644 rust/kernel/sync/rwsem.rs
 create mode 100644 rust/kernel/sync/seqlock.rs
 create mode 100644 rust/kernel/sync/spinlock.rs
 create mode 100644 rust/kernel/sysctl.rs
 create mode 100644 rust/kernel/task.rs
 create mode 100644 rust/kernel/types.rs
 create mode 100644 rust/kernel/user_ptr.rs
 create mode 100644 rust/macros/helpers.rs
 create mode 100644 rust/macros/lib.rs
 create mode 100644 rust/macros/module.rs
 create mode 100644 samples/rust/Kconfig
 create mode 100644 samples/rust/Makefile
 create mode 100644 samples/rust/rust_chrdev.rs
 create mode 100644 samples/rust/rust_minimal.rs
 create mode 100644 samples/rust/rust_miscdev.rs
 create mode 100644 samples/rust/rust_module_parameters.rs
 create mode 100644 samples/rust/rust_platform.rs
 create mode 100644 samples/rust/rust_print.rs
 create mode 100644 samples/rust/rust_random.rs
 create mode 100644 samples/rust/rust_semaphore.rs
 create mode 100644 samples/rust/rust_semaphore_c.c
 create mode 100644 samples/rust/rust_stack_probing.rs
 create mode 100644 samples/rust/rust_sync.rs
 create mode 100755 scripts/generate_rust_analyzer.py
 create mode 100755 scripts/is_rust_module.sh
 create mode 100644 scripts/rust-is-available-bindgen-libclang.h
 create mode 100755 scripts/rust-is-available.sh


base-commit: dfd42facf1e4ada021b939b4e19c935dcdd55566
-- 
2.35.1

