Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38B1E1A8508
	for <lists+live-patching@lfdr.de>; Tue, 14 Apr 2020 18:32:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391729AbgDNQcZ (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 14 Apr 2020 12:32:25 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:59171 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2391607AbgDNQ3K (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 14 Apr 2020 12:29:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586881743;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=UlM+FhdsavTHBo0maWQwyNgbnLg/LDaCZCHGF6K5dDM=;
        b=EzJ6ByU4szLmVfY647tZRkDQqnhsEUKzoYBbe0Oq/xfzAz4CdGviQXwhZeLPekYfMg7pFX
        WVFB8j5t/oy4OafGnPq+N576ODkckZal1p63J6HANkPRw6n3HtSmNBjTx9TYMVMre6hPlA
        sSAUjWu3Y2kzW/6NylIXobHZ5ooRaoA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-321-bHDB6GF6NuWQCj5vuygEtQ-1; Tue, 14 Apr 2020 12:28:57 -0400
X-MC-Unique: bHDB6GF6NuWQCj5vuygEtQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 83FA2800D53;
        Tue, 14 Apr 2020 16:28:56 +0000 (UTC)
Received: from treble.redhat.com (ovpn-116-146.rdu2.redhat.com [10.10.116.146])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D9C1A5DA7C;
        Tue, 14 Apr 2020 16:28:55 +0000 (UTC)
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     live-patching@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Jessica Yu <jeyu@kernel.org>
Subject: [PATCH 0/7] livepatch,module: Remove .klp.arch and module_disable_ro()
Date:   Tue, 14 Apr 2020 11:28:36 -0500
Message-Id: <cover.1586881704.git.jpoimboe@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Content-Transfer-Encoding: quoted-printable
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Better late than never, these patches add simplifications and
improvements for some issues Peter found six months ago, as part of his
non-writable text code (W^X) cleanups.

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


Josh Poimboeuf (4):
  livepatch: Apply vmlinux-specific KLP relocations early
  livepatch: Prevent module-specific KLP rela sections from referencing
    vmlinux symbols
  livepatch: Remove module_disable_ro() usage
  module: Remove module_disable_ro()

Peter Zijlstra (3):
  livepatch: Remove .klp.arch
  s390/module: Use s390_kernel_write() for relocations
  x86/module: Use text_poke() for relocations

 Documentation/livepatch/module-elf-format.rst |  12 +-
 arch/s390/kernel/module.c                     | 106 +++++++++------
 arch/um/kernel/um_arch.c                      |  16 +++
 arch/x86/kernel/Makefile                      |   1 -
 arch/x86/kernel/livepatch.c                   |  53 --------
 arch/x86/kernel/module.c                      |  34 ++++-
 include/linux/livepatch.h                     |  19 ++-
 include/linux/module.h                        |   2 -
 kernel/livepatch/core.c                       | 128 +++++++++++-------
 kernel/module.c                               |  22 +--
 10 files changed, 205 insertions(+), 188 deletions(-)
 delete mode 100644 arch/x86/kernel/livepatch.c

--=20
2.21.1

