Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F352D777F3
	for <lists+live-patching@lfdr.de>; Sat, 27 Jul 2019 11:41:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387469AbfG0JlL (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Sat, 27 Jul 2019 05:41:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:49988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387400AbfG0JlL (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Sat, 27 Jul 2019 05:41:11 -0400
Received: from devnote2 (NE2965lan1.rev.em-net.ne.jp [210.141.244.193])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3253720651;
        Sat, 27 Jul 2019 09:41:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564220470;
        bh=8r07P/49bD7tGCbiO15J6Jkw/IywyIwMyaahO2tzyGQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bAbZ/snNo9loBKtA2XTUl4VuNXQhvvQn2ZuEkfjyAXwMdlWdGKBwu3LUYuncEINF8
         RvbFUtq9wDHXM8f84Q0LBxTp8NLBYyOk32b4fyvJ+bxo5xKS6kAJ6fJxa8izu4tftD
         kyvqbz+/rDKCeN8ZOD81bwSynlXxXICoCa04kBFQ=
Date:   Sat, 27 Jul 2019 18:41:05 +0900
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Joe Lawrence <joe.lawrence@redhat.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Naveen N . Rao" <naveen.n.rao@linux.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH] kprobes: Allow kprobes coexist with livepatch
Message-Id: <20190727184105.39fde3cd4f3708489a17ff15@kernel.org>
In-Reply-To: <ddda9253-27df-755b-ed51-8abc2859f076@redhat.com>
References: <156403587671.30117.5233558741694155985.stgit@devnote2>
        <20190726020752.GA6388@redhat.com>
        <20190726121449.22f0989e@gandalf.local.home>
        <ddda9253-27df-755b-ed51-8abc2859f076@redhat.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri, 26 Jul 2019 13:38:41 -0400
Joe Lawrence <joe.lawrence@redhat.com> wrote:

> On 7/26/19 12:14 PM, Steven Rostedt wrote:
> > On Thu, 25 Jul 2019 22:07:52 -0400
> > Joe Lawrence <joe.lawrence@redhat.com> wrote:
> > 
> >> These results reflect my underestanding of FTRACE_OPS_FL_IPMODIFY in
> >> light of your changes, so feel free to add my:
> >>
> >> Acked-by: Joe Lawrence <joe.lawrence@redhat.com>
> > 
> > Is this an urgent patch (needs to go in now and not wait for the next
> > merge window) and if so, should it be marked for stable?
> > 
> 
> Hi Steve,
> 
> IMHO, it's not urgent..  so unless Josh or other livepatch folks say 
> otherwise, I'm ok with waiting for next merge window.  Given summer 
> holiday schedules, that would give them more time to comment if they like.

Agreed. Since system admin can control kprobes and livepatch, which
means the confliction can be avoided.

Thank you,

-- 
Masami Hiramatsu <mhiramat@kernel.org>
