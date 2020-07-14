Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23C9421F34B
	for <lists+live-patching@lfdr.de>; Tue, 14 Jul 2020 15:58:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728208AbgGNN55 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 14 Jul 2020 09:57:57 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:33080 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726945AbgGNN54 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 14 Jul 2020 09:57:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594735075;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KsP+Zg2SXxpGWvQphHBj9WDMJC0wpn9ZmfS2E7PsRDA=;
        b=Scn2/xTWKBpr9P5UiC/GOQUBA6x3vpB0t6qyVXFI8Ewqv57OnMesIfD9ZD3LyB8eROXC/A
        WbmTpDUXWlkgTVsXvid9i+/Gpjy+IkMKWhZwBQFobENKpJ8CxuhGXhrvNL2tWh3Z+bdNMX
        SBCwvKwJutBLG+nh1P9154npK4Si0Cw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-491-VBrKysQKOeejqWQNk3_Q2A-1; Tue, 14 Jul 2020 09:57:53 -0400
X-MC-Unique: VBrKysQKOeejqWQNk3_Q2A-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A50F1800597;
        Tue, 14 Jul 2020 13:57:51 +0000 (UTC)
Received: from treble (unknown [10.10.119.254])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6D5DF2E02A;
        Tue, 14 Jul 2020 13:57:49 +0000 (UTC)
Date:   Tue, 14 Jul 2020 08:57:47 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Miroslav Benes <mbenes@suse.cz>
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, pmladek@suse.cz,
        live-patching@vger.kernel.org
Subject: Re: linux-next: Tree for Jun 23 (objtool (2))
Message-ID: <20200714135747.lcgysd5joguhssas@treble>
References: <20200623162820.3f45feae@canb.auug.org.au>
 <61df2e8f-75e8-d233-9c3c-5b4fa2b7fbdc@infradead.org>
 <20200702123555.bjioosahrs5vjovu@treble>
 <alpine.LSU.2.21.2007141240540.5393@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.21.2007141240540.5393@pobox.suse.cz>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, Jul 14, 2020 at 12:56:21PM +0200, Miroslav Benes wrote:
> On Thu, 2 Jul 2020, Josh Poimboeuf wrote:
> 
> > On Tue, Jun 23, 2020 at 08:06:07AM -0700, Randy Dunlap wrote:
> > > On 6/22/20 11:28 PM, Stephen Rothwell wrote:
> > > > Hi all,
> > > > 
> > > > Changes since 20200622:
> > > > 
> > > 
> > > on x86_64:
> > > 
> > > arch/x86/kernel/cpu/mce/core.o: warning: objtool: mce_timed_out()+0x24: unreachable instruction
> > > kernel/exit.o: warning: objtool: __x64_sys_exit_group()+0x14: unreachable instruction
> > > 
> > > Full randconfig file is attached.
> > 
> > More livepatch...
> 
> Correct.
> 
> Both are known and I thought Josh had fixes queued somewhere for both, but 
> my memory fails me quite often. See below.

I did have fixes for some of them in a stash somewhere, but I never
finished them because I decided it's a GCC bug.

> However, I think it is time to decide how to approach this whole saga. It 
> seems that there are not so many places in the kernel in need of 
> __noreturn annotation in the end and as jikos argued at least some of 
> those should be fixed regardless.

I would agree that global functions like do_group_exit() deserve a
__noreturn annotation, though it should be in the header file.  But
static functions shouldn't need it.

> Josh, should I prepare proper patches and submit them to relevant
> maintainers to see where this path is going?

If that's how you want to handle it, ok, but it doesn't seem right to
me, for the static functions at least.

> It would be much better to fix it in GCC, but it has been like banging 
> one's head against a wall so far. Josh, you wanted to create a bug 
> for GCC in this respect in the past? Has that happened?

I didn't open a bug, but I could, if you think that would help.  I
haven't had a lot of success with GCC bugs in the past.

> If I remember correctly, we discussed briefly a possibility to cope with 
> that in objtool, but no solution was presented.

That would also feel like a GCC workaround and might impede objtool's
ability to find bugs like this one, and possibly more serious bugs.

> Removing -flive-patching is also a possibility. I don't like it much, but 
> we discussed it with Petr M. a couple of months ago and it might be a way 
> too.

-flive-patching has many problems which I outlined before.  None of them
have been addressed.  I still feel the same way, that it should be
reverted until it's ready.  Otherwise it's a drain on upstream.

Also, if the GCC developers won't acknowledge this bug then it doesn't
give me confidence in their ability to keep the feature working as
optimizations are added or changed.

I still think a potential alternative exists: objtool could be used as a
simple tree-wide object diff tool by generating a checksum for each
function.  Then the patch can be applied and built to see exactly which
functions have changed, based on the changed checksums.  In which case
this feature would no longer be needed anyway, would you agree?

I also think that could be a first step for converging our patch
creation processes.

-- 
Josh

