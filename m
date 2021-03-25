Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34713348C9E
	for <lists+live-patching@lfdr.de>; Thu, 25 Mar 2021 10:18:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229693AbhCYJSS (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 25 Mar 2021 05:18:18 -0400
Received: from mx2.suse.de ([195.135.220.15]:48632 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229574AbhCYJSH (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 25 Mar 2021 05:18:07 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id B2AFBAA55;
        Thu, 25 Mar 2021 09:18:05 +0000 (UTC)
Date:   Thu, 25 Mar 2021 10:18:05 +0100 (CET)
From:   Miroslav Benes <mbenes@suse.cz>
To:     Bhaskar Chowdhury <unixbhaskar@gmail.com>
cc:     jpoimboe@redhat.com, jikos@kernel.org, pmladek@suse.com,
        joe.lawrence@redhat.com, corbet@lwn.net,
        live-patching@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, rdunlap@infradead.org
Subject: Re: [PATCH] docs: livepatch: Fix a typo
In-Reply-To: <YFxTxxOkQDr2rb/J@OpenSuse>
Message-ID: <alpine.LSU.2.21.2103251015260.30447@pobox.suse.cz>
References: <20210325065646.7467-1-unixbhaskar@gmail.com> <alpine.LSU.2.21.2103250956530.30447@pobox.suse.cz> <YFxTxxOkQDr2rb/J@OpenSuse>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu, 25 Mar 2021, Bhaskar Chowdhury wrote:

> On 10:05 Thu 25 Mar 2021, Miroslav Benes wrote:
> >Hi,
> >
> >On Thu, 25 Mar 2021, Bhaskar Chowdhury wrote:
> >
> >>
> >> s/varibles/variables/
> >>
> >> Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
> >> ---
> >>  Documentation/livepatch/shadow-vars.rst | 2 +-
> >>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>
> >> diff --git a/Documentation/livepatch/shadow-vars.rst
> >> b/Documentation/livepatch/shadow-vars.rst
> >> index c05715aeafa4..8464866d18ba 100644
> >> --- a/Documentation/livepatch/shadow-vars.rst
> >> +++ b/Documentation/livepatch/shadow-vars.rst
> >> @@ -165,7 +165,7 @@ In-flight parent objects
> >>
> >>  Sometimes it may not be convenient or possible to allocate shadow
> >>  variables alongside their parent objects.  Or a livepatch fix may
> >> -require shadow varibles to only a subset of parent object instances.  In
> >> +require shadow variables to only a subset of parent object instances.  In
> >>  these cases, the klp_shadow_get_or_alloc() call can be used to attach
> >>  shadow variables to parents already in-flight.
> >
> >you sent the same fix a couple of weeks ago and Jon applied it.
> >
> Ah..difficult to remember....thanks for reminding ..it seems I need to keep
> track ...which I don't do at this moment ...so the patch get duplicated ..

Well, you definitely should.

> So.do you have any better policy to keep track???

I do not send a large amount of typo fixes, so it is quite easy to keep 
track of everything in my case. So please, just find something that suits 
you.

Miroslav
