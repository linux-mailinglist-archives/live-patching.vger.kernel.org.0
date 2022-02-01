Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A57784A6185
	for <lists+live-patching@lfdr.de>; Tue,  1 Feb 2022 17:44:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241194AbiBAQof (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 1 Feb 2022 11:44:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241161AbiBAQof (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 1 Feb 2022 11:44:35 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AD88C061714;
        Tue,  1 Feb 2022 08:44:35 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id s9so33136906wrb.6;
        Tue, 01 Feb 2022 08:44:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4NqVfXxx+h1TNezmQlgpsbCyzSWdpfX1NQsAjeLv8n8=;
        b=fczcmtf81RjPpNM/tTu+gn1dwpWgq3a63+K7X52ysenA8W3pxOdl3DV/Sw+VRvCwMr
         0vxFp+72yF3RIL45oom+Qf0AJ4id4FUawVRtlK6P1+WI0F55Q6V6qCzNFfiz6k4k+8zk
         4Aot5IOHCVf243anPC/vZAxkry0eI7dXFubiHKVmssBPmJRkBsatWKHryDkB7aIrudhD
         iI++/Z6yhT/He1l/yGvWmzYLeYjKGh7kDcpGntTn95kSSHlZRsr5OnetfWIkEouY2nNk
         H+D6GL8G9ABkP0aOhfLC5vd/2t+SEZcNe9QvJMyN2ANqT3zFUuLN/Ah9nQCjdqh0jx7A
         EfXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4NqVfXxx+h1TNezmQlgpsbCyzSWdpfX1NQsAjeLv8n8=;
        b=VqS1a6QwRq2AyTRVuOvqe8J2j1TSUbk67wW0mQa36E23yr1s6BOTlQ2Rx0MT2URaSz
         5775482iHolKwoN0qaWcEGnYVy485bCI0Th8DhN/JblsXitFF4INMahtTORDdjgr5vnu
         sLa+/OzGhNZT5o8fYyRtP9gbYLyeSyTf59rTxg9XcJFeu9NehcpO0IXif/jwwES3lCvX
         OAm2dfUVldiMkWej7ijQXhX6SfV+GrYciH8i26Xfiol3NJj2kVMh9o7eiMouq0xlmnVJ
         yGBBXaiQq7JHO81LYvQFSBjqzhWGmejiaTjTQA24vF37dhxd7zG66oVtA8f2/YrQ5OzR
         h6oQ==
X-Gm-Message-State: AOAM533DRFQjdNROKtK1WZ8vUOyT0U9nbfKr5lJRsUc6jGC6+oXSJrzO
        5Pki/a4PPMfNKJHkdNTVfNX+QrMiwV3pyaTq00c=
X-Google-Smtp-Source: ABdhPJw3stZCjqZ4Fj7gt98l5hnC3yQ5On1z/N1orlP47YPs96+Jd0iCWjg9Yr02w6W8Itx9zjB3uCaPxG7CH8EQGaE=
X-Received: by 2002:adf:f302:: with SMTP id i2mr22235649wro.114.1643733873538;
 Tue, 01 Feb 2022 08:44:33 -0800 (PST)
MIME-Version: 1.0
References: <20220130213214.1042497-1-atomlin@redhat.com>
In-Reply-To: <20220130213214.1042497-1-atomlin@redhat.com>
From:   Allen <allen.lkml@gmail.com>
Date:   Tue, 1 Feb 2022 08:44:21 -0800
Message-ID: <CAOMdWS+PDCNO3mpGOU-521mWcMwQW0R4iacsWPkgGZL0aYbxrw@mail.gmail.com>
Subject: Re: [RFC PATCH v4 00/13] module: core code clean up
To:     Aaron Tomlin <atomlin@redhat.com>
Cc:     Luis Chamberlain <mcgrof@kernel.org>,
        Christoph Lameter <cl@linux.com>,
        Petr Mladek <pmladek@suse.com>,
        Miroslav Benes <mbenes@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>, jeyu@kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-modules@vger.kernel.org, live-patching@vger.kernel.org,
        atomlin@atomlin.com, ghalat@redhat.com, void@manifault.com,
        Joe Perches <joe@perches.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Thanks Aaron for V4.

Build/boot test on qemu. Running more tests on BM.

Thanks.

On Sun, Jan 30, 2022 at 1:32 PM Aaron Tomlin <atomlin@redhat.com> wrote:
>
> Hi Luis,
>
> As per your suggestion [1], this is an attempt to refactor and split
> optional code out of core module support code into separate components.
> This version is based on branch mcgrof/modules-next since a97ac8cb24a3/or
> modules-5.17-rc1. Please let me know your thoughts.
>
> Changes since v1 [2]:
>
>   - Moved module version support code into a new file
>
> Changes since v2 [3]:
>
>  - Moved module decompress support to a separate file
>  - Made check_modinfo_livepatch() generic (Petr Mladek)
>  - Removed filename from each newly created file (Luis Chamberlain)
>  - Addressed some (i.e. --ignore=ASSIGN_IN_IF,AVOID_BUG was used)
>    minor scripts/checkpatch.pl concerns e.g., use strscpy over
>    strlcpy and missing a blank line after declarations (Allen)
>
> Changes since v3 [4]:
>
>  - Refactored both is_livepatch_module() and set_livepatch_module(),
>    respectively, to use IS_ENABLED(CONFIG_LIVEPATCH) (Joe Perches)
>  - Addressed various compiler warnings e.g., no previous prototype (0-day)
>
> [1]: https://lore.kernel.org/lkml/YbEZ4HgSYQEPuRmS@bombadil.infradead.org/
> [2]: https://lore.kernel.org/lkml/20211228213041.1356334-1-atomlin@redhat.com/
> [3]: https://lore.kernel.org/lkml/20220106234319.2067842-1-atomlin@redhat.com/
> [4]: https://lore.kernel.org/lkml/20220128203934.600247-1-atomlin@redhat.com/
>
> Aaron Tomlin (13):
>   module: Move all into module/
>   module: Simple refactor in preparation for split
>   module: Move livepatch support to a separate file
>   module: Move latched RB-tree support to a separate file
>   module: Move arch strict rwx support to a separate file
>   module: Move strict rwx support to a separate file
>   module: Move extra signature support out of core code
>   module: Move kmemleak support to a separate file
>   module: Move kallsyms support into a separate file
>   module: Move procfs support into a separate file
>   module: Move sysfs support into a separate file
>   module: Move kdb_modules list out of core code
>   module: Move version support into a separate file
>
>  MAINTAINERS                                   |    2 +-
>  include/linux/module.h                        |   64 +-
>  kernel/Makefile                               |    5 +-
>  kernel/debug/kdb/kdb_main.c                   |    5 +
>  kernel/module-internal.h                      |   50 -
>  kernel/module/Makefile                        |   20 +
>  kernel/module/arch_strict_rwx.c               |   44 +
>  kernel/module/debug_kmemleak.c                |   30 +
>  .../decompress.c}                             |    2 +-
>  kernel/module/internal.h                      |  236 +++
>  kernel/module/kallsyms.c                      |  502 +++++
>  kernel/module/livepatch.c                     |   74 +
>  kernel/{module.c => module/main.c}            | 1874 +----------------
>  kernel/module/procfs.c                        |  142 ++
>  .../signature.c}                              |    0
>  kernel/module/signing.c                       |  120 ++
>  kernel/module/strict_rwx.c                    |   83 +
>  kernel/module/sysfs.c                         |  425 ++++
>  kernel/module/tree_lookup.c                   |  109 +
>  kernel/module/version.c                       |  110 +
>  kernel/module_signing.c                       |   45 -
>  21 files changed, 2038 insertions(+), 1904 deletions(-)
>  delete mode 100644 kernel/module-internal.h
>  create mode 100644 kernel/module/Makefile
>  create mode 100644 kernel/module/arch_strict_rwx.c
>  create mode 100644 kernel/module/debug_kmemleak.c
>  rename kernel/{module_decompress.c => module/decompress.c} (99%)
>  create mode 100644 kernel/module/internal.h
>  create mode 100644 kernel/module/kallsyms.c
>  create mode 100644 kernel/module/livepatch.c
>  rename kernel/{module.c => module/main.c} (63%)
>  create mode 100644 kernel/module/procfs.c
>  rename kernel/{module_signature.c => module/signature.c} (100%)
>  create mode 100644 kernel/module/signing.c
>  create mode 100644 kernel/module/strict_rwx.c
>  create mode 100644 kernel/module/sysfs.c
>  create mode 100644 kernel/module/tree_lookup.c
>  create mode 100644 kernel/module/version.c
>  delete mode 100644 kernel/module_signing.c
>
>
> base-commit: a97ac8cb24a3c3ad74794adb83717ef1605d1b47
> --
> 2.34.1
>


-- 
       - Allen
