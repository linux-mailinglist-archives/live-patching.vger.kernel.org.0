Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DD632A030F
	for <lists+live-patching@lfdr.de>; Fri, 30 Oct 2020 11:41:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725808AbgJ3Kle (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 30 Oct 2020 06:41:34 -0400
Received: from mx2.suse.de ([195.135.220.15]:39262 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725790AbgJ3Kld (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Fri, 30 Oct 2020 06:41:33 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1604054491;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=p/BtQ++5zS+WPjtM1dDZdlm+h9v0/VVu9/G1z1EDdzU=;
        b=AA0N4PoNb6MlvO++SZr0bFnfX/1FNrhcT2/AdQ69oGGuqQIkpv3ZWKWOuflfxV0DVx65XL
        xhO/pviHTaXMKMiBUMxXeDO3yBoLJlrnar1T2x5KQsLMM4xj3zyW9Z09QWH/7SCefQNDQg
        nYFCxkvzrNdsUYN1x++SjyLSTk+D14U=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id D0ABEAC53;
        Fri, 30 Oct 2020 10:41:31 +0000 (UTC)
Date:   Fri, 30 Oct 2020 11:41:30 +0100
From:   Petr Mladek <pmladek@suse.com>
To:     Miroslav Benes <mbenes@suse.cz>
Cc:     Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        live-patching@vger.kernel.org
Subject: Re: [PATCH 6/9] livepatch/ftrace: Add recursion protection to the
 ftrace callback
Message-ID: <20201030104130.GA1602@alley>
References: <20201028115244.995788961@goodmis.org>
 <20201028115613.291169246@goodmis.org>
 <alpine.LSU.2.21.2010291443310.1688@pobox.suse.cz>
 <20201029145709.GD16774@alley>
 <20201029142406.3c46855a@gandalf.local.home>
 <alpine.LSU.2.21.2010301048080.22360@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.21.2010301048080.22360@pobox.suse.cz>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri 2020-10-30 10:48:58, Miroslav Benes wrote:
> > > > > +	bit = ftrace_test_recursion_trylock();
> > > > > +	if (bit < 0)
> > > > > +		return;  
> > > > 
> > > > This means that the original function will be called in case of recursion. 
> > > > That's probably fair, but I'm wondering if we should at least WARN about 
> > > > it.  
> > > 
> > > Yeah, the early return might break the consistency model and
> > > unexpected things might happen. We should be aware of it.
> > > Please use:
> > > 
> > > 	if (WARN_ON_ONCE(bit < 0))
> > > 		return;
> > > 
> > > WARN_ON_ONCE() might be part of the recursion. But it should happen
> > > only once. IMHO, it is worth the risk.
> > > 
> > > Otherwise it looks good.
> > 
> > Perhaps we can add that as a separate patch, because this patch doesn't add
> > any real functionality change. It only moves the recursion testing from the
> > helper function (which ftrace wraps all callbacks that do not have the
> > RECURSION flags set, including this one) down to your callback.
> > 
> > In keeping with one patch to do one thing principle, the added of
> > WARN_ON_ONCE() should be a separate patch, as that will change the
> > functionality.
> > 
> > If that WARN_ON_ONCE() breaks things, I'd like it to be bisected to another
> > patch other than this one.
> 
> Works for me.

+1

So, with the updated commit message:

Reviewed-by: Petr Mladek <pmladek@suse.com>

Best Regards,
Petr
