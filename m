Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB2AFD8C73
	for <lists+live-patching@lfdr.de>; Wed, 16 Oct 2019 11:23:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389023AbfJPJXT (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 16 Oct 2019 05:23:19 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:59346 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726480AbfJPJXT (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 16 Oct 2019 05:23:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=5AcyBsYweHc63jioDghXMYrjt1pzca504Ibkz/xNS90=; b=APm/cn8akSdHbAKBaJTgMqgPz
        YdUieszdrJiBZjPyt9L9nocPXj8My528/yeh8YgGkL26CY7BjfVwjzZxHjp4x+pxdlQL31JO6He8d
        cr+ntUbFKU5gbzeEhxOxW7U8XZDPsxpnjBr2Qz28Nu2idlfY8mK2D0E3GtGDOM/Dw3VWbOZ5TfkRO
        JkfGCJGMjl4sm+OBMIzDe3gta89HiqZPlxY8XY3T3wqgbRDYZw+kjj3ulYOtUNFbtVQug+sXwduzs
        Wn9UztxVgEuBedCAnAfouyotKFv2pO4C2pwMY63H/I4CIZhcU6ZDJF5Xw7EJJs6zaC2eVzCfZfmB5
        fa/hdBppA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iKfWN-0001zK-E0; Wed, 16 Oct 2019 09:23:07 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id AC6B03032F8;
        Wed, 16 Oct 2019 11:22:09 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 8055B2042784A; Wed, 16 Oct 2019 11:23:04 +0200 (CEST)
Date:   Wed, 16 Oct 2019 11:23:04 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Miroslav Benes <mbenes@suse.cz>
Cc:     Joe Lawrence <joe.lawrence@redhat.com>,
        Jessica Yu <jeyu@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, mhiramat@kernel.org,
        bristot@redhat.com, jbaron@akamai.com,
        torvalds@linux-foundation.org, tglx@linutronix.de,
        mingo@kernel.org, namit@vmware.com, hpa@zytor.com, luto@kernel.org,
        ard.biesheuvel@linaro.org, jpoimboe@redhat.com,
        live-patching@vger.kernel.org
Subject: Re: [PATCH v3 5/6] x86/ftrace: Use text_poke()
Message-ID: <20191016092304.GL2294@hirez.programming.kicks-ass.net>
References: <20191010091956.48fbcf42@gandalf.local.home>
 <20191010140513.GT2311@hirez.programming.kicks-ass.net>
 <20191010115449.22044b53@gandalf.local.home>
 <20191010172819.GS2328@hirez.programming.kicks-ass.net>
 <20191011125903.GN2359@hirez.programming.kicks-ass.net>
 <20191015130739.GA23565@linux-8ccs>
 <20191015135634.GK2328@hirez.programming.kicks-ass.net>
 <alpine.LSU.2.21.1910151611000.13169@pobox.suse.cz>
 <88bab814-ea24-ece9-2bc0-7a1e10a62f12@redhat.com>
 <alpine.LSU.2.21.1910160843420.7750@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.21.1910160843420.7750@pobox.suse.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, Oct 16, 2019 at 08:51:27AM +0200, Miroslav Benes wrote:
> On Tue, 15 Oct 2019, Joe Lawrence wrote:
> 
> > On 10/15/19 10:13 AM, Miroslav Benes wrote:
> > > Yes, it does. klp_module_coming() calls module_disable_ro() on all
> > > patching modules which patch the coming module in order to call
> > > apply_relocate_add(). New (patching) code for a module can be relocated
> > > only when the relevant module is loaded.
> > 
> > FWIW, would the LPC blue-sky2 model (ie, Steve's suggestion @ plumber's where
> > livepatches only patch a single object and updates are kept on disk to handle
> > coming module updates as they are loaded) eliminate those outstanding
> > relocations and the need to perform this late permission flipping?
> 
> Yes, it should, but we don't have to wait for it. PeterZ proposed a 
> different solution to this specific issue in 
> https://lore.kernel.org/lkml/20191015141111.GP2359@hirez.programming.kicks-ass.net/
> 
> It should not be a problem to create a live patch module like that and the 
> code in kernel/livepatch/ is almost ready. Something like 
> module_section_disable_ro(mod, section) (and similar for X protection) 
> should be enough. Module reloads would still require juggling with the 
> protections, but I think it is all feasible.

Just had a browse around the module code, and while the section info is
in load_info, it doesn't get retained for active modules.

So I suppose I'll go add that for KLP enabled things.
