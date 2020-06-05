Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 400B81EFB90
	for <lists+live-patching@lfdr.de>; Fri,  5 Jun 2020 16:39:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727925AbgFEOjr (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 5 Jun 2020 10:39:47 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:28842 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726553AbgFEOjq (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 5 Jun 2020 10:39:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591367985;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PnvUqYN28+V8X3M6jVAizyPBLaqCQtBB/Ka3BDvnqh0=;
        b=GS49tDs2fL1GTglcN1S2FCKiUU8jJL7Yzv2jchbkbjiHlsBaWHhGCbCXPL7gcnLxzEZt7o
        ZlPvBFD08VLGC4Ob1R9rURrbyBubuYlKPII0LSALNj+b9SUpcUTIPd0sKsmy8YHSv3CMrH
        F/BIO3w45oMHWEmSr/hkcmsruJrB96k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-313-0EJL752QOnyPg-caT1FYbg-1; Fri, 05 Jun 2020 10:39:43 -0400
X-MC-Unique: 0EJL752QOnyPg-caT1FYbg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 38CA7EC1B6;
        Fri,  5 Jun 2020 14:39:42 +0000 (UTC)
Received: from treble (ovpn-116-170.rdu2.redhat.com [10.10.116.170])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2F23060C05;
        Fri,  5 Jun 2020 14:39:36 +0000 (UTC)
Date:   Fri, 5 Jun 2020 09:39:34 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Jessica Yu <jeyu@kernel.org>
Cc:     Guenter Roeck <linux@roeck-us.net>, live-patching@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH v4 11/11] module: Make module_enable_ro() static again
Message-ID: <20200605143934.g7mq6y3xhibpb4zr@treble>
References: <cover.1588173720.git.jpoimboe@redhat.com>
 <d8b705c20aee017bf9a694c0462a353d6a9f9001.1588173720.git.jpoimboe@redhat.com>
 <20200605132450.GA257550@roeck-us.net>
 <20200605142009.GA5150@linux-8ccs.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200605142009.GA5150@linux-8ccs.fritz.box>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri, Jun 05, 2020 at 04:20:10PM +0200, Jessica Yu wrote:
> +++ Guenter Roeck [05/06/20 06:24 -0700]:
> > On Wed, Apr 29, 2020 at 10:24:53AM -0500, Josh Poimboeuf wrote:
> > > Now that module_enable_ro() has no more external users, make it static
> > > again.
> > > 
> > > Suggested-by: Jessica Yu <jeyu@kernel.org>
> > > Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
> > > Acked-by: Miroslav Benes <mbenes@suse.cz>
> > 
> > Apparently this patch made it into the upstream kernel on its own,
> > not caring about its dependencies. Results are impressive.
> > 
> > Build results:
> > 	total: 155 pass: 101 fail: 54
> > Qemu test results:
> > 	total: 431 pass: 197 fail: 234
> > 
> > That means bisects will be all but impossible until this is fixed.
> > Was that really necessary ?
> 
> Sigh, I am really sorry about this. We made a mistake in handling
> inter-tree dependencies between livepatching and modules-next,
> unfortunately :-( Merging the modules-next pull request next should
> resolve the module_enable_ro() not defined for
> !ARCH_HAS_STRICT_MODULE_RWX build issue. The failure was hidden in
> linux-next since both trees were always merged together. Again, it
> doesn't excuse us from build testing our separate trees more
> rigorously.

This is mostly my fault for basing my patches on linux-next -- oops.

We've also been trained to be lazy by the 0-day bot, which has been
slacking lately.

-- 
Josh

