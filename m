Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5794BD2BB8
	for <lists+live-patching@lfdr.de>; Thu, 10 Oct 2019 15:51:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726068AbfJJNuz (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 10 Oct 2019 09:50:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:43396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725932AbfJJNuz (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 10 Oct 2019 09:50:55 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 456AE2067B;
        Thu, 10 Oct 2019 13:43:55 +0000 (UTC)
Date:   Thu, 10 Oct 2019 09:43:52 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Miroslav Benes <mbenes@suse.cz>
Cc:     Petr Mladek <pmladek@suse.com>, jikos@kernel.org,
        Joe Lawrence <joe.lawrence@redhat.com>, jpoimboe@redhat.com,
        mingo@redhat.com, linux-kernel@vger.kernel.org,
        live-patching@vger.kernel.org
Subject: Re: [PATCH 0/3] ftrace: Introduce PERMANENT ftrace_ops flag
Message-ID: <20191010094352.35056c84@gandalf.local.home>
In-Reply-To: <alpine.LSU.2.21.1910101535310.32665@pobox.suse.cz>
References: <20191007081714.20259-1-mbenes@suse.cz>
        <20191008193534.GA16675@redhat.com>
        <20191009112234.bi7lvp4pvmna26vz@pathway.suse.cz>
        <20191009102654.501ad7c3@gandalf.local.home>
        <20191010085035.emsdks6xecazqc6k@pathway.suse.cz>
        <20191010091403.5ecf0fdb@gandalf.local.home>
        <alpine.LSU.2.21.1910101535310.32665@pobox.suse.cz>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu, 10 Oct 2019 15:38:20 +0200 (CEST)
Miroslav Benes <mbenes@suse.cz> wrote:

> On Thu, 10 Oct 2019, Steven Rostedt wrote:
> 
> > On Thu, 10 Oct 2019 10:50:35 +0200
> > Petr Mladek <pmladek@suse.com> wrote:
> >   
> > > It will make the flag unusable for other ftrace users. But it
> > > will be already be the case when it can't be disabled.  
> > 
> > Honestly, I hate that flag. Most people don't even know about it. It
> > was added in the beginning of ftrace as a way to stop function tracing
> > in the latency tracer. But that use case has been obsoleted by
> > 328df4759c03e ("tracing: Add function-trace option to disable function
> > tracing of latency tracers"). I may just remove the damn thing and only
> > add it back if somebody complains about it.  
> 
> That would of course solve the issue too and code removal is always 
> better.
>

Yes, but let's still add the patch that does the permanent check. And
then I'll put the "remove this flag" patch on top (and revert
everything else). This way, if somebody complains, and Linus reverts
the removal patch, we don't end up breaking live kernel patching
again ;-)

-- Steve
