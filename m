Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7055C4A3A67
	for <lists+live-patching@lfdr.de>; Sun, 30 Jan 2022 22:32:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233152AbiA3VcZ (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Sun, 30 Jan 2022 16:32:25 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:44339 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1356462AbiA3VcT (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Sun, 30 Jan 2022 16:32:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643578339;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=XH3FS3zqUJ/BeN7fcnEtazpeIRBO/BWDiirv0AZyDOI=;
        b=P2gZ6wObpfU1zJ8FGLdMONJ3wAhsN/c/iKkCmSV8BLohhbDnc0rqkSP7JMKhXGoe4T9+Bz
        H1hdbMngdrTXO9yw9te1xPe9y730RBo/tdXAlzIm06IB90ifHq0w5Ge7a/hwjOlzrJTOK9
        YHUUUGg3UtEwQdmR5HdazD+U3nqzZ0E=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-223-PANSk4tcO9CYwikaX-cf4w-1; Sun, 30 Jan 2022 16:32:17 -0500
X-MC-Unique: PANSk4tcO9CYwikaX-cf4w-1
Received: by mail-wm1-f69.google.com with SMTP id l16-20020a7bcf10000000b0034ffdd81e7aso5148807wmg.4
        for <live-patching@vger.kernel.org>; Sun, 30 Jan 2022 13:32:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XH3FS3zqUJ/BeN7fcnEtazpeIRBO/BWDiirv0AZyDOI=;
        b=15c1n3wxYspxcteMcNlxqw0ez8fM1IsZ/4+LM/Lw25dHE8ELQv+K8MAQcHJ5z22upW
         sTOYsJ2GrwW0CEmNNAado4exX3tuyuOkpiwcu7xLylgbaiEHPJEtaNWuWb0FS2bxu9JD
         tYKaG+2aKX51tPl6LckocRA9FCuSn0aTT+0dntZnEfCFnEzSLJrk78q3b6sjF0WqjICo
         1DJf8FMRl0Mbb5beig+4fG9R+bOIhokgOVNZgT8kU/fuNx53TtDyGG/M/cRfIX0DJqpc
         6jeERrmCpd80zJG/4L292ANfnnRLy7duOW7AOp+CBuCZiIr77g5mLp9dTJctGNxizdPz
         hZrw==
X-Gm-Message-State: AOAM532NMLgr+7KCzFKpHNAxaZeCFuK1nMJhEAOva6A5zbJM+mfq07bk
        rtOWFHkj6EaWjMSzf7JqmTs84oyhtfXvRKANcW9B2V51qVA+1LuYRWDuESotde2ojP+96jJus6i
        swJwaFrh0f4Rs6O2pnuQ3hRxw
X-Received: by 2002:a5d:4f08:: with SMTP id c8mr15236189wru.710.1643578336556;
        Sun, 30 Jan 2022 13:32:16 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwycUbzQ0ojm8DSjf9yHn53arqjXwbEXsMvB8ev+BAuA51PaSpRIEuPd+rwaGFX9lfQxZVu2A==
X-Received: by 2002:a5d:4f08:: with SMTP id c8mr15236178wru.710.1643578336371;
        Sun, 30 Jan 2022 13:32:16 -0800 (PST)
Received: from localhost (cpc111743-lutn13-2-0-cust979.9-3.cable.virginm.net. [82.17.115.212])
        by smtp.gmail.com with ESMTPSA id n14sm10355106wri.75.2022.01.30.13.32.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Jan 2022 13:32:15 -0800 (PST)
From:   Aaron Tomlin <atomlin@redhat.com>
To:     mcgrof@kernel.org
Cc:     cl@linux.com, pmladek@suse.com, mbenes@suse.cz,
        akpm@linux-foundation.org, jeyu@kernel.org,
        linux-kernel@vger.kernel.org, linux-modules@vger.kernel.org,
        live-patching@vger.kernel.org, atomlin@atomlin.com,
        ghalat@redhat.com, allen.lkml@gmail.com, void@manifault.com,
        joe@perches.com
Subject: [RFC PATCH v4 00/13] module: core code clean up
Date:   Sun, 30 Jan 2022 21:32:01 +0000
Message-Id: <20220130213214.1042497-1-atomlin@redhat.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hi Luis,

As per your suggestion [1], this is an attempt to refactor and split
optional code out of core module support code into separate components.
This version is based on branch mcgrof/modules-next since a97ac8cb24a3/or
modules-5.17-rc1. Please let me know your thoughts.

Changes since v1 [2]:

  - Moved module version support code into a new file

Changes since v2 [3]:

 - Moved module decompress support to a separate file
 - Made check_modinfo_livepatch() generic (Petr Mladek)
 - Removed filename from each newly created file (Luis Chamberlain)
 - Addressed some (i.e. --ignore=ASSIGN_IN_IF,AVOID_BUG was used)
   minor scripts/checkpatch.pl concerns e.g., use strscpy over
   strlcpy and missing a blank line after declarations (Allen)

Changes since v3 [4]:

 - Refactored both is_livepatch_module() and set_livepatch_module(),
   respectively, to use IS_ENABLED(CONFIG_LIVEPATCH) (Joe Perches)
 - Addressed various compiler warnings e.g., no previous prototype (0-day)

[1]: https://lore.kernel.org/lkml/YbEZ4HgSYQEPuRmS@bombadil.infradead.org/
[2]: https://lore.kernel.org/lkml/20211228213041.1356334-1-atomlin@redhat.com/
[3]: https://lore.kernel.org/lkml/20220106234319.2067842-1-atomlin@redhat.com/
[4]: https://lore.kernel.org/lkml/20220128203934.600247-1-atomlin@redhat.com/

Aaron Tomlin (13):
  module: Move all into module/
  module: Simple refactor in preparation for split
  module: Move livepatch support to a separate file
  module: Move latched RB-tree support to a separate file
  module: Move arch strict rwx support to a separate file
  module: Move strict rwx support to a separate file
  module: Move extra signature support out of core code
  module: Move kmemleak support to a separate file
  module: Move kallsyms support into a separate file
  module: Move procfs support into a separate file
  module: Move sysfs support into a separate file
  module: Move kdb_modules list out of core code
  module: Move version support into a separate file

 MAINTAINERS                                   |    2 +-
 include/linux/module.h                        |   64 +-
 kernel/Makefile                               |    5 +-
 kernel/debug/kdb/kdb_main.c                   |    5 +
 kernel/module-internal.h                      |   50 -
 kernel/module/Makefile                        |   20 +
 kernel/module/arch_strict_rwx.c               |   44 +
 kernel/module/debug_kmemleak.c                |   30 +
 .../decompress.c}                             |    2 +-
 kernel/module/internal.h                      |  236 +++
 kernel/module/kallsyms.c                      |  502 +++++
 kernel/module/livepatch.c                     |   74 +
 kernel/{module.c => module/main.c}            | 1874 +----------------
 kernel/module/procfs.c                        |  142 ++
 .../signature.c}                              |    0
 kernel/module/signing.c                       |  120 ++
 kernel/module/strict_rwx.c                    |   83 +
 kernel/module/sysfs.c                         |  425 ++++
 kernel/module/tree_lookup.c                   |  109 +
 kernel/module/version.c                       |  110 +
 kernel/module_signing.c                       |   45 -
 21 files changed, 2038 insertions(+), 1904 deletions(-)
 delete mode 100644 kernel/module-internal.h
 create mode 100644 kernel/module/Makefile
 create mode 100644 kernel/module/arch_strict_rwx.c
 create mode 100644 kernel/module/debug_kmemleak.c
 rename kernel/{module_decompress.c => module/decompress.c} (99%)
 create mode 100644 kernel/module/internal.h
 create mode 100644 kernel/module/kallsyms.c
 create mode 100644 kernel/module/livepatch.c
 rename kernel/{module.c => module/main.c} (63%)
 create mode 100644 kernel/module/procfs.c
 rename kernel/{module_signature.c => module/signature.c} (100%)
 create mode 100644 kernel/module/signing.c
 create mode 100644 kernel/module/strict_rwx.c
 create mode 100644 kernel/module/sysfs.c
 create mode 100644 kernel/module/tree_lookup.c
 create mode 100644 kernel/module/version.c
 delete mode 100644 kernel/module_signing.c


base-commit: a97ac8cb24a3c3ad74794adb83717ef1605d1b47
-- 
2.34.1

