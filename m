Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EBB21CBE6B
	for <lists+live-patching@lfdr.de>; Sat,  9 May 2020 09:33:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728625AbgEIHdQ (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Sat, 9 May 2020 03:33:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728783AbgEIHdQ (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Sat, 9 May 2020 03:33:16 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D08D3C061A0C;
        Sat,  9 May 2020 00:33:15 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id x17so4506200wrt.5;
        Sat, 09 May 2020 00:33:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=JzII+/ip8LqgseqkpLSSihEGHWvUlzQVWw55jRYME58=;
        b=E2idVmRrLfXzjWuOge01x9LEGPM+aP1tprtJ9oV2gDjZs4CqElrZqsLDTL/QYwEPde
         2SndPpVpaQHDh4LalEk9DQ6SIn55638UN3z+q9pZCyHj19ba+D9JpoI1WIwu6IctK5x/
         eyvtHDwNoI1aPF6eqIQnkmnCzv+73UkZfJ7u768SQsQs7cg6psAOc2MtzSCuszH5rEZT
         o9MXsv3p78nNmIsXY2+Aw+IwX9lYE2oqlrww87TkTUwLBOrSjalVFo8225h9qZEk2Z71
         xBFNZlg/Fwf3eJWBjj/SeCXGLzRzp0LniMQFVHQHYx4VSQpLP502q1MZ8+tLIaXejWSM
         yNJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=JzII+/ip8LqgseqkpLSSihEGHWvUlzQVWw55jRYME58=;
        b=hMbyHkrRlzPYU5ol8SlJBYIbJ503Tpi69/NZAxvZ+On/Q2qvpCxN3dBqJEV6PUyhdz
         9eOXcjnEXM9uYXPptwE9XCEX1UFmWdKk2Guxv8bWVoF4ksHTDV09YIMT6AIANOGCeBnt
         vio1NtnjVNvGgNamf8/DjamORfbdWB/mp0cyIa+O4R/5l4dI9w/HMO9UEzbn/iGseYAw
         yomAnlZzi31pCo9vX3zinBpTEoS5agnfvQeYdnEo2A4wd/2GokzjPkWueMkKz9U0To4n
         WuuzXCglkPpgs6HzEV8ioGkhUWWAjfinJmsBoxRL4vLyHV4U0rdSPuPloHy1XNRZ2xaY
         iD4Q==
X-Gm-Message-State: AGi0Pubt+sz1TovjdWCpncuRkZIC3eE3nzgQl/JP/fD/NyuK3GFX++ic
        IFqJdzYpWivRja6Hua9CJCo=
X-Google-Smtp-Source: APiQypK5+lymdTCRNfyJZjPR9RVDesDwYyb0xT+Bl8rGLfeyEloWc0zMGzcH+LSjJqSto90pIUea+g==
X-Received: by 2002:adf:82c3:: with SMTP id 61mr7556187wrc.326.1589009594505;
        Sat, 09 May 2020 00:33:14 -0700 (PDT)
Received: from felia.fritz.box ([2001:16b8:2d78:ee00:a1d0:e5b9:8d00:ef35])
        by smtp.gmail.com with ESMTPSA id a10sm7437826wrp.0.2020.05.09.00.33.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 May 2020 00:33:13 -0700 (PDT)
From:   Lukas Bulwahn <lukas.bulwahn@gmail.com>
To:     Jiri Kosina <jkosina@suse.cz>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        live-patching@vger.kernel.org, Joe Perches <joe@perches.com>,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>
Subject: [PATCH] MAINTAINERS: adjust to livepatch .klp.arch removal
Date:   Sat,  9 May 2020 09:32:58 +0200
Message-Id: <20200509073258.5970-1-lukas.bulwahn@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Commit 1d05334d2899 ("livepatch: Remove .klp.arch") removed
arch/x86/kernel/livepatch.c, but missed to adjust the LIVE PATCHING entry
in MAINTAINERS.

Since then, ./scripts/get_maintainer.pl --self-test=patterns complains:

  warning: no file matches  F:  arch/x86/kernel/livepatch.c

So, drop that obsolete file entry in MAINTAINERS.

Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
---
Jiri, please take this minor non-urgent patch for livepatching/for-next.
Peter, please ack.

applies cleanly on next-20200508

 MAINTAINERS | 1 -
 1 file changed, 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 92657a132417..642f55c4b556 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9909,7 +9909,6 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/livepatching/livepatching.g
 F:	Documentation/ABI/testing/sysfs-kernel-livepatch
 F:	Documentation/livepatch/
 F:	arch/x86/include/asm/livepatch.h
-F:	arch/x86/kernel/livepatch.c
 F:	include/linux/livepatch.h
 F:	kernel/livepatch/
 F:	samples/livepatch/
-- 
2.17.1

