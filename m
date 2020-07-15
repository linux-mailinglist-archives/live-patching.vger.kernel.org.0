Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A17BF221231
	for <lists+live-patching@lfdr.de>; Wed, 15 Jul 2020 18:25:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726780AbgGOQZG (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 15 Jul 2020 12:25:06 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:32814 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725861AbgGOQZF (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 15 Jul 2020 12:25:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594830304;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FWlD0hLU3r7xo10CWD4eKrWqa3s+/o9AbOuWp62AzV0=;
        b=f2EvL9ciMxrLWgJmQVBaKhmrT9n6htUi12kL9sH0N7PKrjOVXpGniu2c0Abp79347iIvO0
        Z5js3Cz5dZbN9uizCTBCUdqjB+01MDOJtpdDR668opT8Cfo9UWflVRv3YddwKjSPBEPHGR
        ctIoRPzisDF19NZ5v31T/iuHV6RQ1hg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-203-O5TdvEwdMi6N6b5aBQt3oA-1; Wed, 15 Jul 2020 12:25:02 -0400
X-MC-Unique: O5TdvEwdMi6N6b5aBQt3oA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AB47B8014D7;
        Wed, 15 Jul 2020 16:25:00 +0000 (UTC)
Received: from treble (ovpn-112-242.rdu2.redhat.com [10.10.112.242])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 79B3861470;
        Wed, 15 Jul 2020 16:24:59 +0000 (UTC)
Date:   Wed, 15 Jul 2020 11:24:57 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Petr Mladek <pmladek@suse.com>
Cc:     Miroslav Benes <mbenes@suse.cz>,
        Randy Dunlap <rdunlap@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        live-patching@vger.kernel.org, Yannick Cote <ycote@redhat.com>
Subject: Re: linux-next: Tree for Jun 23 (objtool (2))
Message-ID: <20200715162457.mhoz2rgjbl4okx6d@treble>
References: <20200623162820.3f45feae@canb.auug.org.au>
 <61df2e8f-75e8-d233-9c3c-5b4fa2b7fbdc@infradead.org>
 <20200702123555.bjioosahrs5vjovu@treble>
 <alpine.LSU.2.21.2007141240540.5393@pobox.suse.cz>
 <20200714135747.lcgysd5joguhssas@treble>
 <alpine.LSU.2.21.2007151250390.25290@pobox.suse.cz>
 <20200715121054.GH20226@alley>
 <20200715134155.GI20226@alley>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200715134155.GI20226@alley>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, Jul 15, 2020 at 03:41:55PM +0200, Petr Mladek wrote:
> On Wed 2020-07-15 14:10:54, Petr Mladek wrote:
> > On Wed 2020-07-15 13:11:14, Miroslav Benes wrote:
> > > Petr, would you agree to revert -flive-patching.
> > 
> > Yes, I agree.
> 
> Or better to say that I will not block it.
> 
> I see that it causes maintenance burden. There are questions about
> reliability and performance impact. I do not have a magic solution
> in the pocket.
> 
> Anyway, we need a solution to know what functions need to get livepatched.
> I do not have experience with comparing the assembly, so I do not know
> how it is complicated and reliable.

Thanks Petr/Miroslav.  I can do the revert patch.  It doesn't have to be
a permanent revert.  I'd certainly be willing to ACK it again in the
future if/when it becomes more ready.

Yannick has agreed to start looking at the objtool function diff
feature.  It's purely theoretical at the moment, we'll see how it works
in practice.  We already do something similar in kpatch-build -- it
differs from the objtool model, but it at least shows that something
similar is possible.

-- 
Josh

