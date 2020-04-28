Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC9C11BC021
	for <lists+live-patching@lfdr.de>; Tue, 28 Apr 2020 15:49:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727843AbgD1NtB (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 28 Apr 2020 09:49:01 -0400
Received: from mx2.suse.de ([195.135.220.15]:58844 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726798AbgD1NtA (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Tue, 28 Apr 2020 09:49:00 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id CF97AAD4B;
        Tue, 28 Apr 2020 13:48:57 +0000 (UTC)
Date:   Tue, 28 Apr 2020 15:48:58 +0200 (CEST)
From:   Miroslav Benes <mbenes@suse.cz>
To:     Josh Poimboeuf <jpoimboe@redhat.com>
cc:     live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Jessica Yu <jeyu@kernel.org>,
        Joe Lawrence <joe.lawrence@redhat.com>
Subject: Re: [PATCH v3 00/10] livepatch,module: Remove .klp.arch and
 module_disable_ro()
In-Reply-To: <cover.1587812518.git.jpoimboe@redhat.com>
Message-ID: <alpine.LSU.2.21.2004281541420.6376@pobox.suse.cz>
References: <cover.1587812518.git.jpoimboe@redhat.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Sat, 25 Apr 2020, Josh Poimboeuf wrote:

> v3:
> - klp: split klp_write_relocations() into object/section specific
>   functions [joe]
> - s390: fix plt/got writes [joe]
> - s390: remove text_mutex usage [mbenes]
> - x86: do text_poke_sync() before releasing text_mutex [peterz]
> - split x86 text_mutex changes into separate patch [mbenes]
> 
> v2:
> - add vmlinux.ko check [peterz]
> - remove 'klp_object' forward declaration [mbenes]
> - use text_mutex [jeyu]
> - fix documentation TOC [jeyu]
> - fix s390 issues [mbenes]
> - upstream kpatch-build now supports this
>   (though it's only enabled for Linux >= 5.8)
> 
> These patches add simplifications and improvements for some issues Peter
> found six months ago, as part of his non-writable text code (W^X)
> cleanups.
> 
> Highlights:
> 
> - Remove the livepatch arch-specific .klp.arch sections, which were used
>   to do paravirt patching and alternatives patching for livepatch
>   replacement code.
> 
> - Add support for jump labels in patched code.
> 
> - Remove the last module_disable_ro() usage.
> 
> For more background, see this thread:
> 
>   https://lkml.kernel.org/r/20191021135312.jbbxsuipxldocdjk@treble
> 
> This has been tested with kpatch-build integration tests and klp-convert
> selftests.
> 
> Josh Poimboeuf (7):
>   livepatch: Disallow vmlinux.ko
>   livepatch: Apply vmlinux-specific KLP relocations early
>   livepatch: Prevent module-specific KLP rela sections from referencing
>     vmlinux symbols
>   s390: Change s390_kernel_write() return type to match memcpy()
>   livepatch: Remove module_disable_ro() usage
>   module: Remove module_disable_ro()
>   x86/module: Use text_mutex in apply_relocate_add()
> 
> Peter Zijlstra (3):
>   livepatch: Remove .klp.arch
>   s390/module: Use s390_kernel_write() for late relocations
>   x86/module: Use text_poke() for late relocations
> 
>  Documentation/livepatch/module-elf-format.rst |  15 +-
>  arch/s390/include/asm/uaccess.h               |   2 +-
>  arch/s390/kernel/module.c                     | 147 +++++++++------
>  arch/s390/mm/maccess.c                        |   9 +-
>  arch/um/kernel/um_arch.c                      |  16 ++
>  arch/x86/kernel/Makefile                      |   1 -
>  arch/x86/kernel/livepatch.c                   |  53 ------
>  arch/x86/kernel/module.c                      |  43 ++++-
>  include/linux/livepatch.h                     |  17 +-
>  include/linux/module.h                        |   2 -
>  kernel/livepatch/core.c                       | 177 +++++++++++-------
>  kernel/module.c                               |  23 +--
>  12 files changed, 277 insertions(+), 228 deletions(-)
>  delete mode 100644 arch/x86/kernel/livepatch.c

With the small issue in patch 2 fixed

Acked-by: Miroslav Benes <mbenes@suse.cz>

Great stuff. I am happy we will get rid of the arch-specific code.

M
