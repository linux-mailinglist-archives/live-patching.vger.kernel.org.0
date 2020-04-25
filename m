Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71AC11B85F4
	for <lists+live-patching@lfdr.de>; Sat, 25 Apr 2020 13:08:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726126AbgDYLIp (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Sat, 25 Apr 2020 07:08:45 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:31892 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726101AbgDYLIo (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Sat, 25 Apr 2020 07:08:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587812923;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=3Vl9Snukidv/nh3jV4JLaaVbQqkBh6w70+8AM81+TZ8=;
        b=jUETAH5f3+s62v7ht7y2w3cMvYILeY/CMqqCj712GVE1zwN1Goi10485Hw19kUSTXGjW90
        BeeD8pF2J1l/Zp1741NxXg2+tPj5/lqWCTdfmx6FOLS7WLt+lRIJMM+t/U++a+AwA0yMo0
        lIV4EW51cqKVUc3Z0/XRj0AeaCjjcWo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-105-FyARu1wROJScseorMlweyA-1; Sat, 25 Apr 2020 07:08:37 -0400
X-MC-Unique: FyARu1wROJScseorMlweyA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A21B745F;
        Sat, 25 Apr 2020 11:08:36 +0000 (UTC)
Received: from treble.redhat.com (ovpn-114-29.rdu2.redhat.com [10.10.114.29])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BCB701ED;
        Sat, 25 Apr 2020 11:08:32 +0000 (UTC)
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     live-patching@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Jessica Yu <jeyu@kernel.org>,
        Joe Lawrence <joe.lawrence@redhat.com>
Subject: [PATCH v3 00/10] livepatch,module: Remove .klp.arch and module_disable_ro()
Date:   Sat, 25 Apr 2020 06:07:20 -0500
Message-Id: <cover.1587812518.git.jpoimboe@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Content-Transfer-Encoding: quoted-printable
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

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

- Add support for jump labels in patched code.

- Remove the last module_disable_ro() usage.

For more background, see this thread:

  https://lkml.kernel.org/r/20191021135312.jbbxsuipxldocdjk@treble

This has been tested with kpatch-build integration tests and klp-convert
selftests.

Josh Poimboeuf (7):
  livepatch: Disallow vmlinux.ko
  livepatch: Apply vmlinux-specific KLP relocations early
  livepatch: Prevent module-specific KLP rela sections from referencing
    vmlinux symbols
  s390: Change s390_kernel_write() return type to match memcpy()
  livepatch: Remove module_disable_ro() usage
  module: Remove module_disable_ro()
  x86/module: Use text_mutex in apply_relocate_add()

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
 include/linux/module.h                        |   2 -
 kernel/livepatch/core.c                       | 177 +++++++++++-------
 kernel/module.c                               |  23 +--
 12 files changed, 277 insertions(+), 228 deletions(-)
 delete mode 100644 arch/x86/kernel/livepatch.c

--=20
2.21.1

