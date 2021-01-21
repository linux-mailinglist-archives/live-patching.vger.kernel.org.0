Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 030DF2FE6FD
	for <lists+live-patching@lfdr.de>; Thu, 21 Jan 2021 11:02:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728838AbhAUKBU (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 21 Jan 2021 05:01:20 -0500
Received: from pegase1.c-s.fr ([93.17.236.30]:38880 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728336AbhAUKBI (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 21 Jan 2021 05:01:08 -0500
Received: from localhost (mailhub1-int [192.168.12.234])
        by localhost (Postfix) with ESMTP id 4DLyYw37yGz9v6LH;
        Thu, 21 Jan 2021 11:00:20 +0100 (CET)
X-Virus-Scanned: Debian amavisd-new at c-s.fr
Received: from pegase1.c-s.fr ([192.168.12.234])
        by localhost (pegase1.c-s.fr [192.168.12.234]) (amavisd-new, port 10024)
        with ESMTP id gZx8YCs2vO5j; Thu, 21 Jan 2021 11:00:20 +0100 (CET)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase1.c-s.fr (Postfix) with ESMTP id 4DLyYw1bykz9v6L8;
        Thu, 21 Jan 2021 11:00:20 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 644DE8B7FC;
        Thu, 21 Jan 2021 11:00:21 +0100 (CET)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id GUfPkvtK1UQx; Thu, 21 Jan 2021 11:00:21 +0100 (CET)
Received: from [192.168.4.90] (unknown [192.168.4.90])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 51AC08B771;
        Thu, 21 Jan 2021 11:00:20 +0100 (CET)
Subject: Re: [PATCH 02/13] module: add a module_loaded helper
To:     Christoph Hellwig <hch@lst.de>,
        Frederic Barrat <fbarrat@linux.ibm.com>,
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
Cc:     Michal Marek <michal.lkml@markovi.net>,
        linux-kbuild@vger.kernel.org,
        Masahiro Yamada <masahiroy@kernel.org>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        live-patching@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
References: <20210121074959.313333-1-hch@lst.de>
 <20210121074959.313333-3-hch@lst.de>
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
Message-ID: <844a7fc3-2cba-46d2-fd4e-e5fe16b08573@csgroup.eu>
Date:   Thu, 21 Jan 2021 11:00:20 +0100
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210121074959.313333-3-hch@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: fr
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org




Le 21/01/2021 à 08:49, Christoph Hellwig a écrit :
 > Add a helper that takes modules_mutex and uses find_module to check if a
 > given module is loaded.  This provides a better abstraction for the two
 > callers, and allows to unexport modules_mutex and find_module.
 >
 > Signed-off-by: Christoph Hellwig <hch@lst.de>
 > ---
 >   drivers/gpu/drm/drm_fb_helper.c |  7 +------
 >   include/linux/module.h          |  3 +++
 >   kernel/module.c                 | 14 ++++++++++++--
 >   kernel/trace/trace_kprobe.c     |  4 +---
 >   4 files changed, 17 insertions(+), 11 deletions(-)
 >

 > diff --git a/include/linux/module.h b/include/linux/module.h
 > index 7a0bcb5b1ffccd..b4654f8a408134 100644
 > --- a/include/linux/module.h
 > +++ b/include/linux/module.h
 > @@ -589,6 +589,9 @@ static inline bool within_module(unsigned long addr, const struct module *mod)
 >   /* Search for module by name: must hold module_mutex. */
 >   struct module *find_module(const char *name);
 >   +/* Check if a module is loaded. */
 > +bool module_loaded(const char *name);

Maybe module_is_loaded() would be a better name.
