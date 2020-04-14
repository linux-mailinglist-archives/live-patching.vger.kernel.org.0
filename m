Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFF131A8AD1
	for <lists+live-patching@lfdr.de>; Tue, 14 Apr 2020 21:33:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504833AbgDNTcM (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 14 Apr 2020 15:32:12 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:44885 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2504831AbgDNTcA (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 14 Apr 2020 15:32:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586892719;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+Ahnft7vUrxEzTLFARwrc8iGTJuhUk/MsvvVIUVUZdA=;
        b=LpL5y2pTDHwwpm/Rnpep/Co1NiuC/qJrJHXZvi2W5iTEmqx8G92kq9BW8OtWJqa4jw5W5m
        NEdzN1XQbI0GVYL+0p1Je+u/esKYRtYdbxLq2+H1vzO2B1Iw+TuNdcmw1xfMi/w4aSZT+Q
        OOc8SlcU1eUZLwwDNzGF5IPS5sqx0ns=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-405-APxugEDrOxmPbni84qHg7w-1; Tue, 14 Apr 2020 15:31:55 -0400
X-MC-Unique: APxugEDrOxmPbni84qHg7w-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D27311034AE1;
        Tue, 14 Apr 2020 19:31:53 +0000 (UTC)
Received: from treble (ovpn-116-146.rdu2.redhat.com [10.10.116.146])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D40F95D9CD;
        Tue, 14 Apr 2020 19:31:52 +0000 (UTC)
Date:   Tue, 14 Apr 2020 14:31:50 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jessica Yu <jeyu@kernel.org>
Subject: Re: [PATCH 1/7] livepatch: Apply vmlinux-specific KLP relocations
 early
Message-ID: <20200414193150.iqw224itgpedpltm@treble>
References: <cover.1586881704.git.jpoimboe@redhat.com>
 <8c3af42719fe0add37605ede634c7035a90f9acc.1586881704.git.jpoimboe@redhat.com>
 <20200414174406.GC2483@worktop.programming.kicks-ass.net>
 <20200414180109.da4v2b4ifpixuzn3@treble>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200414180109.da4v2b4ifpixuzn3@treble>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, Apr 14, 2020 at 01:01:09PM -0500, Josh Poimboeuf wrote:
> On Tue, Apr 14, 2020 at 07:44:06PM +0200, Peter Zijlstra wrote:
> > On Tue, Apr 14, 2020 at 11:28:37AM -0500, Josh Poimboeuf wrote:
> > > KLP relocations are livepatch-specific relocations which are applied to
> > >   1) vmlinux-specific KLP relocation sections
> > > 
> > >      .klp.rela.vmlinux.{sec}
> > > 
> > >      These are relocations (applied to the KLP module) which reference
> > >      unexported vmlinux symbols.
> > > 
> > >   2) module-specific KLP relocation sections
> > > 
> > >      .klp.rela.{module}.{sec}:
> > > 
> > >      These are relocations (applied to the KLP module) which reference
> > >      unexported or exported module symbols.
> > 
> > Is there something that disallows a module from being called 'vmlinux' ?
> > If not, we might want to enforce this somewhere.
> 
> I'm pretty sure we don't have a check for that anywhere, though the KLP
> module would almost certainly fail during the module load when it
> couldn't find the vmlinux.ko symbols it needed.
> 
> It wouldn't hurt to add a check somewhere though.  Maybe in
> klp_module_coming() since the restriction only applies to
> CONFIG_LIVEPATCH...

From: Josh Poimboeuf <jpoimboe@redhat.com>
Subject: [PATCH] livepatch: Disallow vmlinux.ko

This is purely a theoretical issue, but if there were a module named
vmlinux.ko, the livepatch relocation code wouldn't be able to
distinguish between vmlinux-specific and vmlinux.o-specific KLP
relocations.

If CONFIG_LIVEPATCH is enabled, don't allow a module named vmlinux.ko.

Suggested-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
---
 kernel/livepatch/core.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
index 3a88639b3326..3ff886b911ae 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -1169,6 +1169,11 @@ int klp_module_coming(struct module *mod)
 	if (WARN_ON(mod->state != MODULE_STATE_COMING))
 		return -EINVAL;
 
+	if (!strcmp(mod->name, "vmlinux")) {
+		pr_err("vmlinux.ko: invalid module name");
+		return -EINVAL;
+	}
+
 	mutex_lock(&klp_mutex);
 	/*
 	 * Each module has to know that klp_module_coming()
-- 
2.21.1

