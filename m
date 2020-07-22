Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F2A222A171
	for <lists+live-patching@lfdr.de>; Wed, 22 Jul 2020 23:33:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733003AbgGVVdb (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 22 Jul 2020 17:33:31 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:43896 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726685AbgGVVda (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 22 Jul 2020 17:33:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595453608;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6UgVjjJcVGP42I9xFZ1qZP7ITGojf/KeQGKFYq4eMxc=;
        b=AFCPHQX7m6KANDrYwFW7DRj+rjKOTDXGUdJOB7qDEpVQIjeaNlD7luuHkUa7EGFYXIfx2P
        t4aOizibfZlKFEjJEVp1Brv1vavEpDIXt5rE1Jc+UFBp4jiV0+LiXRrpNYE2wnOJvhF0uC
        qHtLSzmZ0x87NnM/zvsMyVxgpQnb6+g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-234-2z4NQGofNKiv8rFqmw4fnw-1; Wed, 22 Jul 2020 17:33:20 -0400
X-MC-Unique: 2z4NQGofNKiv8rFqmw4fnw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AA8EE1923762;
        Wed, 22 Jul 2020 21:33:17 +0000 (UTC)
Received: from treble (ovpn-116-168.rdu2.redhat.com [10.10.116.168])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C6D8E710C3;
        Wed, 22 Jul 2020 21:33:15 +0000 (UTC)
Date:   Wed, 22 Jul 2020 16:33:13 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Kristen Carlson Accardi <kristen@linux.intel.com>
Cc:     Kees Cook <keescook@chromium.org>, Miroslav Benes <mbenes@suse.cz>,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        arjan@linux.intel.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com,
        rick.p.edgecombe@intel.com, live-patching@vger.kernel.org
Subject: Re: [PATCH v4 00/10] Function Granular KASLR
Message-ID: <20200722213313.aetl3h5rkub6ktmw@treble>
References: <20200717170008.5949-1-kristen@linux.intel.com>
 <alpine.LSU.2.21.2007221122110.10163@pobox.suse.cz>
 <202007220738.72F26D2480@keescook>
 <20200722160730.cfhcj4eisglnzolr@treble>
 <202007221241.EBC2215A@keescook>
 <301c7fb7d22ad6ef97856b421873e32c2239d412.camel@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <301c7fb7d22ad6ef97856b421873e32c2239d412.camel@linux.intel.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, Jul 22, 2020 at 12:56:10PM -0700, Kristen Carlson Accardi wrote:
> On Wed, 2020-07-22 at 12:42 -0700, Kees Cook wrote:
> > On Wed, Jul 22, 2020 at 11:07:30AM -0500, Josh Poimboeuf wrote:
> > > On Wed, Jul 22, 2020 at 07:39:55AM -0700, Kees Cook wrote:
> > > > On Wed, Jul 22, 2020 at 11:27:30AM +0200, Miroslav Benes wrote:
> > > > > Let me CC live-patching ML, because from a quick glance this is
> > > > > something 
> > > > > which could impact live patching code. At least it invalidates
> > > > > assumptions 
> > > > > which "sympos" is based on.
> > > > 
> > > > In a quick skim, it looks like the symbol resolution is using
> > > > kallsyms_on_each_symbol(), so I think this is safe? What's a good
> > > > selftest for live-patching?
> > > 
> > > The problem is duplicate symbols.  If there are two static
> > > functions
> > > named 'foo' then livepatch needs a way to distinguish them.
> > > 
> > > Our current approach to that problem is "sympos".  We rely on the
> > > fact
> > > that the second foo() always comes after the first one in the
> > > symbol
> > > list and kallsyms.  So they're referred to as foo,1 and foo,2.
> > 
> > Ah. Fun. In that case, perhaps the LTO series has some solutions. I
> > think builds with LTO end up renaming duplicate symbols like that, so
> > it'll be back to being unique.
> > 
> 
> Well, glad to hear there might be some precendence for how to solve
> this, as I wasn't able to think of something reasonable off the top of
> my head. Are you speaking of the Clang LTO series? 
> https://lore.kernel.org/lkml/20200624203200.78870-1-samitolvanen@google.com/

I'm not sure how LTO does it, but a few more (half-brained) ideas that
could work:

1) Add a field in kallsyms to keep track of a symbol's original offset
   before randomization/re-sorting.  Livepatch could use that field to
   determine the original sympos.

2) In fgkaslr code, go through all the sections and mark the ones which
   have duplicates (i.e. same name).  Then when shuffling the sections,
   skip a shuffle if it involves a duplicate section.  That way all the
   duplicates would retain their original sympos.

3) Livepatch could uniquely identify symbols by some feature other than
   sympos.  For example:

   Symbol/function size - obviously this would only work if duplicately
   named symbols have different sizes.

   Checksum - as part of a separate feature we're also looking at giving
   each function its own checksum, calculated based on its instruction
   opcodes.  Though calculating checksums at runtime could be
   complicated by IP-relative addressing.

I'm thinking #1 or #2 wouldn't be too bad.  #3 might be harder.

-- 
Josh

