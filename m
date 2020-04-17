Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 005B31ADF12
	for <lists+live-patching@lfdr.de>; Fri, 17 Apr 2020 16:10:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730825AbgDQOEx (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 17 Apr 2020 10:04:53 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:32583 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730822AbgDQOEw (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 17 Apr 2020 10:04:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587132291;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=jzl14S/tVGzQ32rarxG1WpSRn0vKq6/LsU3dsOiZ0hs=;
        b=TdF1qID73t/S/VBQa+w9bsF4hB68U4sL3CuibxxyIZXhCJ7d0hh71F8k09AFflHYfArIRz
        urQBKv1iqtiyqQu7xs1G0Y2FlWmoBhb4cdx+8KqjtLcDS0lM2Bv/P6z8C2yGB3bmIJuIBc
        noOVvQo7nukYZAjzQap4J86AJwjLBFg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-164-D2ilogYQPbCltZ7fQKFYdw-1; Fri, 17 Apr 2020 10:04:46 -0400
X-MC-Unique: D2ilogYQPbCltZ7fQKFYdw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DF952801A00;
        Fri, 17 Apr 2020 14:04:44 +0000 (UTC)
Received: from treble.redhat.com (ovpn-116-146.rdu2.redhat.com [10.10.116.146])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 417B65C1C5;
        Fri, 17 Apr 2020 14:04:44 +0000 (UTC)
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     live-patching@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Jessica Yu <jeyu@kernel.org>
Subject: [PATCH v2 0/9] livepatch,module: Remove .klp.arch and module_disable_ro()
Date:   Fri, 17 Apr 2020 09:04:25 -0500
Message-Id: <cover.1587131959.git.jpoimboe@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Content-Transfer-Encoding: quoted-printable
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

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

I've tested this with a modified kpatch-build:

  https://github.com/jpoimboe/kpatch/tree/no-klp-arch

(I'm planning to submit a github PR for kpatch-build, once I get
 the updated unit/integration tests sorted out.



Josh Poimboeuf (6):
  livepatch: Disallow vmlinux.ko
  livepatch: Apply vmlinux-specific KLP relocations early
  livepatch: Prevent module-specific KLP rela sections from referencing
    vmlinux symbols
  s390: Change s390_kernel_write() return type to match memcpy()
  livepatch: Remove module_disable_ro() usage
  module: Remove module_disable_ro()

Peter Zijlstra (3):
  livepatch: Remove .klp.arch
  s390/module: Use s390_kernel_write() for late relocations
  x86/module: Use text_poke() for late relocations

 Documentation/livepatch/module-elf-format.rst |  15 +-
 arch/s390/include/asm/uaccess.h               |   2 +-
 arch/s390/kernel/module.c                     | 125 ++++++++++------
 arch/s390/mm/maccess.c                        |   9 +-
 arch/um/kernel/um_arch.c                      |  16 +++
 arch/x86/kernel/Makefile                      |   1 -
 arch/x86/kernel/livepatch.c                   |  53 -------
 arch/x86/kernel/module.c                      |  43 +++++-
 include/linux/livepatch.h                     |  17 ++-
 include/linux/module.h                        |   2 -
 kernel/livepatch/core.c                       | 133 +++++++++++-------
 kernel/module.c                               |  22 +--
 12 files changed, 243 insertions(+), 195 deletions(-)
 delete mode 100644 arch/x86/kernel/livepatch.c

--=20
2.21.1

