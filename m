Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BBC11BE28D
	for <lists+live-patching@lfdr.de>; Wed, 29 Apr 2020 17:25:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727103AbgD2PZP (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 29 Apr 2020 11:25:15 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:41942 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727030AbgD2PZP (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 29 Apr 2020 11:25:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588173914;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=idVKSiABjSNcmACNvJ+0e2upfnSy5o5PlTD947BRr1Y=;
        b=Rkh5LCfZPmazla0dA6RqAeeseD0j36j67oI8ifDaY9F5JLPvh77LTnfRh1gor7qRXW+PIr
        MZOiPRODwgLXC3Xc1ER2acnkHgPMzUj+ARrtXvoEunpc+HoknYy910EfyI2mSvZMNc5mHa
        cvacIMfcT3DBDphP8n047/6qZbZ/a9A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-69-w8wnoM3MPJ6qwrUmSm7-hA-1; Wed, 29 Apr 2020 11:25:10 -0400
X-MC-Unique: w8wnoM3MPJ6qwrUmSm7-hA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 68C7C8F294B;
        Wed, 29 Apr 2020 15:25:01 +0000 (UTC)
Received: from treble.redhat.com (ovpn-113-19.rdu2.redhat.com [10.10.113.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C383A605CB;
        Wed, 29 Apr 2020 15:24:57 +0000 (UTC)
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     live-patching@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Jessica Yu <jeyu@kernel.org>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>
Subject: [PATCH v4 00/11] livepatch,module: Remove .klp.arch and module_disable_ro()
Date:   Wed, 29 Apr 2020 10:24:42 -0500
Message-Id: <cover.1588173720.git.jpoimboe@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Content-Transfer-Encoding: quoted-printable
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

v4:
- Fixed rebase bisection regression [Miroslav]
- Made module_enable_ro() static [Jessica]
- Added Acked-by's

v3:
- klp: split klp_write_relocations() into object/section specific
  functions [joe]
- s390: fix plt/got writes [joe]
- s390: remove text_mutex usage [mbenes]
- x86: do text_poke_sync() before releasing text_mutex [peterz]
- split x86 text_mutex changes into separate patch [mbenes]

v2:
- add vmlinux.ko check [peterz]
- remove 'klp_object' forward declaration [mbenes]
- use text_mutex [jeyu]
- fix documentation TOC [jeyu]
- fix s390 issues [mbenes]
- upstream kpatch-build now supports this
  (though it's only enabled for Linux >=3D 5.8)

These patches add simplifications and improvements for some issues Peter
found six months ago, as part of his non-writable text code (W^X)
cleanups.

Highlights:

- Remove the livepatch arch-specific .klp.arch sections, which were used
  to do paravirt patching and alternatives patching for livepatch
  replacement code.

- Add support for jump labels in patched code (only for static keys
  which live in vmlinux).

- Remove the last module_disable_ro() usage.

For more background, see this thread:

  https://lkml.kernel.org/r/20191021135312.jbbxsuipxldocdjk@treble

This has been tested with kpatch-build integration tests and klp-convert
selftests.


Josh Poimboeuf (8):
  livepatch: Disallow vmlinux.ko
  livepatch: Apply vmlinux-specific KLP relocations early
  livepatch: Prevent module-specific KLP rela sections from referencing
    vmlinux symbols
  s390: Change s390_kernel_write() return type to match memcpy()
  livepatch: Remove module_disable_ro() usage
  module: Remove module_disable_ro()
  x86/module: Use text_mutex in apply_relocate_add()
  module: Make module_enable_ro() static again

Peter Zijlstra (3):
  livepatch: Remove .klp.arch
  s390/module: Use s390_kernel_write() for late relocations
  x86/module: Use text_poke() for late relocations

 Documentation/livepatch/module-elf-format.rst |  15 +-
 arch/s390/include/asm/uaccess.h               |   2 +-
 arch/s390/kernel/module.c                     | 147 +++++++++------
 arch/s390/mm/maccess.c                        |   9 +-
 arch/um/kernel/um_arch.c                      |  16 ++
 arch/x86/kernel/Makefile                      |   1 -
 arch/x86/kernel/livepatch.c                   |  53 ------
 arch/x86/kernel/module.c                      |  43 ++++-
 include/linux/livepatch.h                     |  17 +-
 include/linux/module.h                        |   8 -
 kernel/livepatch/core.c                       | 177 +++++++++++-------
 kernel/module.c                               |  27 +--
 12 files changed, 279 insertions(+), 236 deletions(-)
 delete mode 100644 arch/x86/kernel/livepatch.c

--=20
2.21.1

