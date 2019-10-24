Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6E1FE33C0
	for <lists+live-patching@lfdr.de>; Thu, 24 Oct 2019 15:16:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730389AbfJXNQo (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 24 Oct 2019 09:16:44 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:45122 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730061AbfJXNQn (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 24 Oct 2019 09:16:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=eH1UaNlHCBowXwx10je1E06F7q5EkSmxj/AwDu3/pAw=; b=jzQkdh3uJYTJF5EBja/2oC5L7
        SnOFhthPrNPnqYnuVLRXs3Mk12vTuDWCXMLHE55B3BUk0lqJWxvvSs5mdJQlGNgz5udRK44qz1+iI
        mVAzlv3QoIVmUO3OgiLDb8APeu/YQx2uE8awjv5ddfMDq4Glcj9OqQo6f1bHRkPCuoaXevMnqrfBZ
        Sz39u3SA66hH9+VD4kgLNIzBnth3FXmmXyxo+AZ05seOcBvy7T8Gtr8edVRU8+ex0jbTgrvuZr7DN
        BxSN5unHxqaT3gx0qVcXkdpu+oFX8X8sRae/lodn/ARo6zdtQ+zF8XSYXhZPdm7a5xV6GWvaVocbR
        rIoiOkGWw==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iNcyi-0006oC-G3; Thu, 24 Oct 2019 13:16:36 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id AC36C300EBF;
        Thu, 24 Oct 2019 15:15:35 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 2EE692B1D7C81; Thu, 24 Oct 2019 15:16:34 +0200 (CEST)
Date:   Thu, 24 Oct 2019 15:16:34 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Josh Poimboeuf <jpoimboe@redhat.com>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org, rostedt@goodmis.org,
        mhiramat@kernel.org, bristot@redhat.com, jbaron@akamai.com,
        torvalds@linux-foundation.org, tglx@linutronix.de,
        mingo@kernel.org, namit@vmware.com, hpa@zytor.com, luto@kernel.org,
        ard.biesheuvel@linaro.org, jeyu@kernel.org,
        live-patching@vger.kernel.org
Subject: Re: [PATCH v4 15/16] module: Move where we mark modules RO,X
Message-ID: <20191024131634.GC4131@hirez.programming.kicks-ass.net>
References: <20191018073525.768931536@infradead.org>
 <20191018074634.801435443@infradead.org>
 <20191021135312.jbbxsuipxldocdjk@treble>
 <20191021141402.GI1817@hirez.programming.kicks-ass.net>
 <20191023114835.GT1817@hirez.programming.kicks-ass.net>
 <20191023170025.f34g3vxaqr4f5gqh@treble>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191023170025.f34g3vxaqr4f5gqh@treble>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, Oct 23, 2019 at 12:00:25PM -0500, Josh Poimboeuf wrote:

> > This then raises a number of questions:
> > 
> >  1) why is that RELA (that obviously does not depend on any module)
> >     applied so late?
> 
> Good question.  The 'pv_ops' symbol is exported by the core kernel, so I
> can't see any reason why we'd need to apply that rela late.  In theory,
> kpatch-build isn't supposed to convert that to a klp rela.  Maybe
> something went wrong in the patch creation code.
> 
> I'm also questioning why we even need to apply the parainstructions
> section late.  Maybe we can remove that apply_paravirt() call
> altogether, along with .klp.arch.parainstruction sections.
> 
> I'll need to look into it...

Right, that really should be able to run early. Esp. after commit

  11e86dc7f274 ("x86/paravirt: Detect over-sized patching bugs in paravirt_patch_call()")

paravirt patching is unconditional. We _never_ run with the indirect
call except very early boot, but modules should have them patched way
before their init section runs.

We rely on this for spectre-v2 and friends.

> >  3) Is there ever a possible module-dependent RELA to a paravirt /
> >     alternative site?
> 
> Good question...

> > Then for 3) we only have alternatives left, and I _think_ it unlikely to
> > be the case, but I'll have to have a hard look at that.
> 
> I'm not sure about alternatives, but maybe we can enforce such
> limitations with tooling and/or kernel checks.

Right, so on IRC you implied you might have some additional details on
how alternatives were affected; did you manage to dig that up?
