Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D03892FF5F9
	for <lists+live-patching@lfdr.de>; Thu, 21 Jan 2021 21:36:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725779AbhAUUe7 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 21 Jan 2021 15:34:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727158AbhAUHyQ (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 21 Jan 2021 02:54:16 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC1CAC0613C1;
        Wed, 20 Jan 2021 23:53:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=UGANRP/KM5q83XfobVV7DWx5ZvtoCTKMobbFGMONdGw=; b=lEUjKYCeFs939aYUT/oDk6x8Y8
        cQ3mrs840LqXWpjhVo/H1r9njWTQ2UPMp9vFEXNfezGdicLLr/cpJYuAIPKokMcQdsrz5ps+wCZNK
        nZ2RUpOEkYuO5olwBDJmnGrb7/ILlsTg617y335c8QBpy3BbsWSMBVQgNHVcD3kQsM+HbV3hK4fA9
        oqMsrTu5NsH9B5ZNHX/iQUwurf1JG18BrQ4usaMdfm8xeUK3jmKB47YIhmvEp4W3VqZRJ+yOtCKrq
        95e+rD3HXbyxkwd44BUDiR7XtNG/my8cZkRGEyei9qwBKaHcXWITUTwK8+IKHsYEr6qESVUJyPNHu
        1BsbRzLQ==;
Received: from 089144206130.atnat0015.highway.bob.at ([89.144.206.130] helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1l2UlI-00Gm22-Ef; Thu, 21 Jan 2021 07:52:17 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Frederic Barrat <fbarrat@linux.ibm.com>,
        Andrew Donnellan <ajd@linux.ibm.com>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>, Jessica Yu <jeyu@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>
Cc:     Masahiro Yamada <masahiroy@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        dri-devel@lists.freedesktop.org, live-patching@vger.kernel.org,
        linux-kbuild@vger.kernel.org
Subject: module loader dead code removal and cleanusp
Date:   Thu, 21 Jan 2021 08:49:46 +0100
Message-Id: <20210121074959.313333-1-hch@lst.de>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hi all,

this series removes support for long term unused export types and
cleans up various loose ends in the module loader.

Diffstat:
 arch/arm/configs/bcm2835_defconfig          |    1 
 arch/arm/configs/mxs_defconfig              |    1 
 arch/mips/configs/nlm_xlp_defconfig         |    1 
 arch/mips/configs/nlm_xlr_defconfig         |    1 
 arch/parisc/configs/generic-32bit_defconfig |    1 
 arch/parisc/configs/generic-64bit_defconfig |    1 
 arch/powerpc/configs/ppc6xx_defconfig       |    1 
 arch/powerpc/platforms/powernv/pci-cxl.c    |   22 -
 arch/s390/configs/debug_defconfig           |    1 
 arch/s390/configs/defconfig                 |    1 
 arch/sh/configs/edosk7760_defconfig         |    1 
 arch/sh/configs/sdk7780_defconfig           |    1 
 arch/x86/configs/i386_defconfig             |    1 
 arch/x86/configs/x86_64_defconfig           |    1 
 arch/x86/tools/relocs.c                     |    4 
 drivers/gpu/drm/drm_crtc_helper_internal.h  |   10 
 drivers/gpu/drm/drm_fb_helper.c             |   21 -
 drivers/gpu/drm/drm_kms_helper_common.c     |   26 +-
 include/asm-generic/vmlinux.lds.h           |   42 ---
 include/linux/export.h                      |    9 
 include/linux/kallsyms.h                    |   17 -
 include/linux/module.h                      |   42 ---
 init/Kconfig                                |   17 -
 kernel/kallsyms.c                           |    8 
 kernel/livepatch/core.c                     |   61 +----
 kernel/module.c                             |  319 ++++++++++------------------
 kernel/trace/trace_kprobe.c                 |    4 
 lib/bug.c                                   |    3 
 scripts/checkpatch.pl                       |    6 
 scripts/mod/modpost.c                       |   50 ----
 scripts/mod/modpost.h                       |    3 
 scripts/module.lds.S                        |    6 
 tools/include/linux/export.h                |    3 
 33 files changed, 181 insertions(+), 505 deletions(-)
