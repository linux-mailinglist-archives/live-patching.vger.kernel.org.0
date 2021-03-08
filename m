Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9F5E330AFA
	for <lists+live-patching@lfdr.de>; Mon,  8 Mar 2021 11:19:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230271AbhCHKTL (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 8 Mar 2021 05:19:11 -0500
Received: from mx2.suse.de ([195.135.220.15]:44616 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230124AbhCHKSy (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Mon, 8 Mar 2021 05:18:54 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1615198730; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lvCIwtYnesXvJRVGzU2hGB/7G7oq37sXw80Pfgizm38=;
        b=a9QLosKjy8KlfkCHYsZ2OvtJ/ZRgji+TsQ07hrYwcxzXf9fzRx16CvTXdtzoRohFKfxA5y
        QiiXSp+xAInwnEQJMfC2g/cVAMlTSH+RhjqqvuAVHfCXBIUOJ33t1HkRfczb+iH5izh0gg
        VdxKNMER9L9bl9z8mlqGPpTp6bdxtpg=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 8797AAD2B;
        Mon,  8 Mar 2021 10:18:50 +0000 (UTC)
Date:   Mon, 8 Mar 2021 11:18:50 +0100
From:   Petr Mladek <pmladek@suse.com>
To:     Joe Lawrence <joe.lawrence@redhat.com>
Cc:     Bhaskar Chowdhury <unixbhaskar@gmail.com>,
        Matthew Wilcox <willy@infradead.org>, jpoimboe@redhat.com,
        jikos@kernel.org, mbenes@suse.cz, corbet@lwn.net,
        live-patching@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, rdunlap@infradead.org
Subject: Re: [PATCH V2] docs: livepatch: Fix a typo and remove the
 unnecessary gaps in a sentence
Message-ID: <YEX6Cu0EcVpUklFG@alley>
References: <20210305100923.3731-1-unixbhaskar@gmail.com>
 <20210305125600.GM2723601@casper.infradead.org>
 <YEI0EcR5G53IoYzb@Gentoo>
 <f8b10ee7-026c-1dc0-fb0c-2a887cd1e953@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f8b10ee7-026c-1dc0-fb0c-2a887cd1e953@redhat.com>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri 2021-03-05 11:00:10, Joe Lawrence wrote:
> On 3/5/21 8:37 AM, Bhaskar Chowdhury wrote:
> > On 12:56 Fri 05 Mar 2021, Matthew Wilcox wrote:
> > > On Fri, Mar 05, 2021 at 03:39:23PM +0530, Bhaskar Chowdhury wrote:
> > > > s/varibles/variables/
> > > > 
> > > > ...and remove leading spaces from a sentence.
> > > 
> > > What do you mean 'leading spaces'?  Separating two sentences with
> > > one space or two is a matter of personal style, and we do not attempt
> > > to enforce a particular style in the kernel.
> > > 
> > The spaces before the "In" .. nor I am imposing anything , it was peter caught
> > and told me that it is hanging ..move it to the next line ..so I did. ..
> > 
> 
> Initially I thought the same as Matthew, but after inspecting the diff I
> realized it was just a line wrap.  Looks fine to me.
> 
> > > >   Sometimes it may not be convenient or possible to allocate shadow
> > > >   variables alongside their parent objects.  Or a livepatch fix may
> > > > -require shadow varibles to only a subset of parent object instances.  In
> > > > +require shadow variables to only a subset of parent object instances.
> > > 
> > > wrong preposition, s/to/for/    ..where???
> 
> Hi Bhaskar,
> 
> Thanks for spotting, I'd be happy with v2 as is or a v3 if you want to
> update s/shadow variables to only/shadow variables for only/  but knowing
> me, I probably repeated the same phrasing elsewhere.  Up to you, thanks.

I could fix these when pushing unless anyone is against it.

> Acked-by: Joe Lawrence <joe.lawrence@redhat.com>

Acked-by: Petr Mladek <pmladek@suse.com>

Best Regards,
Petr
