Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 093591AADA9
	for <lists+live-patching@lfdr.de>; Wed, 15 Apr 2020 18:32:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2410351AbgDOQRW (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 15 Apr 2020 12:17:22 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:21252 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2410347AbgDOQRU (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 15 Apr 2020 12:17:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586967439;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MmQx0dVAk47tc0qbdb/pjLy+NqzcVcD5V6FFezqkxFQ=;
        b=KwSFo2KNk12iAz35hNtXpwVJqxdXP2GlsNi+LEsfC0Udds0Z/KoLJCVmj8SqxZhdQ168T2
        JcsmbB8oXDvvxhEgJWTvZsaEOVIrk3LYu7t73h1lqHFKOWyysR7WBnor0QBSJtUeZ5TuAd
        7EayHxP45HvbR/orZwo2vCHKgN4Hhfc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-467-6TTB5x0aOfKoaNrm9VTKRQ-1; Wed, 15 Apr 2020 12:17:17 -0400
X-MC-Unique: 6TTB5x0aOfKoaNrm9VTKRQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 15133101000A;
        Wed, 15 Apr 2020 16:17:09 +0000 (UTC)
Received: from treble (ovpn-116-146.rdu2.redhat.com [10.10.116.146])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 61CCF1001DD8;
        Wed, 15 Apr 2020 16:17:08 +0000 (UTC)
Date:   Wed, 15 Apr 2020 11:17:06 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jessica Yu <jeyu@kernel.org>
Subject: Re: [PATCH 0/7] livepatch,module: Remove .klp.arch and
 module_disable_ro()
Message-ID: <20200415161706.3tw5o4se2cakxmql@treble>
References: <cover.1586881704.git.jpoimboe@redhat.com>
 <20200414182726.GF2483@worktop.programming.kicks-ass.net>
 <20200414190814.glra2gceqgy34iyx@treble>
 <20200415142415.GH20730@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200415142415.GH20730@hirez.programming.kicks-ass.net>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, Apr 15, 2020 at 04:24:15PM +0200, Peter Zijlstra wrote:
> > It bothers me that both the notifiers and the module init() both see the
> > same MODULE_STATE_COMING state, but only in the former case is the text
> > writable.
> > 
> > I think it's cognitively simpler if MODULE_STATE_COMING always means the
> > same thing, like the comments imply, "fully formed" and thus
> > not-writable:
> > 
> > enum module_state {
> > 	MODULE_STATE_LIVE,	/* Normal state. */
> > 	MODULE_STATE_COMING,	/* Full formed, running module_init. */
> > 	MODULE_STATE_GOING,	/* Going away. */
> > 	MODULE_STATE_UNFORMED,	/* Still setting it up. */
> > };
> > 
> > And, it keeps tighter constraints on what a notifier can do, which is a
> > good thing if we can get away with it.
> 
> Moo! -- but jump_label and static_call are on the notifier chain and I
> was hoping to make it cheaper for them. Should we perhaps weane them off the
> notifier and, like ftrace/klp put in explicit calls?
> 
> It'd make the error handling in prepare_coming_module() a bigger mess,
> but it should work.

So you're wanting to have jump labels and static_call do direct writes
instead of text pokes, right?  Makes sense.

I don't feel strongly about "don't let module notifiers modify text".

But I still not a fan of the fact that COMING has two different
"states".  For example, after your patch, when apply_relocate_add() is
called from klp_module_coming(), it can use memcpy(), but when called
from klp module init() it has to use text poke.  But both are COMING so
there's no way to look at the module state to know which can be used.

I hate to say it, but it almost feels like another module state would be
useful.

-- 
Josh

