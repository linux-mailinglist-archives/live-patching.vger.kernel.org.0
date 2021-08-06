Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC8D73E2872
	for <lists+live-patching@lfdr.de>; Fri,  6 Aug 2021 12:18:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244916AbhHFKTE (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 6 Aug 2021 06:19:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245012AbhHFKTD (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 6 Aug 2021 06:19:03 -0400
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AD96C061799;
        Fri,  6 Aug 2021 03:18:48 -0700 (PDT)
Received: by mail-yb1-xb2e.google.com with SMTP id w17so14224036ybl.11;
        Fri, 06 Aug 2021 03:18:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=LzEtfxryBMdUSVfN39cmcYQbMbUOl3wT0TLgCQg+7nU=;
        b=n/VEjbsrp/jmlTJBuiaAL+/o7MmspX6tZ4MUlXNkn99axHY7v0XRq5WcbEy/e6XcUM
         rujMBDwQF4aeCDdTLF7UxPMuUoDSD7iZ1NLR86jYGFdbxU9AuujIyu62Px+mRxx8aH3M
         AJzvDXo0KiDXSC3lKdPnAjuOZqiuDLXNpu+9/zvWauH1ayGta/4B7yhZfO6P0kA2CsBC
         3Q0x8o+94tu7gh3LXGVnOWaKwxBwsasHf3aneIeMT+ElnkH6S82HeFJiweGvtWvJVUtI
         0bzkpZtEyzKSDEYZjGE13pMZdB8YHSVt/q/LN0M6u55O4azW4Bb4FZQR5ATOfX/bcS0D
         /ICQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=LzEtfxryBMdUSVfN39cmcYQbMbUOl3wT0TLgCQg+7nU=;
        b=TzFJVlo7NYNXTuzoarMr0WLu6gFTqi9OLI75TQD3UUKSO5itRsOKxSQO+1Wy1T6870
         xXbcTQfnwGO5cyHm8aNCHmwW/wmHY35Ip7hmHk385x992CabJztcv8kP/QQLfngEOPoK
         Mm/aT/L8cDlCjvac7YCBIQmMWXF16mtmKY+FhKb/GqkzONNqyf/AWV9v6b6UHH+3G9Mk
         3LLBXiWvL8w929FZrUX9QrjB0pzAMm9mytyIPNx0QOf40eHjctxE4pYN3zzOlGIwXgIQ
         6jpfes279YneJqZUdPK+pgfvrj1qOybU7Ej2+5+sNvD1ttMlg7qKYTLPNs94tXEedb+J
         oumg==
X-Gm-Message-State: AOAM531l1cZ/VQ729wQA2xDOsVNPODhLLrE6Ky5j4AnU6ksd9MgWA0HC
        BpkdvQIt5srOsx/yxjKq5ZYKyGAkRfBMQlNrZI0ALs9dxt0=
X-Google-Smtp-Source: ABdhPJyF6mGCLqWiOgPVDpAIAG12HTcwQD2KqRYPDACH+OUl1Ie1xlU7VOGs5wy87t1BKMkjWb40SZgKYfMn0//vnGA=
X-Received: by 2002:a25:8b86:: with SMTP id j6mr11295871ybl.470.1628245127476;
 Fri, 06 Aug 2021 03:18:47 -0700 (PDT)
MIME-Version: 1.0
From:   Lukas Bulwahn <lukas.bulwahn@gmail.com>
Date:   Fri, 6 Aug 2021 12:18:36 +0200
Message-ID: <CAKXUXMwT2zS9fgyQHKUUiqo8ynZBdx2UEUu1WnV_q0OCmknqhw@mail.gmail.com>
Subject: Reference to non-existing DYNAMIC_FTRACE_WITH_ARGS
To:     "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Cc:     live-patching@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        kernel-janitors <kernel-janitors@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hi Steven,

Commit 2860cd8a2353 ("livepatch: Use the default ftrace_ops instead of
REGS when ARGS is available") adds a dependency on a non-existing
config DYNAMIC_FTRACE_WITH_ARGS, see diff:

diff --git a/kernel/livepatch/Kconfig b/kernel/livepatch/Kconfig
index 54102deb50ba..53d51ed619a3 100644
--- a/kernel/livepatch/Kconfig
+++ b/kernel/livepatch/Kconfig
@@ -6,7 +6,7 @@ config HAVE_LIVEPATCH

 config LIVEPATCH
        bool "Kernel Live Patching"
-       depends on DYNAMIC_FTRACE_WITH_REGS
+       depends on DYNAMIC_FTRACE_WITH_REGS || DYNAMIC_FTRACE_WITH_ARGS
        depends on MODULES
        depends on SYSFS
        depends on KALLSYMS_ALL


Did you intend to depend on the existing "HAVE_DYNAMIC_FTRACE_WITH_ARGS" here?

Or did you intend to add a new config DYNAMIC_FTRACE_WITH_ARGS
analogously to DYNAMIC_FTRACE_WITH_REGS as defined in
./kernel/trace/Kconfig (see below)?

config DYNAMIC_FTRACE_WITH_REGS
        def_bool y
        depends on DYNAMIC_FTRACE
        depends on HAVE_DYNAMIC_FTRACE_WITH_REGS

I am happy to provide a patch, once I understand what was intended here.

Lukas
